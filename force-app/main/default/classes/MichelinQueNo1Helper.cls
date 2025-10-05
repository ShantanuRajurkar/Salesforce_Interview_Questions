/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 10-05-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class MichelinQueNo1Helper {
    // Prevent double processing within same transaction for same account
    private static Set<Id> processedAccountIds = new Set<Id>();

    /**
     * Main entry - bulk-safe
     */
    public static void processAccountsForRevenue(List<Account> accounts) {
        if (accounts == null || accounts.isEmpty()) return;

        // Filter out accounts already processed in this transaction
        List<Account> work = new List<Account>();
        for (Account a : accounts) {
            if (a.Id == null) continue;
            if (!processedAccountIds.contains(a.Id)) {
                work.add(a);
                processedAccountIds.add(a.Id);
            }
        }
        if (work.isEmpty()) return;

        Set<Id> acctIds = new Set<Id>();
        for (Account a : work) acctIds.add(a.Id);

        // 1) Delete existing Revenue__c records for these accounts to keep idempotency on updates
        List<Revenue__c> existingRevs = [SELECT Id, Account__c FROM Revenue__c WHERE Account__c IN :acctIds];
        if (!existingRevs.isEmpty()) {
            delete existingRevs;
        }

        // 2) Query contacts per account
        Map<Id, List<Contact>> contactsByAccount = new Map<Id, List<Contact>>();
        for (Contact c : [SELECT Id, AccountId FROM Contact WHERE AccountId IN :acctIds ORDER BY Id]) {
            if (!contactsByAccount.containsKey(c.AccountId)) contactsByAccount.put(c.AccountId, new List<Contact>());
            contactsByAccount.get(c.AccountId).add(c);
        }

        List<Revenue__c> toInsert = new List<Revenue__c>();

        // 3) For each account compute allocations
        for (Account acc : work) {
            Decimal totalValue = acc.Total_Contract_Value__c != null ? acc.Total_Contract_Value__c.setScale(2, RoundingMode.HALF_UP) : 0;
            Integer termYears = acc.Contract_Term__c != null ? Integer.valueOf(acc.Contract_Term__c.intValue()) : 0;
            Date fiscalStart = acc.Fiscal_Year_Start__c;

            if (termYears <= 0) continue;

            // base revenue per year (round cents down for base)
            Decimal rawPerYear = totalValue / termYears;
            Decimal basePerYear = rawPerYear.setScale(2, RoundingMode.DOWN);

            // remainder to add to last year
            Decimal remainder = totalValue - (basePerYear * termYears);
            remainder = remainder.setScale(2, RoundingMode.HALF_UP);

            List<Contact> contacts = contactsByAccount.containsKey(acc.Id) ? contactsByAccount.get(acc.Id) : new List<Contact>();
            Integer numContacts = contacts.size();

            // for each fiscal year, compute yearAmount and split among contacts (or create one record with contact null)
            for (Integer y = 0; y < termYears; y++) {
                Decimal yearAmount = basePerYear;
                if (y == termYears - 1) {
                    yearAmount = yearAmount + remainder;
                }
                yearAmount = yearAmount.setScale(2, RoundingMode.HALF_UP);

                if (numContacts > 0) {
                    // split equally across contacts, round DOWN each share, leftover to last contact
                    Decimal rawPerContact = yearAmount / numContacts;
                    Decimal perContactBase = rawPerContact.setScale(2, RoundingMode.DOWN);
                    Decimal perContactRemainder = yearAmount - (perContactBase * numContacts);
                    perContactRemainder = perContactRemainder.setScale(2, RoundingMode.HALF_UP);

                    for (Integer i = 0; i < numContacts; i++) {
                        Decimal amountForContact = perContactBase;
                        // give remainder cents to last contact
                        if (i == numContacts - 1) {
                            amountForContact = amountForContact + perContactRemainder;
                        }
                        Revenue__c r = new Revenue__c();
                        r.Account__c = acc.Id;
                        r.Contact__c = contacts[i].Id;
                        r.Revenue_Amount__c = amountForContact.setScale(2, RoundingMode.HALF_UP);
                        r.Fiscal_Year__c = Integer.valueOf(fiscalStart.year() + y);
                        toInsert.add(r);
                    }
                } else {
                    // no contacts - create a revenue record linked only to account
                    Revenue__c r = new Revenue__c();
                    r.Account__c = acc.Id;
                    r.Revenue_Amount__c = yearAmount.setScale(2, RoundingMode.HALF_UP);
                    r.Fiscal_Year__c = Integer.valueOf(fiscalStart.year() + y);
                    toInsert.add(r);
                }
            }
        }
        if (!toInsert.isEmpty()) {
            insert toInsert;
        }
    }

    /**
     * Helper to clear processed set (useful for tests)
     */
    @TestVisible
    public static void clearProcessedCache() {
        processedAccountIds.clear();
    }
}
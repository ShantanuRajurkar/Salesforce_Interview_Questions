/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 05-24-2025
 * @last modified by  : Shantanu Rajurkar
**/
public class GlobantQueNo3Helper {
    public static void processAccounts(List<Account> newAccounts) {
        List<Opportunity> oppToInsert = new List<Opportunity>();
        Map<Id, Account> accIdToAccountMap = new Map<Id, Account>();
        Map<Id, Integer> accIdToExpectedOppCount = new Map<Id, Integer>();

        for (Account acc : newAccounts) {
            if (acc.Total_Opportunities__c != null && acc.Total_Opportunities__c > 0) {
                accIdToAccountMap.put(acc.Id, acc);
                accIdToExpectedOppCount.put(acc.Id, Integer.valueOf(acc.Total_Opportunities__c));
                for (Integer i = 0; i < acc.Total_Opportunities__c; i++) {
                    oppToInsert.add(new Opportunity(
                        Name = 'Opportunity ' + (i + 1),
                        AccountId = acc.Id,
                        CloseDate = Date.today().addDays(30),
                        StageName = 'Prospecting'
                    ));
                }
            }
        }

        List<Database.SaveResult> oppInsertResults = Database.insert(oppToInsert, false);

        Map<Id, Integer> insertedCountMap = new Map<Id, Integer>();
        Map<Id, String> errorMap = new Map<Id, String>();

        for (Integer i = 0; i < oppInsertResults.size(); i++) {
            Opportunity opp = oppToInsert[i];
            Database.SaveResult result = oppInsertResults[i];
            if (result.isSuccess()) {
                insertedCountMap.put(
                    opp.AccountId,
                    insertedCountMap.containsKey(opp.AccountId)
                        ? insertedCountMap.get(opp.AccountId) + 1
                        : 1
                );
            } else {
                if (!errorMap.containsKey(opp.AccountId)) {
                    errorMap.put(opp.AccountId, result.getErrors()[0].getMessage());
                }
            }
        }

        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accIdToAccountMap.keySet()) {
            Account acc = new Account(Id = accId);
            Integer expected = accIdToExpectedOppCount.get(accId);
            Integer inserted = insertedCountMap.containsKey(accId) ? insertedCountMap.get(accId) : 0;

            if (inserted == expected) {
                acc.Opportunity_Status__c = 'all opp inserted';
            } else if (inserted > 0 && inserted < expected) {
                acc.Opportunity_Status__c = 'partial opp inserted';
            } else {
                acc.Opportunity_Status__c = errorMap.containsKey(accId) ? errorMap.get(accId) : 'Unknown error';
            }

            accountsToUpdate.add(acc);
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}
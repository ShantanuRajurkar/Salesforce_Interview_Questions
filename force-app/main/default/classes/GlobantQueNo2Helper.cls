/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 04-07-2025
 * @last modified by  : Shantanu Rajurkar
**/
public class GlobantQueNo2Helper {
    // Static flags to prevent recursive calls
    private static Boolean isContactProcessing = false;
    private static Boolean isAccountProcessing = false;
    
    /**
     * Processes Contact updates:
     * - When a primary Contact (IsPrimaryContact__c = true) is updated,
     *   it recalculates the most recently modified primary Contact for each Account.
     * - The Account's Phone is updated to match that Contact's Phone if needed.
     */
    public static void processContacts(List<Contact> newContacts) {
        if (isContactProcessing) return;
        isContactProcessing = true;
        
        // Gather Account Ids from updated Contacts marked as Primary
        Set<Id> accountIds = new Set<Id>();
        for (Contact c : newContacts) {
            if (c.IsPrimaryContact__c == true && c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }
        if (accountIds.isEmpty()) {
            isContactProcessing = false;
            return;
        }
        
        // Query all primary Contacts for these Accounts
        Map<Id, List<Contact>> accountToContacts = new Map<Id, List<Contact>>();
        for (Contact c : [SELECT Id, AccountId, Phone, LastModifiedDate, IsPrimaryContact__c
                          FROM Contact 
                          WHERE AccountId IN :accountIds AND IsPrimaryContact__c = true]) {
            if (!accountToContacts.containsKey(c.AccountId)) {
                accountToContacts.put(c.AccountId, new List<Contact>());
            }
            accountToContacts.get(c.AccountId).add(c);
        }
        
        // Query current Account records
        Map<Id, Account> accountsMap = new Map<Id, Account>(
            [SELECT Id, Phone FROM Account WHERE Id IN :accountIds]
        );
        
        List<Account> accountsToUpdate = new List<Account>();
        // For each Account, determine the most recently modified primary Contact
        for (Id accId : accountsMap.keySet()) {
            List<Contact> primaryContacts = accountToContacts.get(accId);
            if (primaryContacts == null || primaryContacts.isEmpty()) continue;
            
            // Sort contacts in descending order by LastModifiedDate using a helper method
            sortContactsByLastModifiedDesc(primaryContacts);
            Contact mostRecent = primaryContacts[0];
            
            // Update the Account if its Phone is different from the most recent primary Contact’s Phone
            if (accountsMap.get(accId).Phone != mostRecent.Phone) {
                accountsToUpdate.add(new Account(Id = accId, Phone = mostRecent.Phone));
            }
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
        isContactProcessing = false;
    }
    
    /**
     * Processes Account updates:
     * - When an Account’s Phone is changed, update all primary Contacts (IsPrimaryContact__c = true)
     *   that haven't been updated in the last hour.
     */
    public static void processAccounts(List<Account> newAccounts, Map<Id, Account> oldMap) {
        if (isAccountProcessing) return;
        isAccountProcessing = true;
        
        List<Account> changedAccounts = new List<Account>();
        // Identify Accounts with a Phone change
        for (Account acc : newAccounts) {
            Account oldAcc = oldMap.get(acc.Id);
            if (acc.Phone != oldAcc.Phone) {
                changedAccounts.add(acc);
            }
        }
        if (changedAccounts.isEmpty()) {
            isAccountProcessing = false;
            return;
        }
        
        // Gather Account Ids that changed
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : changedAccounts) {
            accountIds.add(acc.Id);
        }
        
        // Query related primary Contacts
        List<Contact> primaryContacts = [SELECT Id, AccountId, Phone, LastModifiedDate, IsPrimaryContact__c
                                         FROM Contact
                                         WHERE AccountId IN :accountIds AND IsPrimaryContact__c = true];
        
        List<Contact> contactsToUpdate = new List<Contact>();
        DateTime nowDT = System.now();
        // Update Contacts if their LastModifiedDate is older than 1 hour and phone is different
        for (Contact c : primaryContacts) {
            Long diffInMs = nowDT.getTime() - c.LastModifiedDate.getTime();
            if (diffInMs > 3600000) { // 1 hour = 3,600,000 milliseconds
                // Find the related Account in the changed list
                for (Account acc : changedAccounts) {
                    if (acc.Id == c.AccountId && c.Phone != acc.Phone) {
                        contactsToUpdate.add(new Contact(Id = c.Id, Phone = acc.Phone));
                        break;
                    }
                }
            }
        }
        
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
        isAccountProcessing = false;
    }
    
    /**
     * Sorts a list of Contacts in descending order by LastModifiedDate.
     * This is a simple bubble sort suitable for small lists.
     */
    private static void sortContactsByLastModifiedDesc(List<Contact> contacts) {
        for (Integer i = 0; i < contacts.size() - 1; i++) {
            for (Integer j = i + 1; j < contacts.size(); j++) {
                // Compare LastModifiedDate; swap if necessary
                if (contacts[i].LastModifiedDate < contacts[j].LastModifiedDate) {
                    Contact temp = contacts[i];
                    contacts[i] = contacts[j];
                    contacts[j] = temp;
                }
            }
        }
    }
}

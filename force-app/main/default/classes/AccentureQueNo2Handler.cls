/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 07-15-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class AccentureQueNo2Handler {
    /** Called after new contacts are inserted */
    public static void handleAfterInsert(List<Contact> newContacts) {
        Set<Id> acctIds = new Set<Id>();
        // Collect Account IDs from new contacts
        for (Contact c : newContacts) {
            if (c.AccountId != null) acctIds.add(c.AccountId);
        }
        // Delegate to helper logic
        AccentureQueNo2Helper.updateRecentContactFlags(acctIds);
    }
    
    /** Called after contacts are deleted */
    public static void handleAfterDelete(List<Contact> deletedContacts) {
        Set<Id> acctIds = new Set<Id>();
        // Collect Account IDs from deleted contacts
        for (Contact c : deletedContacts) {
            if (c.AccountId != null) acctIds.add(c.AccountId);
        }
        // Delegate to helper logic
        AccentureQueNo2Helper.updateRecentContactFlags(acctIds);
    }
}
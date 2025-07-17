/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 07-17-2025
 * @last modified by  : Shantanu Rajurkar
**/

// Helper Class: AccentureQueNo2Helper
public with sharing class AccentureQueNo2Helper {
    public static void updateRecentContactFlags(Set<Id> acctIds) {
        if (acctIds.isEmpty()) return;
        List<Contact> contacts = [
            SELECT Id, AccountId, CreatedDate, Is_Recent__c
            FROM Contact
            WHERE AccountId IN :acctIds
        ];
        Map<Id, Contact> newestByAccount = new Map<Id, Contact>();
        for (Contact c : contacts) {
            if (!newestByAccount.containsKey(c.AccountId)
                || c.CreatedDate > newestByAccount.get(c.AccountId).CreatedDate) {
                newestByAccount.put(c.AccountId, c);
            }
        }
        List<Contact> toUpdate = new List<Contact>();
        for (Contact c : contacts) {
            Boolean shouldBeRecent = (newestByAccount.get(c.AccountId).Id == c.Id);
            if (c.Is_Recent__c != shouldBeRecent) {
                c.Is_Recent__c = shouldBeRecent;
                toUpdate.add(c);
            }
        }
        system.debug('Updating ' + toUpdate.size() + ' contacts for recent flag');
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }
}
/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 09-02-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class NagarooQueNo1Handler {
    public static void beforeInsertContacts(List<Contact> newContacts){
        Set<Id> accIds = new Set<Id>();
        map<Id, String> accIdToAddressMap = new map<Id, String>();
        for (Contact c : newContacts) {
            if (c.AccountId != null && c.Is_Active__c == true) {
                accIds.add(c.AccountId);
            }
        }
        system.debug('Account Ids: ' + accIds);
        for(Account acc : [SELECT Id, Address__c FROM Account WHERE Id IN :accIds]){
            accIdToAddressMap.put(acc.Id, acc.Address__c);
        }
        NagarooQueNo1Helper.populateAccountAddToContact(accIds, newContacts, accIdToAddressMap);
    }

    public static void afterUpdateContacts(list<Contact> newContacts, map<Id, Contact> conOldMap){
        set<Id> conId = new set<Id>();
        map<Id, String> conIdToAddressMap = new map<Id, String>();
        for(Contact con : newContacts){
            if(con.Contact_Address__c != conOldMap.get(con.Id).Contact_Address__c && con.Contact_Address__c != null && con.Is_Active__c == true){
                conIdToAddressMap.put(con.Id, con.Contact_Address__c);
            }
        }
        NagarooQueNo1Helper.populateContactAddToAccountAndContact(conIdToAddressMap);
    }
}
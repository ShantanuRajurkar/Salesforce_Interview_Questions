/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 09-02-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class NagarooQueNo1Helper {
    public static void populateAccountAddToContact(List<Contact> newContacts, map<Id, String> accIdToAddressMap){
        for(Contact con : newContacts){
            if(accIdToAddressMap.keySet().contains(con.AccountId)) {
                con.Contact_Address__c = accIdToAddressMap.get(con.AccountId);
                system.debug('Contact Address populated: ' + con.Contact_Address__c);
            }
        }
    }
    public static void populateContactAddToAccountAndContact(map<Id, String> conIdToAddressMap){
        list<Account> accToUpdate = new list<Account>();
        for(Contact con : [SELECT Id, Name, Contact_Address__c, Account.Address__c FROM Contact WHERE Id IN :conIdToAddressMap.keySet()]){
            Account acc = new Account();
            acc = con.Account;
            acc.Address__c = con.Contact_Address__c;
            accToUpdate.add(acc);
        }

        if(!accToUpdate.isEmpty()){
            update accToUpdate;

            set<Id> accIds = new set<Id>();
            list<Contact> conToUpdate = new list<Contact>();
            for(Account acc : accToUpdate){
                accIds.add(acc.Id);
            }

            for(Contact con : [SELECT Id, Name, Contact_Address__c, Account.Address__c, Is_Active__c FROM Contact WHERE AccountId IN: accIds AND Id NOT IN :conIdToAddressMap.keyset()]){
                if(con.Is_Active__c == true){
                    con.Contact_Address__c = con.Account.Address__c;
                    conToUpdate.add(con);
                }
            }

            if(!conToUpdate.isEmpty()){
                update conToUpdate;
            }
        }
    }
}
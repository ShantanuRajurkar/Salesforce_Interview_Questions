/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 07-06-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class InfosysQueNo1Helper {
    public static void afterUpdateHelper(set<Id> updatedAccounts) {
        list<Contact> conToUpdate = new list<Contact>();
        Map<Id, Decimal> accountIdToProfitMap = new Map<Id, Decimal>();
        for(Account acc : [SELECT Id, Profit__c, (SELECT Id, Profit_Share__C FROM Contacts) FROM Account WHERE Id IN :updatedAccounts]){
            if(acc.Contacts.size() == 0) {
                continue; // Skip accounts with no contacts
            }
            // Calculate profit share for each contact
            accountIdToProfitMap.put(acc.Id, acc.Contacts.size());
        }
        for(Contact con : [SELECT Id, AccountId, Account.Profit__c, Profit_Share__c FROM Contact WHERE AccountId IN :accountIdToProfitMap.keySet()]){
            con.Profit_Share__c = con.Account.Profit__c/accountIdToProfitMap.get(con.AccountId);
            conToUpdate.add(con);
        }
        if(!conToUpdate.isEmpty()) {
            update conToUpdate;
        }
    }
}
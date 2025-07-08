/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 07-08-2025
 * @last modified by  : Shantanu Rajurkar
**/

/*
Problem Statement:-
Distribute the updated Account.Profit__c amount equally among all related Contacts and 
update each Contact's Profit_Share__c accordingly.
*/

public with sharing class InfosysQueNo1Handler {
    public static void handleAfterUpdate(List<Account> newAccounts, Map<Id, Account> oldMap) {
        set<Id> updatedAccountIds = new Set<Id>();
        for(Account acc : newAccounts){
            if(acc.Profit__c != null && acc.Profit__c != oldMap.get(acc.Id).Profit__c){
                updatedAccountIds.add(acc.Id);
            }
        }
        if(!updatedAccountIds.isEmpty()) {
            InfosysQueNo1Helper.afterUpdateHelper(updatedAccountIds);
        }
    }
}
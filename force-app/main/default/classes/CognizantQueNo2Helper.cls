/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 06-07-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class CognizantQueNo2Helper {
    public static void updateTop3ClosedWon(Set<Id> accountIds) {
        // Query Closed Won Opportunities
        List<Opportunity> wonOpps = [
            SELECT AccountId, Amount
            FROM Opportunity
            WHERE AccountId IN :accountIds
              AND IsWon = true
              AND Amount != null
            ORDER BY AccountId, Amount DESC
        ];
        system.debug('Won Opportunities: ' + wonOpps);
        // Group opportunities by AccountId
        Map<Id, List<Opportunity>> oppMap = new Map<Id, List<Opportunity>>();
        for (Opportunity opp : wonOpps) {
            if (!oppMap.containsKey(opp.AccountId)) {
                oppMap.put(opp.AccountId, new List<Opportunity>());
            }
            oppMap.get(opp.AccountId).add(opp);
        }
        system.debug('Grouped Opportunities: ' + oppMap);
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accountIds) {
            if (oppMap.containsKey(accId)) {
                List<Opportunity> oppList = oppMap.get(accId);
                Account acc = new Account(Id = accId);
                acc.Top1_Won__c = oppList.size() > 0 ? oppList[0].Amount : null;
                acc.Top2_Won__c = oppList.size() > 1 ? oppList[1].Amount : null;
                acc.Top3_Won__c = oppList.size() > 2 ? oppList[2].Amount : null;
                accountsToUpdate.add(acc);
            }
        }

        if (!accountsToUpdate.isEmpty()) {
            try {
                update accountsToUpdate;
            } catch (DmlException e) {
                System.debug('Failed to update Accounts: ' + e.getMessage());
            }
        }
    }
}
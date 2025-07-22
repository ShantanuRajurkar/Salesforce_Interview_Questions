/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 07-20-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class PWCQueNo1Handler {
    public static void handleAfterInsert(List<Opportunity> newOpps) {
        Set<Id> acctIds = new Set<Id>();
        for (Opportunity opp : newOpps) {
            if (opp.AccountId != null) acctIds.add(opp.AccountId);
        }
        PWCQueNo1Helper.updateAccountTopStage(acctIds);
    }

    public static void handleAfterUpdate(List<Opportunity> newOpps, Map<Id, Opportunity> oldMap) {
        Set<Id> acctIds = new Set<Id>();
        for (Opportunity opp : newOpps) {
            Opportunity oldOpp = oldMap.get(opp.Id);
            if (opp.AccountId != null && (opp.StageName != oldOpp.StageName || opp.AccountId != oldOpp.AccountId)) {
                acctIds.add(opp.AccountId);
                if (oldOpp.AccountId != null) acctIds.add(oldOpp.AccountId);
            }
        }
        PWCQueNo1Helper.updateAccountTopStage(acctIds);
    }
}
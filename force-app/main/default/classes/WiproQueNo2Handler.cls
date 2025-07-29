/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 07-29-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class WiproQueNo2Handler {
    public static void handleAfterInsert(List<Opportunity> newOpps) {
        Set<Id> acctIds = new Set<Id>();
        for (Opportunity opp : newOpps) {
            if (opp.StageName == 'Closed Lost' && opp.AccountId != null) {
                acctIds.add(opp.AccountId);
            }
        }
        WiproQueNo2Helper.evaluateChurnRisk(acctIds);
    }

    public static void handleAfterUpdate(List<Opportunity> newOpps, Map<Id, Opportunity> oldMap) {
        Set<Id> acctIds = new Set<Id>();
        for (Opportunity opp : newOpps) {
            Opportunity oldOpp = oldMap.get(opp.Id);
            if (opp.AccountId != null &&
                oldOpp.StageName != 'Closed Lost' &&
                opp.StageName == 'Closed Lost') {
                acctIds.add(opp.AccountId);
            }
        }
        WiproQueNo2Helper.evaluateChurnRisk(acctIds);
    }
}
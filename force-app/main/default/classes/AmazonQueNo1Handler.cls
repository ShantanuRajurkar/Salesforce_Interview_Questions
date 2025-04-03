/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 04-03-2025
 * @last modified by  : Shantanu Rajurkar
**/
public class AmazonQueNo1Handler {
    
    public static void handleBeforeUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        
        // Prevent recursion if needed (usually less critical in before context, but can still be used)
        if (AmazonQueNo1Control.isTriggerExecuted) return;
        AmazonQueNo1Control.isTriggerExecuted = true;
        
        // Collect Opportunities that just reached "Closed Won"
        List<Opportunity> opportunitiesToProcess = new List<Opportunity>();
        for (Opportunity opp : newList) {
            Opportunity oldOpp = oldMap.get(opp.Id);
            if (opp.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won') {
                opportunitiesToProcess.add(opp);
            }
        }
        if (opportunitiesToProcess.isEmpty()) return;
        
        // Collect Account IDs from these Opportunities
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : opportunitiesToProcess) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
        
        // Query historical "Closed Won" Opportunities for the same Accounts (excluding current ones)
        List<Opportunity> historicalOpps = [
            SELECT Id, AccountId, Discount__c, CloseDate 
            FROM Opportunity 
            WHERE AccountId IN :accountIds
            AND StageName = 'Closed Won'
            AND Id NOT IN :opportunitiesToProcess
        ];
        
        // Map historical Opportunities by Account
        Map<Id, List<Opportunity>> accountHistoricalOppMap = new Map<Id, List<Opportunity>>();
        for (Opportunity histOpp : historicalOpps) {
            if (!accountHistoricalOppMap.containsKey(histOpp.AccountId)) {
                accountHistoricalOppMap.put(histOpp.AccountId, new List<Opportunity>());
            }
            accountHistoricalOppMap.get(histOpp.AccountId).add(histOpp);
        }
        
        // Calculate and assign Bonus Discount for each Opportunity using the helper
        for (Opportunity opp : opportunitiesToProcess) {
            List<Opportunity> histOpps = accountHistoricalOppMap.get(opp.AccountId);
            Decimal bonusDiscount = AmazonQueNo1Helper.calculateBonusDiscount(opp, histOpps);
            opp.Bonus_Discount__c = bonusDiscount;
        }
    }
}

/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 06-07-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class CognizantQueNo2Handler {
    /**
     * Handles Opportunity trigger context, extracts Account IDs and calls helper.
     * @param oppList List of Opportunity records (new or old)
     */
    public static void handleTrigger(List<Opportunity> oppList) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : oppList) {
            // Only consider Opportunities tied to Accounts
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
        if (!accountIds.isEmpty()) {
            CognizantQueNo2Helper.updateTop3ClosedWon(accountIds);
        }
    }
}
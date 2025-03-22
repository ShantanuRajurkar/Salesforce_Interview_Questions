/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 03-22-2025
 * @last modified by  : Shantanu Rajurkar
**/
// Handler Class (Renamed)
public class TwilioQueNo1Handler {
    private static final String CLOSED_WON_STAGE = 'Closed Won';
    
    public static void handleAfterInsertUpdate(List<Opportunity> newOpps, Map<Id, Opportunity> oldMap, Boolean isInsert) {
        List<Opportunity> relevantOpps = new List<Opportunity>();
        
        for (Opportunity opp : newOpps) {
            if (isInsert) {
                if (isValidClosedWonOpportunity(opp, null)) {
                    relevantOpps.add(opp);
                }
            } else {
                Opportunity oldOpp = oldMap.get(opp.Id);
                if (isValidClosedWonOpportunity(opp, oldOpp)) {
                    relevantOpps.add(opp);
                }
            }
        }
        
        if (!relevantOpps.isEmpty()) {
            TwilioQueNo1Helper.updateAccountRating(relevantOpps);
        }
    }
    
    private static Boolean isValidClosedWonOpportunity(Opportunity newOpp, Opportunity oldOpp) {
        return newOpp.AccountId != null &&
               newOpp.StageName == CLOSED_WON_STAGE &&
               (oldOpp == null || oldOpp.StageName != CLOSED_WON_STAGE);
    }
}
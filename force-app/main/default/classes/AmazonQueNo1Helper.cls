/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 04-03-2025
 * @last modified by  : Shantanu Rajurkar
**/
public class AmazonQueNo1Helper {
    public static Decimal calculateBonusDiscount(Opportunity currentOpp, List<Opportunity> historicalOpps) {
        // If no historical data, default to the current discount (or zero)
        if (historicalOpps == null || historicalOpps.isEmpty()) {
            return currentOpp.Discount__c != null ? currentOpp.Discount__c : 0;
        }
        
        Decimal weightedSum = 0;
        Decimal totalWeight = 0;
        Date currentCloseDate = currentOpp.CloseDate;
        
        // Iterate through historical Opportunities to calculate weighted average discount
        for (Opportunity opp : historicalOpps) {
            Decimal discount = opp.Discount__c != null ? opp.Discount__c : 0;
            // Calculate days difference; use absolute value to avoid negative weights
            Integer daysDifference = Math.abs(currentCloseDate.daysBetween(opp.CloseDate));
            // Simple time decay: more recent records get higher weight
            Decimal weight = 1 / (1 + daysDifference);
            weightedSum += discount * weight;
            totalWeight += weight;
        }
        
        return totalWeight > 0 ? weightedSum / totalWeight : 0;
    }
}

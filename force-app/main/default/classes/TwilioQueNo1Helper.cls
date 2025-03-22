/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 03-22-2025
 * @last modified by  : Shantanu Rajurkar
**/
// Helper Class (Renamed)
public class TwilioQueNo1Helper {
    private static final String CLOSED_WON_STAGE = 'Closed Won';
    private static final String HOT_RATING = 'Hot';
    
    public static void updateAccountRating(List<Opportunity> opportunities) {
        Set<Id> accountIds = getAccountIds(opportunities);
        if (accountIds.isEmpty()) return;
        
        Map<Id, Account> accountMap = getAccountsWithRating(accountIds);
        Map<Id, Integer> closedWonCounts = getClosedWonCounts(accountIds);
        
        List<Account> accountsToUpdate = calculateAccountsToUpdate(accountIds, accountMap, closedWonCounts);
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    
    private static Set<Id> getAccountIds(List<Opportunity> opportunities) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : opportunities) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
        return accountIds;
    }
    
    private static Map<Id, Account> getAccountsWithRating(Set<Id> accountIds) {
        return new Map<Id, Account>([
            SELECT Id, Rating 
            FROM Account 
            WHERE Id IN :accountIds
        ]);
    }
    
    private static Map<Id, Integer> getClosedWonCounts(Set<Id> accountIds) {
        Map<Id, Integer> counts = new Map<Id, Integer>();
        for (AggregateResult ar : [
            SELECT AccountId accId, COUNT(Id) cnt 
            FROM Opportunity 
            WHERE AccountId IN :accountIds 
            AND StageName = :CLOSED_WON_STAGE 
            GROUP BY AccountId
        ]) {
            counts.put((Id)ar.get('accId'), (Integer)ar.get('cnt'));
        }
        return counts;
    }
    
    private static List<Account> calculateAccountsToUpdate(Set<Id> accountIds, Map<Id, Account> accountMap, Map<Id, Integer> counts) {
        List<Account> updates = new List<Account>();
        for (Id accId : accountIds) {
            Integer count = counts.get(accId) != null ? counts.get(accId) : 0;
            Account acc = accountMap.get(accId);
            
            if (acc != null && count > 3 && acc.Rating != HOT_RATING) {
                updates.add(new Account(Id = accId, Rating = HOT_RATING));
            }
        }
        return updates;
    }
}
/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 07-20-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class PWCQueNo1Helper {
    // Define stage ranking
    private static final Map<String, Integer> stageRank = new Map<String, Integer>{
        'Prospecting' => 1,
        'Qualification' => 2,
        'Needs Analysis' => 3,
        'Value Proposition' => 4,
        'Id. Decision Makers' => 5,
        'Perception Analysis' => 6,
        'Proposal/Price Quote' => 7,
        'Negotiation/Review' => 8,
        'DemoValue' => 9,
        'Closed Lost' => 10,
        'Closed Won' => 11
    };

    public static void updateAccountTopStage(Set<Id> acctIds) {
        if (acctIds.isEmpty()) return;
        // Query open opportunities for these accounts
        List<AggregateResult> agg = [
            SELECT AccountId, MAX(StageName) maxStage
            FROM Opportunity
            WHERE AccountId IN :acctIds AND IsClosed = false
            GROUP BY AccountId
        ];

        Map<Id, String> acctToTop = new Map<Id, String>();
        for (AggregateResult ar : agg) {
            acctToTop.put(
                (Id) ar.get('AccountId'),
                (String) ar.get('maxStage')
            );
        }
        
        // Prepare accounts to update
        List<Account> acctsToUpdate = new List<Account>();
        for (Id acctId : acctIds) {
            String topStage = acctToTop.containsKey(acctId) ? acctToTop.get(acctId) : null;
            Account a = new Account(Id = acctId);
            if (topStage != null) {
                a.Top_Stage__c = topStage;
            } else {
                a.Top_Stage__c = null;
            }
            acctsToUpdate.add(a);
        }
        if (!acctsToUpdate.isEmpty()) {
            update acctsToUpdate;
        }
    }
}
/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 07-29-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class WiproQueNo2Helper {
    private static final Integer WINDOW_DAYS = 180;
    private static final Integer THRESHOLD = 3;

    public static void evaluateChurnRisk(Set<Id> acctIds) {
        if (acctIds.isEmpty()) return;
        Date windowStart = Date.today().addDays(-WINDOW_DAYS);

        List<AggregateResult> results = [
            SELECT AccountId, COUNT(Id) cnt
            FROM Opportunity
            WHERE AccountId IN :acctIds
              AND StageName = 'Closed Lost'
              AND CloseDate >= :windowStart
            GROUP BY AccountId
        ];

        Map<Id, Integer> acctToCount = new Map<Id, Integer>();
        for (AggregateResult ar : results) {
            acctToCount.put(
                (Id) ar.get('AccountId'),
                Integer.valueOf(ar.get('cnt'))
            );
        }

        List<Account> acctsToUpdate = new List<Account>();
        for (Id acctId : acctIds) {
            Integer count = acctToCount.containsKey(acctId) ? acctToCount.get(acctId) : 0;
            Boolean isAtRisk = (count >= THRESHOLD);
            acctsToUpdate.add(new Account(
                Id = acctId,
                At_Risk__c = isAtRisk
            ));
        }
        if (!acctsToUpdate.isEmpty()) {
            update acctsToUpdate;
        }
    }
}
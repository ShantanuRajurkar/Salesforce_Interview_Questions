/* ───────────────────────────────────────────────────────────────────────
   Apex Class: TCSQueNo1Helper
   Responsibility: Core business logic – aggregates closed cases & assigns Rating
──────────────────────────────────────────────────────────────────────── */
public with sharing class TCSQueNo1Helper {

    /**
     * Builds a list of Account records with updated Rating based on closed-case count
     *
     * @param accountIds Set<Id> all Accounts to evaluate
     * @return List<Account> with Id + new Rating
     */
    public static List<Account> getRatedAccounts(Set<Id> accountIds) {
        // 1) Aggregate closed Case counts per Account
        Map<Id, Integer> closedCounts = new Map<Id, Integer>();
        for (AggregateResult ar : [
            SELECT AccountId, COUNT(Id) cnt
            FROM Case
            WHERE AccountId IN :accountIds AND Status = 'Closed'
            GROUP BY AccountId
        ]) {
            closedCounts.put(
                (Id) ar.get('AccountId'),
                (Integer) ar.get('cnt')
            );
        }

        // 2) Build Account updates
        List<Account> updates = new List<Account>();
        for (Id accId : accountIds) {
            Integer cnt = closedCounts.get(accId);
            String rating = 'Cold';
            if (cnt != null) {
                if (cnt > 5) {
                    rating = 'Hot';
                } else if (cnt >= 3) {
                    rating = 'Warm';
                }
            }
            updates.add(new Account(Id = accId, Rating = rating));
        }
        return updates;
    }
}

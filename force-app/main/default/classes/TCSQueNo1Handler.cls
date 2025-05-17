/* ───────────────────────────────────────────────────────────────────────
   Apex Class: TCSQueNo1Handler
   Responsibility: Collects Account IDs from Case context and performs DML
──────────────────────────────────────────────────────────────────────── */
public with sharing class TCSQueNo1Handler {

    /**
     * Entry point from trigger
     *
     * @param newCases   List<Case> for insert/update; null on delete
     * @param oldCaseMap Map<Id,Case> for delete; null otherwise
     * @param isDelete   true if trigger.isDelete
     */
    public static void handle(
        List<Case> newCases,
        Map<Id, Case> oldCaseMap,
        Boolean isDelete
    ) {
        // 1) Gather all Account IDs affected by these Case DMLs
        Set<Id> accountIds = new Set<Id>();
        if (isDelete) {
            for (Case c : oldCaseMap.values()) {
                if (c.AccountId != null) {
                    accountIds.add(c.AccountId);
                }
            }
        } else {
            for (Case c : newCases) {
                if (c.AccountId != null) {
                    accountIds.add(c.AccountId);
                }
            }
        }

        if (accountIds.isEmpty()) {
            return;
        }

        // 2) Compute new Ratings
        List<Account> toUpdate = TCSQueNo1Helper.getRatedAccounts(accountIds);

        // 3) Perform update DML
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }
}

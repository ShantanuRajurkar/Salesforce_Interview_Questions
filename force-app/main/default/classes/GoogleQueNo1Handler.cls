/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 06-15-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class GoogleQueNo1Handler {
    public static void afterUpdateHandler(list<Account> newAccList, map<Id, Account> oldMap) {
        Set<Id> impactedAccountIds = new Set<Id>();

        for (Account acc : newAccList) {
            Account oldAcc = oldMap.get(acc.Id);
            if (acc.Description != oldAcc.Description) {
                impactedAccountIds.add(acc.Id);
            }
        }

        if (!impactedAccountIds.isEmpty()) {
            // Enqueue asynchronous processing
            GoogleQueNo1BatchClass job = new GoogleQueNo1BatchClass(impactedAccountIds);
            Database.executeBatch(job);
        }
    }
}
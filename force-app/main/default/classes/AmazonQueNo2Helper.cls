/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 05-17-2025
 * @last modified by  : Shantanu Rajurkar
**/
public class AmazonQueNo2Helper {
    /**
     * For each newly inserted Opportunity, find all contacts
     * associated with the opportunity's account and its parent accounts.
     * Then create follow-up Tasks for each contact, prioritized by how close
     * their account is to the opportunity's account in the hierarchy.
     */
    public static List<Task> generateTasks(List<Opportunity> opportunities) {
        List<Task> tasks = new List<Task>();
        if (opportunities == null || opportunities.isEmpty()) {
            return tasks;
        }
        
        // 1. Collect unique Account IDs from the opportunities
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : opportunities) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
        if (accountIds.isEmpty()) {
            return tasks;
        }
        
        // 2. Iteratively fetch all ancestor accounts into accountMap
        Map<Id, Account> accountMap = new Map<Id, Account>();
        Set<Id> toProcess = new Set<Id>(accountIds);
        while (!toProcess.isEmpty()) {
            List<Account> parentAccounts = [
                SELECT Id, ParentId 
                FROM Account 
                WHERE Id IN :toProcess
            ];
            Set<Id> nextToProcess = new Set<Id>();
            for (Account acct : parentAccounts) {
                accountMap.put(acct.Id, acct);
                if (acct.ParentId != null && !accountMap.containsKey(acct.ParentId)) {
                    nextToProcess.add(acct.ParentId);
                }
            }
            toProcess = nextToProcess;
        }
        
        // 3. Query all Contacts for these accounts (including ancestors)
        List<Contact> contacts = [
            SELECT Id, AccountId, Name 
            FROM Contact 
            WHERE AccountId IN :accountMap.keySet()
        ];
        Map<Id, List<Contact>> accountContactsMap = new Map<Id, List<Contact>>();
        for (Contact con : contacts) {
            if (!accountContactsMap.containsKey(con.AccountId)) {
                accountContactsMap.put(con.AccountId, new List<Contact>());
            }
            accountContactsMap.get(con.AccountId).add(con);
        }
        
        // 4. Create tasks for each Opportunity-Contact pair
        for (Opportunity opp : opportunities) {
            if (opp.AccountId == null) continue;
            Id currentAccountId = opp.AccountId;
            Integer level = 0;
            // Walk up the account hierarchy for this opportunity
            while (currentAccountId != null) {
                // Determine priority: High=0, Normal=1, Low=2+
                String priority;
                if (level == 0) {
                    priority = 'High';
                } else if (level == 1) {
                    priority = 'Normal';
                } else {
                    priority = 'Low';
                }
                
                // Create a task for each contact under the current account
                if (accountContactsMap.containsKey(currentAccountId)) {
                    for (Contact c : accountContactsMap.get(currentAccountId)) {
                        Task t = new Task();
                        t.WhatId = opp.Id;
                        t.WhoId = c.Id;
                        t.Priority = priority;
                        t.Status = 'Not Started';
                        t.Subject = 'Follow up with ' + c.Name;
                        tasks.add(t);
                    }
                }
                
                // Move up to the parent account
                Account currentAccount = accountMap.get(currentAccountId);
                currentAccountId = (currentAccount != null ? currentAccount.ParentId : null);
                level++;
            }
        }
        
        // 5. Sort tasks by priority: High first, then Normal, then Low
        tasks.sort(new TaskPriorityComparator());
        return tasks;
    }
}
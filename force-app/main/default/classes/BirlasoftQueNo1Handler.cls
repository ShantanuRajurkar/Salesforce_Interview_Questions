/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 04-26-2025
 * @last modified by  : Shantanu Rajurkar
**/
public class BirlasoftQueNo1Handler {
    // Static flag to prevent trigger recursion
    private static Boolean isExecuted = false;

    /**
     * Main entry point for Task__c trigger
     * @param newTasks Map of new Task__c records (Id -> Task__c)
     * @param oldTasks Map of old Task__c records (Id -> Task__c), null for insert
     */
    public static void handle(Map<Id, Task__c> newTasks, Map<Id, Task__c> oldTasks) {
        if (isExecuted) {
            return;
        }
        isExecuted = true;

        // Collect Project IDs from inserted/updated tasks
        Set<Id> projectIds = new Set<Id>();
        for (Task__c t : newTasks.values()) {
            if (t.Project__c != null) projectIds.add(t.Project__c);
        }
        if (oldTasks != null) {
            for (Task__c t : oldTasks.values()) {
                if (t.Project__c != null) projectIds.add(t.Project__c);
            }
        }

        if (!projectIds.isEmpty()) {
            BirlasoftQueNo1Helper.updateProjectStages(projectIds);
        }
    }
}

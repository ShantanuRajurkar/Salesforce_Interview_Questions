/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 04-26-2025
 * @last modified by  : Shantanu Rajurkar
**/
public class BirlasoftQueNo1Helper {
    /**
     * Updates Project__c.Stage__c based on percentage of completed Task__c
     * @param projectIds Set of Project__c record IDs to process
     */
    public static void updateProjectStages(Set<Id> projectIds) {
        // Single aggregate query per metric
        List<AggregateResult> totalResults = [
            SELECT Project__c projId, COUNT(Id) totalCount
            FROM Task__c
            WHERE Project__c IN :projectIds
            GROUP BY Project__c
        ];
        List<AggregateResult> completedResults = [
            SELECT Project__c projId, COUNT(Id) completedCount
            FROM Task__c
            WHERE Project__c IN :projectIds AND Status__c = 'Completed'
            GROUP BY Project__c
        ];

        // Map project Ids to counts
        Map<Id, Integer> totalMap = new Map<Id, Integer>();
        for (AggregateResult ar : totalResults) {
            totalMap.put((Id)ar.get('projId'), (Integer)ar.get('totalCount'));
        }
        Map<Id, Integer> completedMap = new Map<Id, Integer>();
        for (AggregateResult ar : completedResults) {
            completedMap.put((Id)ar.get('projId'), (Integer)ar.get('completedCount'));
        }

        // Build update list
        List<Project__c> projectsToUpdate = new List<Project__c>();
        for (Id projId : projectIds) {
            Integer total = totalMap.containsKey(projId) ? totalMap.get(projId) : 0;
            Integer completed = completedMap.containsKey(projId) ? completedMap.get(projId) : 0;
            Decimal percent = (total > 0) ? (Decimal.valueOf(completed) / total) * 100 : 0;

            Project__c proj = new Project__c(Id = projId);
            proj.Status__c = (percent >= 80) ? 'Ready for QA' : 'In Progress';
            projectsToUpdate.add(proj);
            system.debug('Conpleted: '+completed);
            system.debug('Percent: '+percent);
        }

        if (!projectsToUpdate.isEmpty()) {
            update projectsToUpdate;
        }
    }
}
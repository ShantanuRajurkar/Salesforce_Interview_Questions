/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 05-17-2025
 * @last modified by  : Shantanu Rajurkar
**/
public class AmazonQueNo2Handler {
    public static void handleAfterInsert(List<Opportunity> newOpportunities) {
        // Generate tasks for all new opportunities
        List<Task> tasksToCreate = AmazonQueNo2Helper.generateTasks(newOpportunities);
        // Insert tasks in bulk if any were created
        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
        }
    }
}

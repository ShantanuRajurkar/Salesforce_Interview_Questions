/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 04-26-2025
 * @last modified by  : Shantanu Rajurkar
**/
/*Problem Statement:-
You have a Project__c parent and multiple Task__c children (lookup relationship).
When ≥ 80% of a Project’s Tasks have Status__c = "Completed", set the parent Status__c to "Ready for QA".
If completion dips below 80%, revert Status__c to "In Progress".
*/
trigger BirlasoftQueNo1 on Task__c (after insert, after update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            BirlasoftQueNo1Handler.handle(Trigger.newMap, Trigger.oldMap);
        }
    }
}
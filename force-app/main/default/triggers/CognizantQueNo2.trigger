/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 06-07-2025
 * @last modified by  : Shantanu Rajurkar
**/

/* 
Problem Statement:- 
You're tasked with writing a trigger to update the top 3 Closed-Won Opportunity amounts on an Account.
This challenge assesses your proficiency in Apex triggers, bulk processing, and best practices in Salesforce development.
Key Requirements:
- Efficiently update Top1_Won__c, Top2_Won__c, and Top3_Won__c fields on 
- Trigger must be applicable for delete, undelete, update and insert scenarios.
*/
trigger CognizantQueNo2 on Opportunity (after insert, after update, after delete, after undelete) {
    // Delegate to handler
    if (Trigger.isAfter) {
        List<Opportunity> contextList = Trigger.isDelete ? Trigger.old : Trigger.new;
        CognizantQueNo2Handler.handleTrigger(contextList);
    }
}
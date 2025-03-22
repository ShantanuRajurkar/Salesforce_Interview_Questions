/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 03-22-2025
 * @last modified by  : Shantanu Rajurkar
**/

/*
Problem Statement:- 
When an Opportunity's with StageName inserted or updated to "Closed Won", 
Mark an Account Rating as "Hot" only if they the related Account have 3+ Opportunities with StageName "Closed Won".
*/

trigger TwilioQueNo1 on Opportunity (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            TwilioQueNo1Handler.handleAfterInsertUpdate(Trigger.new, null, true);
        } else if (Trigger.isUpdate) {
            TwilioQueNo1Handler.handleAfterInsertUpdate(Trigger.new, Trigger.oldMap, false);
        }
    }
}
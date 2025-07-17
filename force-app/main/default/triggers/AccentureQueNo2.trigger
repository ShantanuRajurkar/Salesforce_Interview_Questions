/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 07-17-2025
 * @last modified by  : Shantanu Rajurkar
**/

/*
Problem Statement:- 
Ensure that only the newest Contact on each Account has your custom field Is_Recent__c(on Contact object) 
checkbox set to true, every time someone inserts or deletes a Contact.
*/

trigger AccentureQueNo2 on Contact (after insert, after delete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AccentureQueNo2Handler.handleAfterInsert(Trigger.new);
        }
        if (Trigger.isDelete) {
            AccentureQueNo2Handler.handleAfterDelete(Trigger.old);
        }
    }
}
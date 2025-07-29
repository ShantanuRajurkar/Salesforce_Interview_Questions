/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 07-29-2025
 * @last modified by  : Shantanu Rajurkar
**/

/*
Problem Statement:- 
Flag Accounts that have lost 3 or more Opportunities in the last 180 days, 
and do it automatically on every Close  Lost opportunities insert/update event. 
1. Listen for new Close Lost Opportunities inserted/updated
2. Slide a 180‑day window of past Close Lost opportunity counts per Account
3. Flip an At_Risk__c checkbox when the count ≥ 3
*/

trigger WiproQueNo2 on Opportunity (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            WiproQueNo2Handler.handleAfterInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            WiproQueNo2Handler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
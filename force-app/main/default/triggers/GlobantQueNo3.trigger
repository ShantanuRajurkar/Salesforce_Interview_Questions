/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 05-25-2025
 * @last modified by  : Shantanu Rajurkar
**/

/*
Problem Statement:-
On Account (after insert), you have a custom Total_Opportunities__c field that 
dictates how many Opportunity records to create—and you need to update the Account’s Opportunity_Status__c to:
- all opp inserted (if every Opportunity was created)
- partial opp inserted (if only some succeeded)
- <error message> (if none succeeded)
*/
trigger GlobantQueNo3 on Account (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        GlobantQueNo3Handler.handleAfterInsert(Trigger.new);
    }
}
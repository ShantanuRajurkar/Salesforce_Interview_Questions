/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 05-17-2025
 * @last modified by  : Shantanu Rajurkar
**/

/*
Problem Statement:- 
When a new Opportunity is inserted, you must:
1. Traverse its Account hierarchy (graph traversal) to gather that Account and all parent Accounts.
2. Collect every Contact under each of those Accounts.
3. Generate a Task for each (Opportunity, Contact) pair, setting Priority to High (same Account), Normal (1 level up), or Low (2+ levels up).
4. Sort all Tasks so High-priority appear first, then Normal, then Low.
*/

trigger AmazonQueNo2 on Opportunity (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        AmazonQueNo2Handler.handleAfterInsert(Trigger.new);
    }
}


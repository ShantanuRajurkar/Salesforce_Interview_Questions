/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 09-28-2025
 * @last modified by  : Shantanu Rajurkar
**/
/*
Problem Statement:- 
Write a Apex trigger (on Case) that prevents insertion of Cases whose 'Description' is too similar to any existing Case description. 
Similarity is defined as - more than 50% of the words in the new Case description also appear in an existing Case description. 
Comparison must be case-insensitive and ignore punctuation. If a new Case is considered similar, 
the trigger should block that record with a clear message.
*/
trigger USTQueNo1 on Case (before insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            USTQueNo1Handler.handleCaseInsert(Trigger.new);
        }
    }
}
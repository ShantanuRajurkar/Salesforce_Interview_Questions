/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 03-04-2025
 * @last modified by  : Shantanu Rajurkar
**/

/*
Problem Statement:- 
To maintain data integrity and avoid inconsistencies, we need to enforce two critical rules:
1) Prevent role assignment on closed opportunities – Once an opportunity is closed, adding contact roles is unnecessary and could lead to confusion.
2) Avoid duplicate contact roles – A contact should not be assigned the same role multiple times on the same opportunity.
*/

trigger GlobantQueNo1 on OpportunityContactRole (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        GlobantQueNo1Handler.handlerMethod(trigger.new);
    }
}
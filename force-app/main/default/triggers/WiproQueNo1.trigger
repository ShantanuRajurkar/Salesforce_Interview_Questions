/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 07-01-2025
 * @last modified by  : Shantanu Rajurkar
**/


/*
Problem Statement:- 
After a Lead is converted successfully, Account and Contact records are created. 
You need to update the Description field of both the Account and the Contact with the original Lead’s Id and Name.
*/

trigger WiproQueNo1 on Lead (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        WiproQueNo1Handler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}

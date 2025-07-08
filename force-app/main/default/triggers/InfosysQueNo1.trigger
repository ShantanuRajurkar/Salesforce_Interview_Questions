/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 07-08-2025
 * @last modified by  : Shantanu Rajurkar
**/

/*
Problem Statement:-
Distribute the updated Account.Profit__c amount equally among all related Contacts and 
update each Contact's Profit_Share__c accordingly.
*/

trigger InfosysQueNo1 on Account (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        InfosysQueNo1Handler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}
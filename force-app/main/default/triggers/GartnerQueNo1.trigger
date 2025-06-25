/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 06-22-2025
 * @last modified by  : Shantanu Rajurkar
**/

/*
Problem Statement:- 
Block deletion of any Order__c with Status__c == 'Shipped' or that has child Order_Approval__c 
records in Pending status and include the names of those approvals in the error message.

Custom Objects & Key Fields:-

Order__c:
- Status__c (Picklist: New, Processing, Shipped, Canceled)
- Total_Amount__c (Currency)

Order_Approval__c:
- Order__c (Master-Detail)
- Tier__c (Number)
- Status__c (Picklist: Pending, Approved, Rejected)
*/

trigger GartnerQueNo1 on Order__c (before delete) {
    if (Trigger.isBefore && Trigger.isDelete) {
        GartnerQueNo1Handler.handleBeforeDelete(Trigger.old);
    }
}
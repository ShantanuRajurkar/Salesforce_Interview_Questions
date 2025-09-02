/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 09-02-2025
 * @last modified by  : Shantanu Rajurkar
**/

/*
Problem Statement:-
Custom field on Account → Address__c (Text) 
Custom fields on Contact → Contact_Address__c (Text), Is_Active__c (Checkbox)

1) When a Contact is created under an Account with Is_Active__c = true, 
the Account’s Address__c should automatically flow into the Contact’s Contact_Address__c.

2) If an Active Contact’s Contact_Address__c is updated, then it's Account’s Address__c should also be updated with this value.
After that, all Active Contacts under the same Account should sync their Contact_Address__c with the updated Account Address__c.

(Note: You're not allowed to use Account Trigger)
*/

trigger NagarooQueNo1 on Contact (before insert, after update) {
    if (Trigger.isBefore) {
        if(Trigger.isInsert)
            NagarooQueNo1Handler.beforeInsertContacts(Trigger.new);
    }

    if(Trigger.isAfter){
        if(Trigger.isUpdate)
            NagarooQueNo1Handler.afterUpdateContacts(Trigger.new, Trigger.oldMap);
    }
}
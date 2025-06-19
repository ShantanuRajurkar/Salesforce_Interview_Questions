/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 06-15-2025
 * @last modified by  : Shantanu Rajurkar
**/
/*
Problem Statement:- 
An Account can have up to ~50,000 (or more) related Contact records. When a field (Account.Description) on the Account is updated, 
all related Contacts must have the corresponding field (Contact.Description) updated.
*/
trigger GoogleQueNo1 on Account (after update) {
    if(Trigger.isAfter && Trigger.isUpdate) {
        GoogleQueNo1Handler.afterUpdateHandler(Trigger.new, Trigger.oldMap);
    }
}

/*
Problem Statement:- 
An organization needs to dynamically rate its Accounts based on the number of closed Cases. Whenever Cases are inserted, updated, or 
deleted, the Account’s Rating field should automatically reflect the engagement level:
1. Cold – if fewer than 3 closed Cases
2. Warm – if 3 to 5 closed Cases
3. Hot – if more than 5 closed Cases
*/
trigger TCSQueNo1 on Case (after insert, after update, after delete) {
    // Delegate all logic to handler
    if (Trigger.isAfter) {
        TCSQueNo1Handler.handle(
            Trigger.isDelete ? null : Trigger.new,
            Trigger.isDelete ? Trigger.oldMap : null,
            Trigger.isDelete
        );
    }
}

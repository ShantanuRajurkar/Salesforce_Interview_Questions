/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 07-29-2025
 * @last modified by  : Shantanu Rajurkar
**/
trigger WiproQueNo2 on Opportunity (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            WiproQueNo2Handler.handleAfterInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            WiproQueNo2Handler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
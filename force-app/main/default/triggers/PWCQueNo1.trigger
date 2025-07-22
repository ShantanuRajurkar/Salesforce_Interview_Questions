/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 07-20-2025
 * @last modified by  : Shantanu Rajurkar
**/
trigger PWCQueNo1 on Opportunity (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            PWCQueNo1Handler.handleAfterInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            PWCQueNo1Handler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
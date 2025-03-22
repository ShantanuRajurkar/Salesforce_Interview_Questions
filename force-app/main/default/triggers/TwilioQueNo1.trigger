/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 03-22-2025
 * @last modified by  : Shantanu Rajurkar
**/
trigger TwilioQueNo1 on Opportunity (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            TwilioQueNo1Handler.handleAfterInsertUpdate(Trigger.new, null, true);
        } else if (Trigger.isUpdate) {
            TwilioQueNo1Handler.handleAfterInsertUpdate(Trigger.new, Trigger.oldMap, false);
        }
    }
}
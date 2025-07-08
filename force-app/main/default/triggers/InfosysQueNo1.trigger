/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 07-06-2025
 * @last modified by  : Shantanu Rajurkar
**/
trigger InfosysQueNo1 on Account (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        InfosysQueNo1Handler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}
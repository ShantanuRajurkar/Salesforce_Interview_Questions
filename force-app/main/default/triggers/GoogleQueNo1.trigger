/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 06-15-2025
 * @last modified by  : Shantanu Rajurkar
**/
trigger GoogleQueNo1 on Account (after update) {
    if(Trigger.isAfter && Trigger.isUpdate) {
        GoogleQueNo1Handler.afterUpdateHandler(Trigger.new, Trigger.oldMap);
    }
}
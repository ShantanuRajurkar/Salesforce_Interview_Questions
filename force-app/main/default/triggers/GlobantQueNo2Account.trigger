/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 04-07-2025
 * @last modified by  : Shantanu Rajurkar
**/
trigger GlobantQueNo2Account on Account (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        GlobantQueNo2Handler.handleAccount(Trigger.new, Trigger.oldMap);
    }
}

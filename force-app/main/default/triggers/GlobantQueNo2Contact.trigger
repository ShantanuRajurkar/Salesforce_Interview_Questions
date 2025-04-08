/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 04-07-2025
 * @last modified by  : Shantanu Rajurkar
**/
trigger GlobantQueNo2Contact on Contact (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        GlobantQueNo2Handler.handleContact(Trigger.new);
    }
}

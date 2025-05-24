/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 05-24-2025
 * @last modified by  : Shantanu Rajurkar
**/
trigger GlobantQueNo3 on Account (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        GlobantQueNo3Handler.handleAfterInsert(Trigger.new);
    }
}
/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 04-03-2025
 * @last modified by  : Shantanu Rajurkar
**/
trigger AmazonQueNo1 on Opportunity (before update) {
    AmazonQueNo1Handler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
}

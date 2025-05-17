/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 05-17-2025
 * @last modified by  : Shantanu Rajurkar
**/
trigger AmazonQueNo2 on Opportunity (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        AmazonQueNo2Handler.handleAfterInsert(Trigger.new);
    }
}


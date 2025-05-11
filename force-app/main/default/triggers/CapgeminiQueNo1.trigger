/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 05-10-2025
 * @last modified by  : Shantanu Rajurkar
**/
trigger CapgeminiQueNo1 on Reservation__c (before insert, before update, after insert, after update) {
    if (Trigger.isBefore) {
        CapgeminiQueNo1Handler.handleBefore(Trigger.new, Trigger.isInsert);
    }
    if (Trigger.isAfter) {
        CapgeminiQueNo1Handler.handleAfter(Trigger.new);
    }
}
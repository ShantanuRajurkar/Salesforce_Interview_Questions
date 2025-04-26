/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 04-26-2025
 * @last modified by  : Shantanu Rajurkar
**/
trigger BirlasoftQueNo1 on Task__c (after insert, after update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            BirlasoftQueNo1Handler.handle(Trigger.newMap, Trigger.oldMap);
        }
    }
}
/*
Problem Statement:- 
On Account, there’s a checkbox field "Close_Good_Opportunities__c".
When checked, all related Opportunities with a probability > 70% should be automatically closed
*/

trigger AccentureQueNo1 on Account (after update) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            AccentureQueNo1Handler.handlerMethodForUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}

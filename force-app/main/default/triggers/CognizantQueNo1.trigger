/*
Problem Statement:- 
A custom field on Account, "Total_Opportunity_Products__c", should always store the count of related Opportunities' OpportunityLineItem records,
whenever a user creates or deletes an OpportunityLineItem, the field should update accordingly
*/
trigger CognizantQueNo1 on OpportunityLineItem (after insert, after delete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
    		CognizantQueNo1Handler.handlerMethod(Trigger.new);        
        }
        if(Trigger.isDelete){
            CognizantQueNo1Handler.handlerMethod(Trigger.old);        
        }
    }
    
}

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
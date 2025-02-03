trigger AccentureQueNo1 on Account (after update) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            AccentureQueNo1Handler.handlerMethodForUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
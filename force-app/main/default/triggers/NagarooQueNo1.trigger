/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 09-02-2025
 * @last modified by  : Shantanu Rajurkar
**/
trigger NagarooQueNo1 on Contact (before insert, after update) {
    if (Trigger.isBefore) {
        if(Trigger.isInsert)
            NagarooQueNo1Handler.beforeInsertContacts(Trigger.new);
    }

    if(Trigger.isAfter){
        if(Trigger.isUpdate)
            NagarooQueNo1Handler.afterUpdateContacts(Trigger.new, Trigger.oldMap);
    }
}
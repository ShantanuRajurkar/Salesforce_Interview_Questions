/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 07-01-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class WiproQueNo1Handler {
    public static void handleAfterUpdate(list<Lead> newLeads, map<Id, Lead> oldMap) {
        set<Id> convertedLeadIds = new Set<Id>();
        for(Lead leads : newLeads){
            if(leads.IsConverted == true && leads.ConvertedAccountId != null && oldMap.get(leads.Id).IsConverted == false && oldMap.get(leads.Id).ConvertedAccountId == null) {
                system.debug('Lead Converted: ' + leads.Id);
                convertedLeadIds.add(leads.Id);
            }
        }
        if(!convertedLeadIds.isEmpty()) {
            WiproQueNo1Helper.afterUpdateHelper(convertedLeadIds);
        }
        
    }
}

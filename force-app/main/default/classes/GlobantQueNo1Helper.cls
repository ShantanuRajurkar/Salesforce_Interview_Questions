/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 03-04-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class GlobantQueNo1Helper {
    public static void displayError(Set<Id> oppIds, Set<Id> conIds, List<OpportunityContactRole> newRecordList, Map<Id,Opportunity> oppMap, Map<String,OpportunityContactRole> existingRolesMap){
        for(Opportunity opp : [Select Id,IsClosed from Opportunity where Id IN : oppIds]){
            oppMap.put(opp.Id,opp);
        }
        
        for(OpportunityContactRole existingRole : [SELECT Id,ContactId,OpportunityId from OpportunityContactRole WHERE ContactId IN : conIds and OpportunityId IN : oppIds]){
            existingRolesMap.put(existingRole.OpportunityId+'-'+existingRole.ContactId,existingRole);
        }
        
        for(OpportunityContactRole ocrRecord : newRecordList){
            Opportunity opp = oppMap.get(ocrRecord.OpportunityId);
            
            if(opp.IsClosed){
                ocrRecord.addError('Cannot create Opportunity Contact Role on a closed Opportunity');
            }
            String key = ocrRecord.OpportunityId+'-'+ocrRecord.ContactId;
            
            if(existingRolesMap.containsKey(key)){
                ocrRecord.addError('Contact role already exists on the opportunity');
            }
        }
    }
}
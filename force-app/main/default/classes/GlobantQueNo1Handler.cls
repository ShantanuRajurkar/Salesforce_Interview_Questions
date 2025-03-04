/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 03-04-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class GlobantQueNo1Handler {
    public static void handlerMethod(List<OpportunityContactRole> newRecordList){
        Set<Id> oppIds = new Set<Id>();
        Set<Id> conIds = new Set<Id>();
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
        Map<String,OpportunityContactRole> existingRolesMap = new Map<String,OpportunityContactRole>();
        
        if(!newRecordList.isEmpty()){
            for(OpportunityContactRole ocr : newRecordList){
                if(ocr.OpportunityId != null){
                    oppIds.add(ocr.OpportunityId);
                }
                if(ocr.ContactId != null)
                {
                    conIds.add(ocr.ContactId);
                }
            }
        }
        GlobantQueNo1Helper.displayError(oppIds, conIds, newRecordList, oppMap, existingRolesMap); 
    }
}
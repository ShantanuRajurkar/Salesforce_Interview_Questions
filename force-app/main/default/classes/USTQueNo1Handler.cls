/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 09-28-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class USTQueNo1Handler {
    public static void handleCaseInsert(List<Case> newCases){
        // Fetch existing records to compare (adjust the query/filter as needed)
        List<Case> existingRecords = [SELECT Id, Description FROM Case];
        USTQueNo1Helper.compareDescriptions(newCases, existingRecords);
    }
}
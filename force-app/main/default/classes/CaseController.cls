/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 04-13-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class CaseController {
    
    @AuraEnabled(cacheable=true)
    public static List<Case> getCases(String searchKey, Integer pageNumber, Integer pageSize) {
        String key = '%' + searchKey + '%';
        return [SELECT Id, CaseNumber, Subject, Status, Priority
                FROM Case
                WHERE Subject LIKE :key
                ORDER BY LastModifiedDate DESC
                LIMIT :pageSize OFFSET :((pageNumber - 1) * pageSize)];
    }
}

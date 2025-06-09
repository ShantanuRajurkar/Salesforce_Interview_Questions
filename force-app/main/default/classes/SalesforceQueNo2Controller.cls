/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 06-08-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class SalesforceQueNo2Controller {
    // Fetch Prospecting opps, optionally filtering by name
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getProspectingOpps(String searchName) {
        String searchTerm = '%' + (String.isBlank(searchName) ? '' : String.escapeSingleQuotes(searchName)) + '%';
        return [
            SELECT Id, Name, StageName 
            FROM Opportunity
            WHERE StageName = 'Prospecting'
              AND Name LIKE :searchTerm
            ORDER BY Name LIMIT 8
        ];
    }
    // Fetch Closed Won opps
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getClosedWonOpps() {
        return [
            SELECT Id, Name, StageName 
            FROM Opportunity 
            WHERE StageName = 'Closed Won' 
            ORDER BY Name LIMIT 8
        ];
    }
    // Fetch Closed Lost opps
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getClosedLostOpps() {
        return [
            SELECT Id, Name, StageName 
            FROM Opportunity 
            WHERE StageName = 'Closed Lost' 
            ORDER BY Name LIMIT 8
        ];
    }
    // Update an Opportunity's StageName
    @AuraEnabled
    public static Opportunity updateOpportunityStage(Id oppId, String newStage) {
        try {
            Opportunity opp = [SELECT Id, StageName FROM Opportunity WHERE Id = :oppId LIMIT 1];
            opp.StageName = newStage;
            update opp;
            return opp;
        } catch (Exception e) {
            // Wrap exception for client-side handling
            throw new AuraHandledException('Error updating Opportunity stage: ' + e.getMessage());
        }
    }
}
/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 06-22-2025
 * @last modified by  : Shantanu Rajurkar
**/
// Helper: GartnerQueNo1Helper.cls
public without sharing class GartnerQueNo1Helper {
    /**
     * Returns a map of Order Id → List of child Order_Approval__c Names
     * where Status__c = 'Pending'. Uses dynamic SOQL so field/API names
     * can be easily changed/configured.
     */
    public static Map<Id, List<String>> getPendingApprovals(Set<Id> orderIds) {
        Map<Id, List<String>> result = new Map<Id, List<String>>();
        if (orderIds == null || orderIds.isEmpty()) {
            return result;
        }
        
        String parentField  = 'Order__c';
        String statusField  = 'Status__c';
        String pendingValue = 'Pending';
        String childObj     = 'Order_Approval__c';
        
        String soql = 
            'SELECT ' + parentField + ', Name ' +
            'FROM ' + childObj + ' ' +
            'WHERE ' + parentField + ' IN :orderIds ' +
            '  AND ' + statusField + ' = :pendingValue';
        
        for (SObject sobj : Database.query(soql)) {
            Id ordId = (Id)sobj.get(parentField);
            String apprName = (String)sobj.get('Name');
            
            if (!result.containsKey(ordId)) {
                result.put(ordId, new List<String>());
            }
            result.get(ordId).add(apprName);
        }
        
        return result;
    }
}
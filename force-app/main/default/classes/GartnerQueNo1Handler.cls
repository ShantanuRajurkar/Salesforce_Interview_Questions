/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 06-22-2025
 * @last modified by  : Shantanu Rajurkar
**/
// Handler: GartnerQueNo1Handler.cls
public with sharing class GartnerQueNo1Handler {
    /**
     * Prevent deletion of shipped orders or those with pending approvals.
     */
    public static void handleBeforeDelete(List<Order__c> oldOrders) {
        if (oldOrders == null || oldOrders.isEmpty()) {
            return;
        }
        
        // Collect IDs and shipped statuses
        Set<Id> orderIds = new Set<Id>();
        Set<Id> shippedOrderIds = new Set<Id>();
        for (Order__c o : oldOrders) {
            orderIds.add(o.Id);
            if (o.Status__c == 'Shipped') {
                shippedOrderIds.add(o.Id);
            }
        }
        
        // Fetch pending approval names by order
        Map<Id, List<String>> pendingByOrder = GartnerQueNo1Helper.getPendingApprovals(orderIds);
        
        // Enforce deletion rules
        for (Order__c o : oldOrders) {
            Boolean blocked = false;
            List<String> reasons = new List<String>();
            
            if (shippedOrderIds.contains(o.Id)) {
                blocked = true;
                reasons.add('Status = Shipped');
            }
            if (pendingByOrder.containsKey(o.Id)) {
                blocked = true;
                reasons.add('Pending Approvals: ' + String.join(pendingByOrder.get(o.Id), ', '));
            }
            
            if (blocked) {
                o.addError('Cannot delete Order "' + o.Name + '" — ' + String.join(reasons, ' AND '));
            }
        }
    }
}
/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 05-10-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class CapgeminiQueNo1Handler {
    /**
     * Handles before-insert and before-update logic: capacity validation
     */
    public static void handleBefore(List<Reservation__c> newList, Boolean isInsert) {
        CapgeminiQueNo1Helper.validateCapacity(newList);
    }

    /**
     * Handles after-insert and after-update logic: resource status updates
     */
    public static void handleAfter(List<Reservation__c> newList) {
        CapgeminiQueNo1Helper.updateResourceStatuses(newList);
    }
}
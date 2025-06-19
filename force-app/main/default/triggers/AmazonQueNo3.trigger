/**
 * Trigger: AmazonQueNo3
 * Object:  Partner_Relationship__c
 * Purpose: Recompute Top_Partners__c and Partner_Count__c on Account
 */
trigger AmazonQueNo3 on Partner_Relationship__c (
    after insert,
    after update,
    after delete,
    after undelete
) {
    if (Trigger.isAfter) {
        AmazonQueNo3Handler.handleAfter(
            Trigger.isInsert, 
            Trigger.isUpdate, 
            Trigger.isDelete, 
            Trigger.isUndelete,
            Trigger.new, 
            Trigger.oldMap
        );
    }
}

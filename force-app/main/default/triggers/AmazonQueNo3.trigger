/**
 * Trigger: AmazonQueNo3
 * Object:  Partner_Relationship__c
 * Purpose: Recompute Top_Partners__c and Partner_Count__c on Account
 */

/*
Problem Statement:- 
You have a custom junction object "Partner_Relationship__c" representing how strongly an "Account" works with a Partner:
- Account__c (Lookup to Account)
- Partner__c (Lookup to Account)
- Score__c (Number; a higher score means a closer partnership)

👉On your Account object you’ve added two custom fields:
- Top_Partners__c (Text; comma‑delimited list of up to three Partner names, sorted by descending Score)
- Partner_Count__c (Number; total count of Partner_Relationship__c records for that Account)

🌟Requirements:
1. On insert/update/delete of "Partner_Relationship__c", your trigger must:
 1)Recompute "Partner_Count__c" for each affected Account.
 2)Build Top_Partners__c by:
 - Querying all Partner_Relationship__c records for that Account.
 Sorting them by Score__c descending.
 - Taking the top 3 Partner names and joining them with commas.
 
2. Edge cases
- If two relationships have the same Score, break ties by Partner name alphabetically.
- If an Account has fewer than 3 partners, just list what it has.
Deletions must remove that partner from the list and shift in the next one (if any).
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

/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 05-11-2025
 * @last modified by  : Shantanu Rajurkar
**/

/*
Problem Statement:- 
You have two custom objects:

1) Resource__c (e.g. meeting rooms, equipment)
    Fields:
     -Name (Text)
     -Current_Status__c (Picklist: Available, Booked, Overbooked)
     -Max_Concurrent_Bookings__c (Number)

2) Reservation__c (child of Resource__c)
    Fields:
     -Resource__c (Master-Detail)
     -Start_DateTime__c (DateTime)
     -End_DateTime__c (DateTime)
     -Status__c (Picklist: Pending, Confirmed, Cancelled)



Your task:
Write a single Apex trigger on Reservation__c that accomplishes all of the following for bulk DML in insert and update contexts:

1. Prevent overlapping bookings
When a new or updated reservation is Confirmed, ensure its [Start_DateTime__c, End_DateTime__c] window does not overlap 
any existing Confirmed reservation for the same Resource__c. If it does overlap, throw a TriggerException with a clear error message.

2. Enforce maximum concurrent bookings
- After inserts/updates, count active Confirmed reservations per resource.
- If the count exceeds or be equals to Resource__c.Max_Concurrent_Bookings__c, set that resource’s Current_Status__c to Overbooked;
otherwise set to Booked if ≥1, or Available if zero.
*/

trigger CapgeminiQueNo1 on Reservation__c (before insert, before update, after insert, after update) {
    if (Trigger.isBefore) {
        CapgeminiQueNo1Handler.handleBefore(Trigger.new, Trigger.isInsert);
    }
    if (Trigger.isAfter) {
        CapgeminiQueNo1Handler.handleAfter(Trigger.new);
    }
}
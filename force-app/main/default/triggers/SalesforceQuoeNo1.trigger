/*
Problem Statement:- 
In our Salesforce org, we need to ensure that a Vehicle's (parent) insurance status accurately reflects 
its most recent Insurance (child) record. Each Insurance record has an 'IsActive' flag and an 'InsuranceNumber'. 
The challenge is to update the Vehicle’s 'IsInsured' field only when a new Insurance record with the highest 'InsuranceNumber' among all related records is inserted. 
Must use helper, handler classes for best practice!
(Note: - Insurance records with same 'InsuranceNumber' can't be inserted under respective Vehicle parent record)
*/

trigger SalesforceQuoeNo1 on Insurance__c (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        SalesforceQuoeNo1Handler.handleAfterInsert(Trigger.new);
    }
}
trigger SalesforceQuoeNo1 on Insurance__c (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        SalesforceQuoeNo1Handler.handleAfterInsert(Trigger.new);
    }
}
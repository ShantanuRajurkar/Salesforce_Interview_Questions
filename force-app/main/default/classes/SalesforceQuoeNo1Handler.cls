public class SalesforceQuoeNo1Handler {
    public static void handleAfterInsert(List<Insurance__c> newInsurances) {
        SalesforceQuoeNo1Helper.processInsuranceRecords(newInsurances);
    }
}
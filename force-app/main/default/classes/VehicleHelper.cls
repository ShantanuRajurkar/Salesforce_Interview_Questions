public class VehicleHelper {
    public static List<Vehicle__c> getVehicles(Set<Id> vehicleIds) {
        return [SELECT Id, IsInsured__c FROM Vehicle__c WHERE Id IN :vehicleIds];
    }
}
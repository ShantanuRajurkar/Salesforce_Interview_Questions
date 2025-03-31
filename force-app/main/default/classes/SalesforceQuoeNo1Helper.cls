public class SalesforceQuoeNo1Helper {
    public static void processInsuranceRecords(List<Insurance__c> newInsurances) {
        // Collect Vehicle IDs from inserted Insurance records.
        Set<Id> vehicleIds = new Set<Id>();
        for (Insurance__c ins : newInsurances) {
            if (ins.Vehicle__c != null) {
                vehicleIds.add(ins.Vehicle__c);
            }
        }
        
        if (vehicleIds.isEmpty()) {
            return;
        }
        
        // Aggregate query: For each Vehicle, get the maximum InsuranceNumber__c.
        Map<Id, Decimal> vehicleMaxInsuranceMap = new Map<Id, Decimal>();
        for (AggregateResult ar : [
            SELECT Vehicle__c vehicleId, MAX(Insurance_Number__c) maxInsurance
            FROM Insurance__c
            WHERE Vehicle__c IN :vehicleIds
            GROUP BY Vehicle__c
        ]) {
            Id vehicleId = (Id) ar.get('vehicleId');
            Decimal maxInsurance = (Decimal) ar.get('maxInsurance');
            vehicleMaxInsuranceMap.put(vehicleId, maxInsurance);
        }
        
        // Prepare a map for Vehicles that need to be updated.
        // Only include Insurance records that have the highest InsuranceNumber__c.
        Map<Id, Boolean> vehicleUpdateMap = new Map<Id, Boolean>();
        for (Insurance__c ins : newInsurances) {
            if (ins.Vehicle__c != null && vehicleMaxInsuranceMap.containsKey(ins.Vehicle__c)) {
                Decimal maxInsurance = vehicleMaxInsuranceMap.get(ins.Vehicle__c);
                if (ins.Insurance_Number__c == maxInsurance) {
                    vehicleUpdateMap.put(ins.Vehicle__c, ins.IsActive__c);
                }
            }
        }
        
        // If there are Vehicles to update, query them and update their IsInsured__c field.
        if (!vehicleUpdateMap.isEmpty()) {
            List<Vehicle__c> vehiclesToUpdate = VehicleHelper.getVehicles(vehicleUpdateMap.keySet());
            for (Vehicle__c veh : vehiclesToUpdate) {
                veh.IsInsured__c = vehicleUpdateMap.get(veh.Id);
            }
            update vehiclesToUpdate;
        }
    }
}
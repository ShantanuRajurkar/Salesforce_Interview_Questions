/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 05-11-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class CapgeminiQueNo1Helper {
    /**
     * Validate that confirmed reservations do not exceed max concurrent booking limit
     */
    public static void validateCapacity(List<Reservation__c> newRes) {
        Set<Id> resourceIds = new Set<Id>();
        Set<Id> newIds = new Set<Id>();
        for (Reservation__c r : newRes) {
            if (r.Status__c == 'Confirmed' && r.Resource__c != null) {
                resourceIds.add(r.Resource__c);
                if (r.Id != null) {
                    newIds.add(r.Id);
                }
            }
        }
        if (resourceIds.isEmpty()) return;

        // Fetch max concurrent limits
        Map<Id, Integer> maxLimitMap = new Map<Id, Integer>();
        for (Resource__c res : [
            SELECT Id, Max_Concurrent_Bookings__c
            FROM Resource__c
            WHERE Id IN :resourceIds
        ]) {
            Integer maxVal = res.Max_Concurrent_Bookings__c != null ?
                res.Max_Concurrent_Bookings__c.intValue() : 0;
            maxLimitMap.put(res.Id, maxVal);
        }

        // Query existing confirmed reservations excluding current records
        List<Reservation__c> existing = [
            SELECT Id, Resource__c, Start_DateTime__c, End_DateTime__c
            FROM Reservation__c
            WHERE Resource__c IN :resourceIds
              AND Status__c = 'Confirmed'
              AND Id NOT IN :newIds
        ];

        // Group existing by resource
        Map<Id, List<Reservation__c>> existingByRes = new Map<Id, List<Reservation__c>>();
        for (Reservation__c ex : existing) {
            if (!existingByRes.containsKey(ex.Resource__c)) {
                existingByRes.put(ex.Resource__c, new List<Reservation__c>());
            }
            existingByRes.get(ex.Resource__c).add(ex);
        }

        // Validate each new reservation
        for (Reservation__c newR : newRes) {
            if (newR.Status__c != 'Confirmed' || newR.Resource__c == null
                || newR.Start_DateTime__c == null || newR.End_DateTime__c == null) {
                continue;
            }
            Integer maxConcurrent = maxLimitMap.get(newR.Resource__c);
            Integer overlappingCount = 0;

            // Count existing overlaps
            List<Reservation__c> related = existingByRes.get(newR.Resource__c);
            if (related != null) {
                for (Reservation__c ex : related) {
                    if (newR.Start_DateTime__c < ex.End_DateTime__c
                        && ex.Start_DateTime__c < newR.End_DateTime__c) {
                        overlappingCount++;
                    }
                }
            }
            // Count overlaps among new records
            for (Reservation__c other : newRes) {
                if (other != newR && other.Status__c == 'Confirmed'
                    && other.Resource__c == newR.Resource__c
                    && other.Start_DateTime__c != null && other.End_DateTime__c != null
                    && other.Start_DateTime__c < newR.End_DateTime__c
                    && newR.Start_DateTime__c < other.End_DateTime__c) {
                    overlappingCount++;
                }
            }
            // Include the new reservation itself in the count
            Integer totalConcurrent = overlappingCount + 1;
            // If total concurrent exceeds limit, add error
            if (totalConcurrent > maxConcurrent) {
                newR.addError(
                    'Cannot confirm reservation: exceeds max concurrent bookings of ' +
                    maxConcurrent
                );
            }
        }
    }

    /**
     * Update Resource__c.Current_Status__c based on confirmed reservation counts
     */
    public static void updateResourceStatuses(List<Reservation__c> resList) {
        Set<Id> resourceIds = new Set<Id>();
        for (Reservation__c r : resList) {
            if (r.Resource__c != null) {
                resourceIds.add(r.Resource__c);
            }
        }
        if (resourceIds.isEmpty()) return;

        // Aggregate confirmed reservation counts
        Map<Id, Integer> confirmedCount = new Map<Id, Integer>();
        for (AggregateResult ar : [
            SELECT Resource__c resId, COUNT(Id) cnt
            FROM Reservation__c
            WHERE Resource__c IN :resourceIds
              AND Status__c = 'Confirmed'
            GROUP BY Resource__c
        ]) {
            confirmedCount.put(
                (Id) ar.get('resId'),
                (Integer) ar.get('cnt')
            );
        }

        // Query and update resources
        List<Resource__c> toUpdate = new List<Resource__c>();
        for (Resource__c res : [
            SELECT Id, Max_Concurrent_Bookings__c, Current_Status__c
            FROM Resource__c
            WHERE Id IN :resourceIds
        ]) {
            Integer countVal = confirmedCount.containsKey(res.Id)
                ? confirmedCount.get(res.Id) : 0;
            system.debug('countVal:::::::::'+countVal);
            String newStatus;
            if (countVal == 0) {
                newStatus = 'Available';
            } else if (countVal >= res.Max_Concurrent_Bookings__c) {
                newStatus = 'Overbooked';
            } else {
                newStatus = 'Booked';
            }
            if (res.Current_Status__c != newStatus) {
                res.Current_Status__c = newStatus;
                toUpdate.add(res);
            }
        }
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }
}
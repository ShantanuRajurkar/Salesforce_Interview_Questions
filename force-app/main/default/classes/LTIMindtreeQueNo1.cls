/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 10-16-2025
 * @last modified by  : Shantanu Rajurkar
**/

/*
Problem Statement:- 
1. Count characters in a string - 
Write an Apex method that takes a String as input and returns a Map<String, Integer> where each key is 
a single-character String (since Apex has no char primitive) and the value is the number of times that 
character appears in the input string.

2. Account → Contact count map -
Write a bulk-safe Apex method that returns a Map<String,Integer> where each key is an Account.
Name and the value is the total number of Contacts associated with that Account. 
If duplicate account names exist, sum their contact counts into the single map entry. 
*/

public with sharing class LTIMindtreeQueNo1 {

    public static Map<String, Integer> countChars(String input) {
        Map<String, Integer> counts = new Map<String, Integer>();
        if (input == null) return counts;
        for (Integer i = 0; i < input.length(); i++) {
            String ch = input.substring(i, i+1);
            if (counts.containsKey(ch)) {
                counts.put(ch, counts.get(ch) + 1);
            } else {
                counts.put(ch, 1);
            }
        }
        return counts;
    }
    
    public static Map<String, Integer> getAccountContactCountByName() {

        // Query all accounts (Id + Name)
        Map<Id, Account> accById = new Map<Id, Account>([SELECT Id, Name FROM Account]);

        // prepare name -> total map and initialize 0 for every existing name
        Map<String, Integer> countsByName = new Map<String, Integer>();
        for (Account a : accById.values()) {
            String nameKey = (a.Name == null) ? '' : a.Name;
            if (!countsByName.containsKey(nameKey)) {
                countsByName.put(nameKey, 0);
            }
        }

        // if no accounts, return empty (or map with placeholder keys if you prefer)
        if (accById.isEmpty()) {
            return countsByName;
        }

        // 2) Aggregate contact counts grouped by AccountId for those accounts
        for (AggregateResult ar : [
            SELECT AccountId acctId, COUNT(Id) cnt
            FROM Contact
            WHERE AccountId IN :accById.keySet()
            GROUP BY AccountId
        ]) {
            Id acctId = (Id) ar.get('acctId');
            Integer cnt = Integer.valueOf(String.valueOf(ar.get('cnt')));
            String nameKey = accById.get(acctId).Name;
            nameKey = (nameKey == null) ? '' : nameKey;

            countsByName.put(nameKey, countsByName.get(nameKey) + cnt);
        }

        return countsByName;
    
    }
}
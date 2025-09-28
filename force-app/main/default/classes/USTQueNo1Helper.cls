/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 09-28-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class USTQueNo1Helper {
    public static void compareDescriptions(List<Case> newCases, List<Case> existingRecords) {
        // Iterate through each new record
        for(Case c : newCases){
                if (c.Description != null) {
                // Normalize text: remove punctuation and lowercase
                String rawNew = c.Description.replaceAll('[^A-Za-z0-9 ]', '').toLowerCase();
                // Split into words by whitespace
                List<String> newWordsList = rawNew.split('\\s+');
                Set<String> newWordsSet = new Set<String>(newWordsList);
                
                // Compare against each existing record’s description
                for (Case existingCase : existingRecords) {
                    if (existingCase.Description != null) {
                        String rawExist = existingCase.Description.replaceAll('[^A-Za-z0-9 ]', '').toLowerCase();
                        List<String> existWordsList = rawExist.split('\\s+');
                        Integer commonCount = 0;
                        for (String word : existWordsList) {
                            if (newWordsSet.contains(word)) {
                                commonCount++;
                            }
                        }
                        // If more than 50% of newRec's words match, block the insert
                        // (commonCount * 2 > newWordsSet.size() is equivalent to >50%)
                        if (commonCount * 2 > newWordsSet.size()) {
                            c.addError('Description is too similar to an existing record.');
                            break;
                        }
                    }
                }
            }
        }
    }
}
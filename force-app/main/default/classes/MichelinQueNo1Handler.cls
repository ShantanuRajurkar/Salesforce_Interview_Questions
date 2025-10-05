/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 10-05-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class MichelinQueNo1Handler {
    public static void handleAfterUpdate(List<Account> newList, Map<Id, Account> oldMap) {
        if (newList == null || newList.isEmpty()) return;

        // Collect accounts that changed status to 'Active' (and have required fields)
        List<Account> toProcess = new List<Account>();
        for (Account acc : newList) {
            Account oldAcc = oldMap != null ? oldMap.get(acc.Id) : null;
            String oldStatus = String.valueOf(oldAcc.Contract_Status__c);
            String newStatus = String.valueOf(acc.Contract_Status__c);

            // process when status changed to Active (case-sensitive match; adapt if needed)
            Boolean becameActive = newStatus != oldStatus && newStatus == 'Active';

            // Also ensure required fields exist
            Boolean hasTotal = acc.Total_Contract_Value__c != null;
            Boolean hasTerm = acc.Contract_Term__c != null && acc.Contract_Term__c > 0;
            Boolean hasFiscal = acc.Fiscal_Year_Start__c != null;
			
            system.debug(becameActive + ' '+ hasTotal+' '+ hasTerm+' '+ hasFiscal + '');
            if (becameActive && hasTotal && hasTerm && hasFiscal) {
                toProcess.add(acc);
            }
        }

        if (!toProcess.isEmpty()) {
            MichelinQueNo1Helper.processAccountsForRevenue(toProcess);
        }
    }
}
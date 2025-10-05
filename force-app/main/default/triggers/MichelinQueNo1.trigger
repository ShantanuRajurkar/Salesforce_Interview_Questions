/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 10-05-2025
 * @last modified by  : Shantanu Rajurkar
**/

/**
Problem Statement:
When an Account moves to Active (i.e. Contract_Status__c = 'Active'), generate yearly revenue allocations for that Account 
and associate them with the Account’s Contacts. 

- Input objects & fields (use these API names) 
1) Account 
 a. Total_Contract_Value__c (Currency) — total contract value to allocate
 b. Contract_Term__c (Number) — number of years to allocate across (integer)
 c. Fiscal_Year_Start__c (Date) — base year (e.g., 2025-01-01)
2) Revenue__c (custom object to create)
 a. Account__c (Lookup(Account)), 
 b. Contact__c (Lookup(Contact))
 c. Revenue_Amount__c (Currency)
 d. Fiscal_Year__c (Number)


- Behavior / Requirements
1) For each Account to process:
 a. If 'Contract_Term__c' ≤ 0 or 'Fiscal_Year_Start__c' is null or 'Total_Contract_Value__c' is null/0 → skip.
 b. Evenly divide 'Total_Contract_Value__c' across 'Contract_Term__c' years.
 c. Rounding rules: compute base per-year. Final amounts are set to 2 decimals.

2) For each fiscal year (from Fiscal_Year_Start__c.year() for 'Contract_Term__c' years):
 a. If the Account has one or more Contacts, split that year’s amount equally among contacts:
 b. Create one 'Revenue__c' record per contact with that contact’s portion.
 c. If the Account has no contacts, create one Revenue__c record for the Account with the full year amount and Contact__c = null.
 

- Acceptance criteria
1) For Example, Account with 'Total_Contract_Value__c' = 1000, 'Contract_Term__c' = 3, 'Fiscal_Year_Start__c' = 2025-01-01, 
and 2 Contacts, the system must create 6 Revenue__c rows:
Year 2025: two contact rows summing to ~333.33 
Year 2026: two contact rows summing to ~333.33
Year 2027: two contact rows summing to ~333.34 
 
2) Re-running update on same Account should first delete prior 
'Revenue__c' records for that Account and then insert new ones (no duplicates). 
 */ 

trigger MichelinQueNo1 on Account (after update) {
    if (Trigger.isAfter) {
        if(Trigger.isUpdate)
        	MichelinQueNo1Handler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}
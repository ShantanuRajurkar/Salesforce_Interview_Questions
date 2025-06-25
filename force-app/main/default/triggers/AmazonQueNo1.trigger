/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 04-03-2025
 * @last modified by  : Shantanu Rajurkar
**/

/*
Problem Statement:- 
In Salesforce, when an Opportunity's stage is updated to "Closed Won," 
calculate its Bonus Discount as a weighted average of discounts from the Account's previous "Closed Won" Opportunities. 
The weighting is determined using the formula:​

{Weight = 1/(1+Days Since Close1​)}

This approach assigns higher significance to more recent Opportunities, 
ensuring that the calculated Bonus Discount reflects the most current sales trends.

🤔 Understand What Are Weights In This Scenario With An Example: 

​For Example, to calculate the Bonus_Discount__c for a new Opportunity based on three historical Opportunities with Discount__c values of 2, 2, and 3, we can use a weighted average approach. 
This method assigns more significance to recent Opportunities by applying a time-decay factor. 

Assumptions:
The three historical Opportunities closed 10, 5, and 2 days ago, respectively.​
Steps:

Assign Weights Based on Recency:
Older Opportunities receive lower weights, while more recent ones receive higher weights.​
A common approach is to use the inverse of the days since closing:
 Weight = 1 / (1 + Days_Ago)

Calculate Weights:
Opportunity 1 (closed 10 days ago): Weight = 1 / (1 + 10) = 0.0909​
Opportunity 2 (closed 5 days ago): Weight = 1 / (1 + 5) = 0.1667​
Opportunity 3 (closed 2 days ago): Weight = 1 / (1 + 2) = 0.25​

Compute Weighted Discounts:
Multiply each discount by its corresponding weight:​
Opportunity 1: 2 * 0.0909 = 0.1818
Opportunity 2: 2 * 0.1667 = 0.3334
Opportunity 3: 3 * 0.25 = 0.75

Calculate Weighted Average Discount:
Sum of weighted discounts: 0.1818 + 0.3334 + 0.75 = 1.2652​
Sum of weights: 0.0909 + 0.1667 + 0.25 = 0.5076​
Weighted Average Discount = 1.2652 / 0.5076 ≈ 2.49​

Result:
The calculated Bonus Discount for the new Opportunity would be approximately 2.49. 
This approach ensures that more recent Opportunities have a greater influence on the Bonus Discount, 
reflecting their higher relevance.​
*/
trigger AmazonQueNo1 on Opportunity (before update) {
    AmazonQueNo1Handler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
}

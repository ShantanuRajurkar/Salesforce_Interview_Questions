/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 04-07-2025
 * @last modified by  : Shantanu Rajurkar
**/


/* (Note: As part of this scenario, two triggers are involved namely: 'GlobantQueNo2Account' and 'GlobantQueNo2Contact')
Problem Statement:- 
Imagine you have an Account with multiple related Contacts. One of these Contacts is flagged as Primary (via a checkbox). The requirements are:

1️⃣ Contact to Account Sync:
When a Primary Contact updates its Phone field, automatically update the parent Account’s Phone field to match.

2️⃣ Account to Contact Sync:
When the Account’s Phone is updated (say, by an admin or through another process), update all Primary Contacts to reflect the new phone number—but only if those Contacts haven't been updated in the last hour. This extra condition helps avoid overwriting recent manual updates.

3️⃣ Conflict Resolution:
In cases where multiple Primary Contacts exist and their phone numbers differ, use the phone number from the Contact that was updated most recently to update the Account.

4️⃣ Avoiding Recursion:
Since updates on the Account can trigger Contact updates (and vice versa), your trigger logic must smartly prevent recursive calls and infinite loops.

*/


trigger GlobantQueNo2Contact on Contact (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        GlobantQueNo2Handler.handleContact(Trigger.new);
    }
}

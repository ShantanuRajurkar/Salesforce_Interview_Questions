/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 04-07-2025
 * @last modified by  : Shantanu Rajurkar
**/
public class GlobantQueNo2Handler {
    public static void handleContact(List<Contact> newContacts) {
        GlobantQueNo2Helper.processContacts(newContacts);
    }
    
    public static void handleAccount(List<Account> newAccounts, Map<Id, Account> oldMap) {
        GlobantQueNo2Helper.processAccounts(newAccounts, oldMap);
    }
}

/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 05-24-2025
 * @last modified by  : Shantanu Rajurkar
**/
public class GlobantQueNo3Handler {
    public static void handleAfterInsert(List<Account> newAccounts) {
        GlobantQueNo3Helper.processAccounts(newAccounts);
    }
}
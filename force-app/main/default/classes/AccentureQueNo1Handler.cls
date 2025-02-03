public class AccentureQueNo1Handler {
    public static void handlerMethodForUpdate(list<Account> newAccList, map<Id, Account> accOldMap){
        system.debug('In Handler');
        set<Id> accIds = new set<Id>();
        for(Account accNew : newAccList){
            if(accOldMap.get(accNew.Id).Close_Good_Opportunities__c != accNew.Close_Good_Opportunities__c && accNew.Close_Good_Opportunities__c == true){
            	accIds.add(accNew.Id);
            }
        }
        if(!accIds.isEmpty()){
        	AccentureQueNo1Helper.closeTheOpportunity(accIds);
        }
    }
}
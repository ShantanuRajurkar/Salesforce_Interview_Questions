public class CognizantQueNo1Handler {
    public static void handlerMethod(list<OpportunityLineItem> oppLineItems){
        set<Id> oppIds = new set<Id>();
        for(OpportunityLineItem oppLineItem : oppLineItems){
	    oppIds.add(oppLineItem.OpportunityId);          
        }
        if(!oppIds.isEmpty()){
            set<Id> accIds = new set<Id>();
            for(Opportunity opp : [SELECT Id, AccountId FROM Opportunity WHERE Id IN: oppIds]){
            	accIds.add(opp.AccountId);
            }
            if(!accIds.isEmpty()){
                CognizantQueNo1Helper.SetTotalNumberOfOppProducts(accIds);
            }
        }
    }
}

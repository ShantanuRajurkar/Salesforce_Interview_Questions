public class CognizantQueNo1Helper {
    public static void SetTotalNumberOfOppProducts(set<Id> accIds){
        list<Account> accToUpdate = new list<Account>();
        map<Id, Integer> oppToTotalOppProducts = new map<Id, Integer>();
        map<Id, List<Opportunity>> accOppMap = new map<Id, List<Opportunity>>();
        for(Opportunity opp : [SELECT Id, AccountId, (SELECT Id FROM OpportunityLineItems) FROM Opportunity WHERE AccountId IN: accIds]){
            if(opp.OpportunityLineItems.size() != null)
            	oppToTotalOppProducts.put(opp.Id, opp.OpportunityLineItems.size());
        }

        for (Account acc : [SELECT Id, Total_Opportunity_Products__c, (SELECT Id FROM Opportunities) FROM Account WHERE Id IN :accIds]) {
        	if (!accOppMap.containsKey(acc.Id)) {
           		accOppMap.put(acc.Id, new List<Opportunity>());
          	}
             	accOppMap.get(acc.Id).addAll(acc.Opportunities);
  		}
        
        for (Account acc : [SELECT Id, Total_Opportunity_Products__c FROM Account WHERE Id IN: accIds]) {
            List<Opportunity> oppList = accOppMap.get(acc.Id);
            integer sum = 0;
            for (Opportunity opp : oppList) {
                if(oppToTotalOppProducts.containskey(opp.Id))
                	sum = sum + oppToTotalOppProducts.get(opp.Id);
            }
            acc.Total_Opportunity_Products__c = sum;
            accToUpdate.add(acc);
        }
        
        if(!accToUpdate.isEmpty()){
            update accToUpdate;
        }
    }
}
public class AccentureQueNo1Helper {
    public static void closeTheOpportunity(set<Id> accIds){
        list<Opportunity> oppsToUpdate = new list<Opportunity>();
        for(Opportunity opp : [SELECT Id, AccountId, Probability, StageName FROM Opportunity WHERE AccountId IN: accIds]){
            system.debug('Probablity : '+opp.Probability);
            if(opp.Probability > 70){
                opp.StageName = 'Closed';
                oppsToUpdate.add(opp);
            }
        }
        
        if(!oppsToUpdate.isEmpty()){
            update oppsToUpdate;
        }
    }
}
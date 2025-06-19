/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 06-15-2025
 * @last modified by  : Shantanu Rajurkar
**/
public class GoogleQueNo1BatchClass implements Database.Batchable<sObject> {
    private Set<Id> accountIds;
    
    public GoogleQueNo1BatchClass(Set<Id> accountIds) {
        this.accountIds = accountIds;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id FROM Contact WHERE AccountId IN :accountIds
        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<sObject> conList) {
        list<Contact> conToUpdate = new List<Contact>();
        list<Contact> newConList = (list<Contact>)conList;
        set<Id> contactIds = new Set<Id>();
        for (Contact con : newConList) {
            contactIds.add(con.Id);
        }
        for (Contact con : [SELECT Id, Account.Description FROM Contact WHERE Id IN :contactIds]) {
            con.Description = 'Account Description Changed: ' + con.Account.Description;
            conToUpdate.add(con);
        }
        System.debug('Updating Contacts: ' + conToUpdate);
        update conToUpdate;
    }
    
    public void finish(Database.BatchableContext bc) {
        // Optional: post-processing or notifications
    }
}
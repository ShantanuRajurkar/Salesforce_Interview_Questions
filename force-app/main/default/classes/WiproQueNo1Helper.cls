/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 07-01-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class WiproQueNo1Helper {
    public static void afterUpdateHelper(set<Id> convertedLeadIds) {
        list<Account> accountsToUpdate = new List<Account>();
        list<Contact> contactsToUpdate = new List<Contact>();
        
        for(Lead lead : [SELECT Id, Name, ConvertedContactId, ConvertedAccountId FROM Lead WHERE Id IN :convertedLeadIds]) {
            if(lead.ConvertedContactId != null) {
                Contact con = new Contact(Id = lead.ConvertedContactId, Description = 'Converted Lead Id: '+lead.Id+' Lead Name: '+lead.Name);
                contactsToUpdate.add(con);
            }
            if(lead.ConvertedAccountId != null) {
                Account acc = new Account(Id = lead.ConvertedAccountId, Description = 'Converted Lead Id: '+lead.Id+' Lead Name: '+lead.Name);
                accountsToUpdate.add(acc);
            }
        }

        if(!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
        if(!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}

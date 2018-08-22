public class accountCustomApexController {
    @AuraEnabled
    public static string checkTypeOfOperation(Id acctID) {
        list<Account> acct = new list<Account>();
        acct = [select Id, Operation_Type__c from Account where id=:acctID LIMIT 1];
        return acct[0].Operation_Type__c;
    }
}
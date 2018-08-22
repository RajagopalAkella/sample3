public with sharing class AccountListAuraController {
	@AuraEnabled
	public static List<Account> getAccounts() {
        List<Account> accList = [SELECT Id, Name, Description, Website FROM Account ORDER BY Name limit 3];        
        system.debug('####### List of Accs found :' + accList);
		return [SELECT Id, Name, Description, Website FROM Account ORDER BY Name limit 3];
	}
}
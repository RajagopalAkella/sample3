public with sharing class CaseListAuraController {

	@AuraEnabled
	public static List<Case> getCaseInfo(String accountId) {
		List<Case> caseList = New List<Case>();
		for(Account acc:[SELECT Id, Name, (SELECT CaseNumber, Contact.Name, Subject, Priority, CreatedDate, Status, Owner.Name FROM Cases) FROM Account WHERE Id = :accountId]) {
			for(case c:acc.cases)
				caseList.add(c);
			system.debug('list of cases '+caseList);
		}
		return caseList;
	}
}
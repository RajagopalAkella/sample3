public class myClass{    
    public static void myMethod () {
        // Create a Unit Of Work
        SObjectUnitOfWork uow = new SObjectUnitOfWork(
            //new Schema.SObjectType[] {Product2.SObjectType,PricebookEntry.SObjectType,Opportunity.SObjectType,OpportunityLineItem.SObjectType}
            new Schema.SObjectType[] {Account.SObjectType,Contact.SObjectType}
        );        
        // Do some work!
        for(Integer a=0; a<10; a++) {
            Account acc = new Account();
            acc.Name = 'Test Acc ' + a;
            uow.registerNew(acc); 
            //for(Integer i=0; i<a+1; i++) {
            for(Integer i=0; i<5; i++) {
                Contact con = new Contact();
                con.LastName = 'Test ' + i;
                con.FirstName = 'Contact';
                //uow.registerNew(con);
                //uow.registerRelationship(con, Contact.AccountId, acc);
                uow.registerNew(con, Contact.AccountId, acc);
            }
        }
		uow.commitWork();
    }
}
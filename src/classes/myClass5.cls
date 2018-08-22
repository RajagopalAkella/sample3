public class myClass5 {
    public static void myMethod(){
        
        // Create a Unit Of Work
SObjectUnitOfWork uow = new SObjectUnitOfWork(
    new Schema.SObjectType[] {
        Product2.SObjectType,
        PricebookEntry.SObjectType,
        Opportunity.SObjectType,
        OpportunityLineItem.SObjectType
    }
);
        
        
// Do some work!
for(Integer o=0; o<10; o++) {

    Opportunity opp = new Opportunity();
    opp.Name = 'UoW Test Name ' + o;
    opp.StageName = 'Open';
    opp.CloseDate = System.today();
    uow.registerNew(opp);

    for(Integer i=0; i<o+1; i++) {

      Product2 product = new Product2();
      product.Name = opp.Name + ' : Product : ' + i;
      uow.registerNew(product);

      PricebookEntry pbe = new PricebookEntry();
      pbe.UnitPrice = 10;
      pbe.IsActive = true;
      pbe.UseStandardPrice = false;
      pbe.Pricebook2Id = [select id from Pricebook2 where isStandard = true limit 1].id;
      uow.registerNew(pbe, PricebookEntry.Product2Id, product);

      OpportunityLineItem oppLineItem = new OpportunityLineItem();
      oppLineItem.Quantity = 1;
      oppLineItem.TotalPrice = 10;

      uow.registerRelationship(oppLineItem, OpportunityLineItem.PricebookEntryId, pbe);
      uow.registerNew(oppLineItem, OpportunityLineItem.OpportunityId, opp);

    }
}        
        
        uow.commitWork();

        
    }

}
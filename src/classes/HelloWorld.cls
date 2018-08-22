public class HelloWorld{
    public static void MerItems(){
        integer i = 0;
        List<Merchandise__c> mer = [SELECT Id,Name,Total_Inventory__c from Merchandise__c];
        for(Merchandise__c mer2 : mer){
           System.debug('Id :' + mer2.Id + ' Name :' + mer2.Name + ' Total :' + mer2.Total_Inventory__c);
            //i++;
        }
    }
    public static void MerInsert(string sampName , string sampDesc, integer sampTotal, double sampPrice){
        Merchandise__c NewMer = new Merchandise__c(Name=sampName, Description__c=sampDesc, Total_Inventory__c=sampTotal, Price__c=sampPrice);
        insert NewMer;
    }
    public static void sayYou() {
        System.debug('You');
    }
    public void sayMe() {
        System.debug('Me');
    }
}
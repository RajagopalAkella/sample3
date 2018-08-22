public class PriceDiscount {
    public static void ApplyBonus(list<contact> c){
        for(Contact c1:c){
            if(c1.Salary__c==0 || c1.Salary__c==null){
                c1.Salary__c.addError('Salary can not be zero.');
            }
            else{
                c1.Salary__c = 1.1*c1.Salary__c;
            }
        }
    }
}
public class AwesomeProductController {
    @AuraEnabled
    public static List<Product__c> getProducts() {
        return [select id, name, photo__c, description__c, points__c from product__c];
    }

    @AuraEnabled
    public static Product__c getProductByName(String name) {
        return [select id, name, photo__c, color__c,
                points__c, description__c,
                (select name from product_sizes__r order by name)
                from product__c where name = :name];
    }
    
    @AuraEnabled
    public static List<Product_size__c> getProductSizes(String name) {
        list<product_size__c> lstProdSize = new list<product_size__c>([select id, name, Product__r.Name from product_size__c where Product__r.Name = :name]);
        system.debug('Selected name: ' + name);
        system.debug('Product sizes list: ' + lstProdSize);
        return lstProdSize;
    }
}
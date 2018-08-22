@RestResource(urlMapping='/ver2/*')
global without sharing class REST_AccountService_V2 {
//https://www.youtube.com/watch?v=C64pLdXmEoo&list=PLk8CuVq-_KNLY-XKgEmeKQZ0RE5YbJlxh
//This end point will give the CustomOrders for account's external Id
//From Postman: http://akellarajgmail-developer-edition.ap1.force.com/myapi/services/apexrest/ver2?ExtId=100
//From Workbench: /services/apexrest/ver2?ExtId=100
    @HttpGet
    global static OrderWrapper doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String ExtAccId = RestContext.request.params.get('ExtId');
        List<CustomOrder__c> OrderList = Database.query('SELECT Id, Name, OrderID__c, ExternalID__c FROM CustomOrder__c WHERE ExternalID__c = :ExtAccId');
        OrderWrapper OrderRecords = new OrderWrapper();
        for(CustomOrder__c mord : OrderList) {
            OrderRecords.MyOrderList.add(new MyOrder(mord));
        }
        String OrderJSON = JSON.serialize(OrderRecords);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(OrderJSON);
        
        if(OrderRecords.MyOrderList != null && OrderRecords.MyOrderList.size() > 0) {
            OrderRecords.status = true;
            OrderRecords.message = 'Got data.';
        }
        else {
            OrderRecords.status = false;
            OrderRecords.message = 'This account could not be found.';
            res.StatusCode = 404;
        }
        
        return OrderRecords;
   }

    global class OrderWrapper {
        public list<MyOrder> MyOrderList;
        public boolean status;
        public string message;
        public OrderWrapper() {
            MyOrderList = new list<MyOrder>();
        }
    }
    
    global class MyOrder {
        public string MyID;
        public string MyName;
        public string MyOrderID;
        public string MyExtID;
        public MyOrder(CustomOrder__c ord) {
            this.MyID = ord.ID;
            this.MyName = ord.Name;
            this.MyOrderID = ord.OrderID__c;
            this.MyExtID = ord.ExternalID__c;
        }
    }
    

}
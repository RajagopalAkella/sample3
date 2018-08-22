@RestResource(urlMapping='/ExternalAccounts/*')
global without sharing class REST_AccountService_V4 {
//https://www.youtube.com/watch?v=C64pLdXmEoo&list=PLk8CuVq-_KNLY-XKgEmeKQZ0RE5YbJlxh
//This end point will give the CustomOrders for account's external Id
//From Postman: http://akellarajgmail-developer-edition.ap1.force.com/myapi/services/apexrest/ver3?LPID=12345678901234A1
//From Workbench: /services/apexrest/ver2?ExtId=100
    @HttpGet
    global static OrderWrapper doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String ExtLPID = RestContext.request.params.get('lpid');
        List<CustomOrder__c> OrderList = Database.query('SELECT LPID__c, AccountGUID__c, AccountNickname__c, AccountNumber__c, AccountType__c, Container__c, FiID__c, LastUpdated__c, RunningBalance__c, YodleeMIDIdentifier__c FROM CustomOrder__c WHERE LPID__c = :ExtLPID');
        OrderWrapper OrderRecords = new OrderWrapper();
        for(CustomOrder__c mord : OrderList) {
            OrderRecords.ExternalAccounts.add(new MyOrder(mord));
        }
        String OrderJSON = JSON.serialize(OrderRecords);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(OrderJSON);
        
        if(OrderRecords.ExternalAccounts != null && OrderRecords.ExternalAccounts.size() > 0) {
            OrderRecords.Status.StatusCode = '200';
            OrderRecords.Status.Severity = 'Info';
            OrderRecords.Status.StatusDescription = 'Success';
            OrderRecords.Status.ServerStatusCode = '200';
            OrderRecords.Status.ServerStatusDescription = 'Success';
            OrderRecords.LPID = OrderList[0].LPID__c;
        }
        else {
            OrderRecords.Status.StatusCode = '404';
            OrderRecords.Status.Severity = 'Info';
            OrderRecords.Status.StatusDescription = 'Error';
            OrderRecords.Status.ServerStatusCode = '404';
            OrderRecords.Status.ServerStatusDescription = 'Error';
        }
        
        return OrderRecords;
   }


    global class OrderWrapper {
        public StatusData Status = new StatusData();
        public string LPID;
        public list<MyOrder> ExternalAccounts;
        public OrderWrapper() {
            ExternalAccounts = new list<MyOrder>();
        }
    }

    global class StatusData {
            public string StatusCode;
            public string Severity;
            public string StatusDescription;
            public string ServerStatusCode;
            public string ServerStatusDescription;
            public StatusData () {
            this.StatusCode = StatusCode;
            this.Severity = Severity;
            this.StatusDescription = StatusDescription;
            this.ServerStatusCode = ServerStatusCode;
            this.ServerStatusDescription = ServerStatusDescription;
            } 
    }
    
//LPID__c, AccountGUID__c, AccountNumber__c, AccountType__c, Container__c, FiID__c, LastUpdated__c, RunningBalance__c, YodleeMIDIdentifier__c        
    global class MyOrder {
        public string AccountGUID;
        public string AccountName;
        public string AccountNickname;        
        public string MaskedAccountNumber;
        public string AccountHolder;
        public string AccountType;
        public string ContainerType;
        public string FinancialInstitutionIdentifier;
        public datetime LastUpdated;
        public decimal AccountBalance;
        public MyOrder(CustomOrder__c ord) {
            this.AccountGUID = ord.AccountGUID__c;
            this.AccountName = ord.AccountNickname__c;
            this.AccountNickname = ord.AccountNickname__c;
            this.MaskedAccountNumber = ord.AccountNumber__c;
            this.AccountHolder = 'John Doe';
            this.AccountType = ord.AccountType__c;
            this.ContainerType = ord.Container__c;
            this.FinancialInstitutionIdentifier = ord.FiID__c;
            this.LastUpdated = ord.LastUpdated__c;
            this.AccountBalance = ord.RunningBalance__c;
        }
    }
    

}
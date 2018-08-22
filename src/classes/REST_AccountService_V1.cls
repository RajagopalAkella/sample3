/****************************************************************************************************
 * Description - Sample Apex REST service with GET and POST methods
 * Author - Matthew Lamb
 * Example request:
 *
   { "acctList" : 
     [{
       "Name" : "Test Account 2",
       "AccountNumber" : "888",
       "Website" : "www.site1.com",
       "BillingCity" : "San Francisco"
      },
      {
       "Name" : "Test Account 3",
       "AccountNumber" : "999",
       "BillingState" : "CA",
       "Active__c" : "true"
      }]
   }
 *    
 ****************************************************************************************************/

@RestResource(urlMapping='/myapi/accounts/*')
global with sharing class REST_AccountService_V1 {
    
    @HttpPut
    global static AccountWrapper doPut(List<Account> acctList) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        AccountWrapper response = new AccountWrapper();
        
        try {
            insert acctList;
            response.acctList = acctList;
            response.status = 'Success';
            response.message = 'Your Accounts have been created successfully';
        }
        catch(Exception exc) {
            res.StatusCode = 500;
            response.acctList = null;
            response.status = 'Error';
            response.message = 'Your request failed with the following error: ' + exc.getMessage();
        }
        
        return response;
    }
   
    global class AccountWrapper {
        public List<Account> acctList;
        public String status;
        public String message;
        
        public AccountWrapper(){
            acctList = new List<Account>();
        }
    }
}
/****************************************************************************************************
 * Description - Sample REST insert to object IVAPIAlert__c
 * Example request:
 *
   { "IVAPIList" : 
     [{
       "alertId__c" : 501,
       "Alert_CreatedDateTime__c" : "2015-11-16T04:36:55.000-08:00"
      },
      {
       "alertId__c" : 502,
       "Alert_CreatedDateTime__c" : "2015-11-16T04:36:55.000-08:00"
      }]
   }
 *    
 ****************************************************************************************************/

@RestResource(urlMapping='/myapi/IVAPIAlerts/*')
global with sharing class REST_APIAlertInsert {
    
    @HttpPut
    global static AlertWrapper doPut(List<IVAPIAlert__c> apiList) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        AlertWrapper response = new AlertWrapper();
        
        try {
            insert apiList;
            response.apiList = apiList;
            response.status = 'Success';
            response.message = 'Your Api list have been created successfully';
        }
        catch(Exception exc) {
            res.StatusCode = 500;
            response.apiList = null;
            response.status = 'Error';
            response.message = 'Your request failed with the following error: ' + exc.getMessage();
        }
        
        return response;
    }
   
    global class AlertWrapper {
        public List<IVAPIAlert__c> apiList;
        public String status;
        public String message;
        
        public AlertWrapper(){
            apiList = new List<IVAPIAlert__c>();
        }
    }
}
@RestResource(urlMapping='/IVAPIInterface/ESP8266/*')
global without sharing class REST_ESP8266 {
//http://akellarajgmail-developer-edition.ap1.force.com/myapi/services/apexrest/IVAPIInterface/ESP8266
//http://akellarajgmail-developer-edition.ap1.force.com/myapi/services/apexrest/IVAPIInterface/ESP8266/LStatus=0
    @HttpGet
    global static string doGet() {
        RestRequest req = RestContext.request; 
        System.debug('req is---------------------- ' + req); 
        Account A = [SELECT ID, LightStatus__c, LED1__c, LED2__c, LED3__c, LED4__c FROM Account WHERE ID = '0019000001apxSx'];
        String LStatus;
        if(A.LightStatus__c == null || A.LightStatus__c == 'OFF') {
            LStatus = '/LED0=OF';
        } else { LStatus = '/LED0=ON'; }
        if(A.LED1__c == null || A.LED1__c == 'OFF') {
            LStatus = LStatus + '/LED1=OF';
        } else { LStatus = LStatus + '/LED1=ON'; }
        if(A.LED2__c == null || A.LED2__c == 'OFF') {
            LStatus = LStatus + '/LED2=OF';
        } else { LStatus = LStatus + '/LED2=ON'; }
        if(A.LED3__c == null || A.LED3__c == 'OFF') {
            LStatus = LStatus + '/LED3=OF';
        } else { LStatus = LStatus + '/LED3=ON'; }
        if(A.LED4__c == null || A.LED4__c == 'OFF') {
            LStatus = LStatus + '/LED4=OF';
        } else { LStatus = LStatus + '/LED4=ON'; }
        
        ESP8266APICalls__c LogRec = new ESP8266APICalls__c();
        String reqURL = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        LogRec.RequestString__c = reqURL;
        LogRec.ReturnString__c = LStatus;
        insert LogRec;
        
        return 'Status is: ' + LStatus + '/' + reqURL;
    }


/*
    @HttpGet
    global static string doGet() {
        RestRequest req = RestContext.request; 
        System.debug('req is---------------------- ' +req); 
        return 'Get';
    }

    @HttpPost
    global static string doPost() {
        RestRequest req = RestContext.request; 
        System.debug('req is---------------------- ' +req); 
        return 'happy';
    }

    @HttpPut
    global static string doPut() {
        RestRequest req = RestContext.request; 
        System.debug('req is---------------------- ' +req); 
        return 'Put';
    }
*/

}
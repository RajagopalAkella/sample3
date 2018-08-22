@RestResource(urlMapping='/IVAPIInterface/GetLabel/*')
global without sharing class REST_GetCustomLabel {
//http://akellarajgmail-developer-edition.ap1.force.com/myapi/services/apexrest/IVAPIInterface/GetLabel

    @HttpGet
    global static string doGet() {
        RestRequest req = RestContext.request;         
        String LStatus=Label.MySampleLabel1;
        return 'Status is: ' + LStatus;
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
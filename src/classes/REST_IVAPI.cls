@RestResource(urlMapping='/IVAPIInterface/PublicLink1')
global without sharing class REST_IVAPI {

 /*   @HttpPost
    global static string doPost() {
        RestRequest req = RestContext.request; 
        //System.debug('req is---------------------- ' +req); 
        return 'happy';
    }
*/
    @HttpPost
    global static AlertWrapper doPost() {
        string resultBodyGet;
        RestRequest req = RestContext.request;
        system.debug('######## req :' + req);
        RestResponse res = RestContext.response;
        resultBodyGet = req.requestBody.tostring();
        //AlertListJSON newAlerts = (AlertListJSON)JSON.deserialize(resultBodyGet, AlertListJSON.class);
        HookJSON newAlerts = (HookJSON)JSON.deserialize(resultBodyGet, HookJSON.class);
        system.debug('######## newAlerts JSON Deserialized:' + newAlerts);
        system.debug('######## result Body:' + resultBodyGet);

        List<IVAPIAlert__c> apiList = new List<IVAPIAlert__c>();
//        for(HookJSON alert : newAlerts){
//            apiList.add(new IVAPIAlert__c(alertId__c=Integer.valueof(alert.alertID),
//                                            Alert_CreatedDateTime__c=string.valueof(datetime.now())
//                                            ));
//        }
            apiList.add(new IVAPIAlert__c(alertId__c=Integer.valueof(newAlerts.alertID),
                                            Alert_CreatedDateTime__c=string.valueof(datetime.now())
                                            ));

        AlertWrapper response = new AlertWrapper();
        List<IVAPIAlert__c> apiLstInsert = new List<IVAPIAlert__c>();
        integer tempAlertID=0;
        string tempCreatedDate='';
        for(IVAPIAlert__c alrt : apiList) {
            if(integer.valueof(alrt.alertId__c) > tempAlertID) {
                tempAlertID = integer.valueof(alrt.alertId__c);
                tempCreatedDate = string.valueof(alrt.Alert_CreatedDateTime__c);
            }
        }
        
        CompListJSON compList;
        compList = genCompList(tempAlertID);
        for(string TempComp : compList.CompanyIDs){
            NewsListJSON FindNews;
            FindNews = genNewsList(TempComp);
            if(FindNews.companyNews != null){
                for(CNewsCols tempNews: FindNews.companyNews){                    
                    apiLstInsert.add(new IVAPIAlert__c(alertId__c=tempAlertID,
                                                        Alert_CreatedDateTime__c=tempCreatedDate,
                                                        CompanyId__c=TempComp,
                                                        title__c=tempNews.title,
                                                        url__c=tempNews.url,
                                                        source__c=tempNews.source,
                                                        publicationDate__c=tempNews.publicationDate,
                                                        agent__c=tempNews.agents
                                    ));
                }
            }
        }

        try {            
            insert apiLstInsert;
            response.apiList = apiLstInsert;
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

    public class HookJSON {
        public string alertID;
        public string subscriptionId;
//        public string date;
        public string type;
    }

    public class AlertListJSON {
        public List<Calerts> alerts;
    }

    public class Calerts {
        public Integer alertID;
        public String createdDate;
    }

    public class CompListJSON {
        list<string> CompanyIDs;
        public CompListJSON(list<string> sCompanyID){
            this.CompanyIDs = sCompanyID;
        }
    }

    public class NewsListJSON {
        public List<CNewsCols> companyNews;
        public Integer page;
        public Integer resultsPerPage;
        public Integer totalResults;
    }

    public class CNewsCols {
        public String title;
        public String url;
        public String publicationDate;
        public String source;
        public String agents;
        public String similarNewsCount;
        public String imageUrl;
    }

    global class AlertWrapper {
        public List<IVAPIAlert__c> apiList;
        public String status;
        public String message;        
        public AlertWrapper(){
            apiList = new List<IVAPIAlert__c>();
        }
    }

    public static CompListJSON genCompList(integer alertID) {
        String methodurl = 'https://api.insideview.com/api/v1/subscription/hgf5o9tp2md68461vfd5/alert/';
        methodurl = methodurl + string.valueof(alertID);
        string resultBodyGet;
        string resultStatusGet;
        string accTok;
        accTok = 'JGwS//YBKwM0Uuca/XZgU/qpNOEZmYx5twCA/yw4Btu84eYGhrEgdLWveuRT74cqeMA2vTbs3Yd7yne6cfdB/ZMLT7TZHmz+DoMg4e1JfSN/TYhIsP9iQWP1OR93';
        accTok = accTok + 'GWTnP5uHUEDDBGHWuCach/5MKudIybga4ojBEuCifuZCUHw=.eyJmZWF0dXJlcyI6IntcIk9yaWdpblwiOlwiaHR0cDovL2xvY2FsaG9zdDo4MDgwXCI';
        accTok = accTok + 'sXCJpcEFkZHJlc3NcIjpcIjE3Mi4xOS40LjIzM1wifSIsImNsaWVudElkIjoidjlsNTNwbzRqcGFkZ2pjOTU5bGIiLCJncmFudFR5cGUiOiJjcmVkIiwi';
        accTok = accTok + 'dHRsIjoiMzE1MzYwMDAiLCJpYXQiOiIxNDQ3Njk4NzYwIiwianRpIjoiOWU4YTI2N2UtNTdmZi00YmE1LTliNmMtM2RlNzMwN2RiNDYwIn0=';
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('GET');
        req1.setHeader('accessToken', accTok);
        req1.setHeader('Accept', 'application/json');
        req1.setEndpoint(methodurl);
        Http http = new Http();
        HTTPResponse res1 = http.send(req1);
        resultBodyGet = res1.getBody();
        resultStatusGet = res1.getStatus();
        CompListJSON companyIds;
        companyIds=(CompListJSON)JSON.deserialize(resultBodyGet, CompListJSON.class);
        return companyIds;
    }

    public static NewsListJSON genNewsList(string compID) {
        String methodurl = 'https://api.insideview.com/api/v1/insights/company/';
        methodurl = methodurl + string.valueof(compID) + '/agents?days=1&agents=';
        methodurl = methodurl + 'LEADERSHIP_CHANGES%2CNEW_OFFERINGS%2CACQUISITIONS%2CEXPANDING_OPERATIONS%2CCOMPLIANCE%2CFUNDING_DEVELOPMENTS';
        methodurl = methodurl + '%2CPARTNERSHIPS%2CCOST_CUTTING%2COUTPERFORMING%2CUNDERPERFORMING%2CCOMPANY_PRESENTATION%2CLITIGATION%2CRESEARCH_DEVELOPMENT';
        methodurl = methodurl + '%2CDATA_SECURITY%2CBANKRUPTCY_RESTRUCTURING%2CREALESTATE_DEALS%2CREALESTATE_CONSTRUCTION%2CCORPORATE_CHALLENGES';
        string resultBodyGet;
        string resultStatusGet;
        string accTok;
        accTok = 'JGwS//YBKwM0Uuca/XZgU/qpNOEZmYx5twCA/yw4Btu84eYGhrEgdLWveuRT74cqeMA2vTbs3Yd7yne6cfdB/ZMLT7TZHmz+DoMg4e1JfSN/TYhIsP9iQWP1OR93';
        accTok = accTok + 'GWTnP5uHUEDDBGHWuCach/5MKudIybga4ojBEuCifuZCUHw=.eyJmZWF0dXJlcyI6IntcIk9yaWdpblwiOlwiaHR0cDovL2xvY2FsaG9zdDo4MDgwXCI';
        accTok = accTok + 'sXCJpcEFkZHJlc3NcIjpcIjE3Mi4xOS40LjIzM1wifSIsImNsaWVudElkIjoidjlsNTNwbzRqcGFkZ2pjOTU5bGIiLCJncmFudFR5cGUiOiJjcmVkIiwi';
        accTok = accTok + 'dHRsIjoiMzE1MzYwMDAiLCJpYXQiOiIxNDQ3Njk4NzYwIiwianRpIjoiOWU4YTI2N2UtNTdmZi00YmE1LTliNmMtM2RlNzMwN2RiNDYwIn0=';
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('GET');
        req1.setHeader('accessToken', accTok);
        req1.setHeader('Accept', 'application/json');
        req1.setEndpoint(methodurl);
        Http http = new Http();
        HTTPResponse res1 = http.send(req1);
        resultBodyGet = res1.getBody();
        resultStatusGet = res1.getStatus();
        NewsListJSON companyNews = (NewsListJSON)JSON.deserialize(resultBodyGet, NewsListJSON.class);
        //system.debug('######### News body: ' + resultBodyGet);
        //system.debug('######### comp News: ' + companyNews);
        return companyNews;
    }




}



/*
@RestResource(urlMapping='/IVAPIInterface/PublicLink')
global without sharing class REST_IVAPI {

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

    @HttpGet
    global static string doGet() {
        RestRequest req = RestContext.request; 
        System.debug('req is---------------------- ' +req); 
        return 'Get';
    }

}

*/
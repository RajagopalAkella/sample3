/*Run the below code using (in anonymous window):
REST_GET_CompList apiCall = new REST_GET_CompList();
apiCall.genCompList();
*/

public class REST_GET_CompList {
    public string apikey; 
    public string cid;
    public string csec;
    
    public class CompListJSON {
        list<string> CompanyIDs;
        public CompListJSON(list<string> sCompanyID){
            this.CompanyIDs = sCompanyID;
        }
    }
    
    public void genCompList() {
        String methodurl = 'https://api.insideview.com/api/v1/subscription/hgf5o9tp2md68461vfd5/alert/567';
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
        System.debug('########## resultBodyGet: ' + resultBodyGet);
        System.debug('########## resultStatusGet: ' + resultStatusGet);
        
        
        CompListJSON companyIds;
        companyIds=(CompListJSON)JSON.deserialize(resultBodyGet, CompListJSON.class);
        
        System.debug('########## convertedList: ' + companyIds.CompanyIDs);


        //list<string> compIDs;
        for(string comp : companyIds.CompanyIDs){
            system.debug('########## IteratedList: ' + comp);
            //compIDs.add(comp.CompanyIDs);
        }
       
        
        
    }
}
//Usage example:
//This class gets the result of specific contact searched by its last name
//IV_API2 s = new IV_API2();
//s.genUrl('v9l53po4jpadgjc959lb','1ginie66crhflrokrncf9jjcoid6qf8mmsmdfrg81dpoh3f41jo77njjst90');

public class IV_API2 {
    public string apikey; 
    public string clientid;
    public string clientsecret;
    public void genUrl( String cid, String csec ) {
         String params = '?clientId='+cid;
         params = params + '&clientSecret=' +csec;
         params = params + '&grantType=cred';
         callout('https://login.insideview.com/Auth/login/v1/token'+params);
         findContact();
    }
    public void callout( String methodurl){
        string resultbody ;
        string resultstatus ;
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Accept', 'application/json');
        req.setEndpoint(methodurl);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        resultbody= res.getBody();
        resultstatus = res.getStatus();
        System.debug('resultbody------------->' + resultbody);
        System.debug('result status ------------->' + resultstatus);
        myJson js = (myJson)json.deserialize(res.getBody(),myJson.class);
        apikey = js.accessTokenDetails.accessToken ;
        System.debug('API KEY ===============>>' +apikey );
	}
    public class myJson {
       accessTokenDetails  accessTokenDetails;
    }
    public class accessTokenDetails {
        public string accessToken;
    }
    public void findContact(){
        //String fName = 'John';
        //Boolean active= true ;
        String param = '?lastName=John';
        param = param+'&active=true';
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');
        callout4getContact('https://api.insideview.com/api/v1/contacts'+param);
    }
    public void callout4getContact( String getContacturl){
        string resultbodygetContact ;
        string resultstatusgetContact ;
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('GET');
        req1.setHeader('accessToken', apikey);
        req1.setHeader('Accept', 'application/json');
        req1.setEndpoint(getContacturl);
        Http http = new Http();
        HTTPResponse res1 = http.send(req1);
        resultbodygetcontact= res1.getBody();
        resultstatusgetcontact = res1.getStatus();
        System.debug('resultbody getcontact------------->' + resultbodygetcontact);
        System.debug('result status getcontact  ------------->' + resultstatusgetcontact);
    }


}
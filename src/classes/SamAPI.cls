public class SamAPI {
public string str;
    public void callsam(){        
        string aresult = null;
    	string aresultstatus = null;
        HttpRequest req = new HttpRequest();
    	req.setMethod('GET');
     req.setHeader('Content-Type', 'application/json');
     req.setEndpoint('http://api.openweathermap.org/data/2.5/weather?q=London,uk');
     
    Http http = new Http();
    HTTPResponse res = http.send(req);
    aresult= res.getBody();
    aresultstatus = res.getStatus();
     
     System.debug('result------------->' + aresult);
     System.debug('result status ------------->' + aresultstatus);
     
     parent e = (parent)json.deserialize(res.getBody(),parent.class);
        string str = e.sys.country;
        System.debug('STRING-- ------------->' + str );
        
    }

    public class parent {
        sys sys;
    }
 public class sys{
       String  id ;
     	String country;
     
	}

}
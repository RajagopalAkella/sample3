public class SampleSameera {
    public static void ConvXmlToJson () {
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'SamJSON' LIMIT 1];
        String JSBody = sr.Body.toString();
        JSBody = JSBody.replace('soapenv:Envelope', 'outerEnv');
        JSBody = JSBody.replace('soapenv:Body', 'innerBody');
        JSBody = JSBody.replace('ns:Execute', 'execSec');
        JSBody = JSBody.replace('ns:flowName', 'flowSec');
        JSBody = JSBody.replace('ns:input', 'dataSec');
        JSBody = JSBody.replace('ns:name', 'dataName');
        JSBody = JSBody.replace('ns:value', 'dataValue');        
        //xml2Json r =(xml2Json)GSS_XmlToJson.parseDocumentToObject(JSBody, xml2Json.class);
        //system.debug('##### Raj: ' + r);
    }
    
    public class xml2Json {
        @AuraEnabled
        public envelp outerEnv {get;set;}
    }
    
    public class envelp {
        public bodyD innerBody {get;set;}
    }
    
    public class bodyD {
        public execD execSec {get;set;}
    }
    
    public class execD {
        public string flowSec {get;set;}
        public list<dataD> dataSec {get;set;}
    }
    
    public class dataD {
        public string dataName {get;set;}
        public string dataValue {get;set;}
    }
}
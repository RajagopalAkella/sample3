<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://xml.avaya.com/ws/WorkFlow/InteractionCenter/71">
   <soapenv:Header/>
   <soapenv:Body>
      <ns:Execute>
         <ns:flowName>httpvoxsf.iccmd</ns:flowName>
         <!--1 or more repetitions:-->
         <ns:input>
            <ns:name>command</ns:name>
            <ns:value>setedu</ns:value>
         </ns:input>
         <ns:input>
            <ns:name>eduid</ns:name>
            <ns:value>58cac941000000000a7fda42232a0002</ns:value>
         </ns:input>
         <ns:input>
            <ns:name>sfdc.data.attachments.PINValid</ns:name>
            <ns:value>"Y"</ns:value>
         </ns:input>
         <ns:input>
            <ns:name>sfdc.data.attachments.SSN</ns:name>
            <ns:value>"123-45-6789"</ns:value>
         </ns:input>
         <ns:input>
            <ns:name>sfdc.data.attachments.LPID</ns:name>
            <ns:value>"123456789"</ns:value>
         </ns:input>
         <ns:input>
            <ns:name>sfdc.data.attachments.origin</ns:name>
            <ns:value>"24HB"</ns:value>
         </ns:input>
         <ns:input>
            <ns:name>sfdc.data.attachments.VerificationLevel</ns:name>
            <ns:value>"G"</ns:value>
         </ns:input>
      </ns:Execute>
   </soapenv:Body>
</soapenv:Envelope>
public class FileController {
    
    @AuraEnabled
    public static Id attachTheFile(Id parentId, String fileName, String base64Data, String contentType, String attDesc) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment a = new Attachment();
        a.parentId = parentId;
        a.Body = EncodingUtil.base64Decode(base64Data);
        a.Name = fileName;
        a.ContentType = contentType;
        a.Description = attDesc;
        //String existingBody = EncodingUtil.base64Decode(base64Data);
        if(attDesc=='FinalChunk') {
            attachContent(parentId, fileName, base64Data, contentType);
        }
        insert a;
        return a.Id;
    }
    
    @AuraEnabled
    public static Id saveTheChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId, String attDesc) { 
        if (fileId == '') {
            fileId = attachTheFile(parentId, fileName, base64Data, contentType, attDesc);
        } else {
            appendToFile(fileId, base64Data, attDesc);
        }
        return Id.valueOf(fileId);
    }
    
    private static void appendToFile(Id fileId, String base64Data, String attDesc) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment a = [SELECT Id, Name, Body, ParentId, ContentType, Description FROM Attachment WHERE Id = :fileId];
     	String existingBody = EncodingUtil.base64Encode(a.Body);
        String existingDesc = a.Description;
        String existName = a.Name;
        String existContTyp = a.ContentType;
        Id existParentId = a.ParentId;
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        a.Description = existingDesc + ' - ' + attDesc;
        if(attDesc=='FinalChunk') {
            attachContent(existParentId, existName, existingBody+base64Data, existContTyp);
        }       
        update a;
    }




    public static void attachContent(Id parentId, String fileName, String base64Data, String contentType) { 
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion content = new ContentVersion();
        ContentDocumentLink documentLink = new ContentDocumentLink();
        content.VersionData = EncodingUtil.base64Decode(base64Data);
        //content.VersionData = base64Data;
        content.Title = fileName;
        content.Origin = 'H';
        content.PathOnClient = fileName;
		insert content;
        ContentVersion contentLink = [SELECT Title,ContentDocumentId,ContentLocation FROM ContentVersion WHERE Id =: content.Id];
    	documentLink.LinkedEntityId  = parentId;
        documentLink.ContentDocumentId = contentLink.ContentDocumentId; 
        documentLink.ShareType =  'V';
        documentLink.Visibility ='AllUsers';
        insert documentLink;
        //return content.Id;
    }
    


}
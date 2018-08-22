/*
*     @Name : VFAttachmentSlider_Con Class
*     @Description : Controller class for VFAttachmentSlider
*                    Fetches attachments to the VFAttachmentSlider to display them as slider
*     @Author : avidev9@gmail.com 
*     @Version : 1.0
*     @Test Class : AttachmentReporting_Con_Test
*     @Created Date :  1-Aug-2013
*     @Revision History ----------------------------------- 
*           
*                       
*/
public class VFAttachmentSlider_Con {
    public Id parentRecordId{get;set;}
    
    public List<Attachment> getAttachments(){
        return [SELECT id FROM Attachment WHERE ParentId=:parentRecordId];
    }
}
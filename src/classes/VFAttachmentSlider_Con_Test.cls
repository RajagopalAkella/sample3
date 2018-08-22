/*
*     ========================================
*     Unit test class for VFAttachmentSlider_Con
*     ========================================
*     @Name : VFAttachmentSlider_Con Class
*     @Author : avidev9@gmail.com 
*     @Version : 1.0
*     @Created Date : 1-Sep-2013
*     -----------------------------------------
*/
@isTest
private class VFAttachmentSlider_Con_Test{
    static testMethod void testVFAttachmentSlider_Con(){
        Account acc = new Account(Name ='Test Account');
        insert acc;
        //attach a attachment
        Blob b = Blob.valueOf('Test Data');            
        Attachment attachment = new Attachment();  
        attachment.ParentId = acc.Id;  
        attachment.Name = 'Test Attachment for Parent';  
        attachment.Body = b;
        insert attachment;
        
        Test.startTest();
            VFAttachmentSlider_Con con = new VFAttachmentSlider_Con();
            System.assertEquals(0,con.getAttachments().size());
            con.parentRecordId = acc.Id;
            System.assertEquals(1,con.getAttachments().size());
        Test.stopTest();
    }

}
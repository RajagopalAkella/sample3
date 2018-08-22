({
    handleSelect: function (cmp, event, helper) {  
     var myName = event.getParam('name');  
     alert("You selected: " + myName);  
   },
    
    doInit: function (cmp, event, helper) {
        
       // cmp.set("v.recordId",'a0I9000000fWQTe');
        console.log('recordID is: ' + cmp.get("v.recordId"));
        var action = cmp.get("c.getRGHierarchy");  
        action.setParams({ recordId : cmp.get("v.recordId") });  
        action.setCallback(this, function(response) {  
            var state = response.getState();  
            if (state === "SUCCESS") {  
                cmp.set( "v.items", response.getReturnValue());  
                console.log('After: ' + cmp.get("v.items"));
            }  
        });  
        $A.enqueueAction(action); 
        //console.log('Before: ' + response.getReturnValue());
    }     
})
({
    "echo" : function(cmp) {
        var action = cmp.get("c.serverEcho");
        var retvalue;
		//action.setStorable();
        action.setParams({ firstName : cmp.get("v.firstName") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                retvalue = response.getReturnValue();
                alert("From server: " + response.getReturnValue());
                cmp.set("v.retval",retvalue);
            }
        });
        $A.enqueueAction(action); 
        
        
    }
})
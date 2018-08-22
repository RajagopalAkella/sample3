({
	doInit : function(component, event, helper) {
		var a = component.get("v.number1");
        var b = component.get("v.number2");
        
        var event = $A.get("e.c:ExampleShareEvnt1");
        event.setParams({
            "num1":a,
            "num2":b
        });
        event.fire();
	},
    doAssign : function(component,event) {
        var x = event.getParam("num1");
        var y = event.getParam("num2");
        component.set("v.gotNum1", x);
        component.set("v.gotNum2", y);
    }
})
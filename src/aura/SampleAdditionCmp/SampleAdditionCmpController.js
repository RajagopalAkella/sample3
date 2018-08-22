({
	Calc : function(component, event, helper) {
		var a = component.get("v.variable1");
        var b = component.get("v.variable2");
        var c = a + b;
        component.set("v.result", c);
	}
})
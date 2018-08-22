({
	GetSum : function(component, event, helper) {
		var a1 = event.getParam("num1");
        var a2 = event.getParam("num2");
        var a3 = a1 - a2;
        component.set("v.SumResult", a3);
	}
})
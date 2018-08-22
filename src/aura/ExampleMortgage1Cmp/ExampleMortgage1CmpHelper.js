({  
    CalcTotal : function(component) {
		var a = component.get("v.number1");
        var b = component.get("v.number2");
        var c = a + b;
        component.set("v.result", c);
        
        var event = $A.get("e.c:ExampleMortgage1Event");
        event.setParams({
            			"num1":a,
            			"num2":b,
            			"res":c
                        });
        event.fire();
	}
})
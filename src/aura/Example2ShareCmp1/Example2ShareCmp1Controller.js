({
	doInit : function(component, event, helper) {
		var numb1 = component.get("v.number1");
        var numb2 = component.get("v.number2");
        var event = $A.get("e.c:Example2ShareEvnt1");
        
        event.setParams({"num1":numb1, "num2":numb2});
        event.fire();
        
	}
})
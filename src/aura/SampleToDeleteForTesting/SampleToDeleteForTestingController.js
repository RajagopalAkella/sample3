({
	CalculateSum : function(component) {
	var number1 = component.get("v.number1");
	var number2 = component.get("v.number2");
	var resultTemp = number1 + number2;
	component.set("v.resultSum", resultTemp);
	}
})
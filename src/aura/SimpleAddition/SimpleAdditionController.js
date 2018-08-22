({
	CalcSum : function(component) {
		var num1 = component.get("v.num1");
        var num2 = component.get("v.num2");
        var res = num1 + num2;
        component.set("v.res",res);
	}
})
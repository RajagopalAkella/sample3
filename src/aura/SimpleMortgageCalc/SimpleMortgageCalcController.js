({
	calculateMonthlyPayment : function(component) {        
		var principal = component.get("v.principal");
        var rate = component.get("v.rate");
        var years = component.get("v.years");
        var monthlyRate = rate / 100 / 12;
        var monthlyPayment = principal * monthlyRate / (1 - (Math.pow(1/(1 + monthlyRate), years * 12))); 
        component.set("v.monthlyPayment", monthlyPayment);
	}
})
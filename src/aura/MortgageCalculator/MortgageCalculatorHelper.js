({
	calculateMonthlyPayment : function(component) {
        //1. Calculate Monthly Payment
        var principal = component.get("v.principal");
        var rate = component.get("v.rate");
        var years = component.get("v.years");
        var monthlyRate = rate / 100 / 12;
        var monthlyPayment = principal * monthlyRate / (1 - (Math.pow(1/(1 + monthlyRate), years * 12))); 
        component.set("v.monthlyPayment", monthlyPayment);
        
        //2. Fire event with new Mortgage data
        var event = $A.get("e.c:MortgageChange");
        event.setParams({"principal":principal,
                         "years":years,
                         "rate":rate,
                         "monthlyPayment":monthlyPayment});
        event.fire();
	}
})
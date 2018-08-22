({
	handleAccountSelection : function(component, event) {
		var accountId = event.getParam("accountId");
		var action = component.get("c.getCaseInfo");
		action.setParams({
			accountId : accountId
		});
		
		action.setCallback(this, function(response){
			var state = response.getState();
			$A.log(response);
			if(state === "SUCCESS") {
				var cases = response.getReturnValue();
				component.set("v.cases", cases);
				$("cname").text('yo');
			}
		});
		$A.enqueueAction(action);
	}
})
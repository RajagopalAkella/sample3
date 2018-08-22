({
	accountSelected : function(component, event, helper) {
		var selectedId = component.get("v.acc.Id");
		var appEvent = $A.get("e.c:accountSelectionEvent");
		//console.log(selectedId);
		//console.log(appEvent);
		appEvent.setParams({"accountId":selectedId});
		appEvent.fire();
	}
})
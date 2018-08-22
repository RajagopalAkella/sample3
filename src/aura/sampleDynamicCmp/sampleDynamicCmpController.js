({
    doInit : function(component, event, helper) {
        var divCmp = component.find("MainDiv");
        var rec = component.get("v.AccountId");
        console.log("Account id is: " + rec);
        console.log("recordId is: " + component.get("v.recordId"));
        var action = component.get("c.checkTypeOfOperation");
        action.setParams({
            acctID : rec
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var opType = a.getReturnValue();
                component.set("v.operationType", opType);
                console.log('return value: ' + opType);
                //Add logic to build dynamic component
                if(component.get("v.operationType") == "Addition"){
                    $A.createComponent("c:SumCalculator",
                                       {
                                           "number1" : "1",
                                           "number2" : "2"
                                       }, 
                                       function(newCmp){
                                           var body = divCmp.get("v.body");
                                           body.push(newCmp);
                                           divCmp.set("v.body", body);
                                       });
                } else {
                    $A.createComponent("c:diffCalculator",
                                       {
                                           "number1" : "1",
                                           "number2" : "2"
                                       }, 
                                       function(newCmp){
                                           var body = divCmp.get("v.body");
                                           body.push(newCmp);
                                           divCmp.set("v.body", body);
                                       });                    
                }
                //Add logic till here
            }
            else if (a.getState() === "ERROR") {
                console.log("Initialization error");
            }
        });
        $A.enqueueAction(action);
    }
                           
})
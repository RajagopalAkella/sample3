({	
    createRecord : function (component, event) {
        var createRecordEvent = $A.get("e.force:createRecord");
        if(createRecordEvent){
            createRecordEvent.setParams({
                "entityApiName": "Contact"
            });
            createRecordEvent.fire();
        }
        else{
            console.log('#### Create record event is not supported.');
        }
    }
})
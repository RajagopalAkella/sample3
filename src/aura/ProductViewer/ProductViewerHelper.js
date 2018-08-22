({
    getProducts: function(component) {
        var action = component.get("c.getProducts");
        action.setCallback(this, function(a) {
            component.set("v.products", a.getReturnValue());
            //alert('get products: ' + a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    getProductSizes: function(component, productName) {        
        //alert('selected prod: ' + productName);
        var action2 = component.get("c.getProductSizes");
        action2.setParams({
            "name": productName
        });
        action2.setCallback(this,function(b) {
            component.set("v.productSizes", b.getReturnValue());
            //alert('response of productSizes: ' + b.getReturnValue());
        });
        $A.enqueueAction(action2);
    }
})
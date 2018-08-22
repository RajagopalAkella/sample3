({
    doInit : function(component, event, helper) {
        // for demo, just grab this product by name
        helper.getProducts(component);
        //helper.getProduct(component, 'Always Be Yourself');
        
    },
    change : function(component, event, helper) {
        // get the value of the select option
        var selectedName;
        selectedName = event.target.value;
        //alert('Selected Name: ' + selectedName);
        helper.getProductSizes(component, selectedName);
    }
})
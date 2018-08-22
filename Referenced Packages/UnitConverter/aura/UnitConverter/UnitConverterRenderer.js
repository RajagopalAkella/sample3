({
    render : function(cmp, helper) {
        var ret = this.superRender();
        helper.changeInputTypeAttribute(cmp, "inputNumberToConvert");
        helper.changeInputTypeAttribute(cmp, "inputNumberConverted");
        return ret;
    },
})
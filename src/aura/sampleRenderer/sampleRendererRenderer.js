({
    render: function(cmp, helper) {
       console.log('render function called');
       helper.changeValue(cmp);
       return this.superRender()
    },
})
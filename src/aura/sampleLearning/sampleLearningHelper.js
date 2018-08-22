({
    
    first : function(component, event, helper){
        // Simulate a code delay
        setTimeout( function(){
            console.log(1);
        }, 500 );
    },
    
    second : function(component, event, helper){
        console.log('2');
    }
    
})
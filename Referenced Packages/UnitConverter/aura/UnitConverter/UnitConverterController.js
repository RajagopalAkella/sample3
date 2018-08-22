({	
    // Populate the two units select lists based on the default category.
    doneRendering: function(cmp, event, helper) {
        //console.log("doneRendering()");
        // Only populate the lists with default values the first time 
        // the component is rendered.
        if(!cmp.get("v.isDoneRendering")) {
            cmp.set("v.isDoneRendering", true);
            var opts = new Array();
			var optionsArray = cmp.get("v.lengthOptions");
            //console.log("optionsArray (v.lengthOptions)=" + optionsArray);
        	for (var i = 0; i < optionsArray.length; i++) {
            	opts.push({class:"optionClass", label:optionsArray[i], text:optionsArray[i],
                          value:optionsArray[i]});
			}  
            cmp.find("inputSelectUnitFrom").set("v.options", opts);
        	cmp.find("inputSelectUnitTo").set("v.options", opts);      
        }
    },  
    
    // Populate the units in the select lists dynamically based on the category chosen in the first list.
    onConversionCategorySelect : function(cmp, evt) { 
        //console.log("onConversionCategorySelect()");		
		var selectedValue = evt.getSource().getElement().value;
        cmp.set("v.selectedCategory", selectedValue);
        //console.log("v.selectedCategory=" + selectedValue);
        var opts = new Array();
        var optionsArray=null;
        
		if (selectedValue == "Mass") {
            optionsArray = cmp.get("v.massOptions");			            
        } else if (selectedValue == "Length") {
            optionsArray = cmp.get("v.lengthOptions");
        } else if (selectedValue == "Temperature") {
            optionsArray = cmp.get("v.temperatureOptions");
        } else if (selectedValue == "Volume") {
            optionsArray = cmp.get("v.volumeOptions");
        } else if (selectedValue == "Area") {
            optionsArray = cmp.get("v.areaOptions");
        }
        //console.log("optionsArray=" + optionsArray);
        if (optionsArray != null) {
        	for (var i = 0; i < optionsArray.length; i++) {
            	opts.push({label:optionsArray[i], text:optionsArray[i],
                           value:optionsArray[i]});
			}  
            cmp.find("inputSelectUnitFrom").set("v.options", opts);
        	cmp.find("inputSelectUnitTo").set("v.options", opts);
        }
        
        // Clear the input and output number fields
        cmp.find("inputNumberToConvert").set("v.value","");
		cmp.find("inputNumberConverted").set("v.value","");
    },
    // Perform the unit conversion
    onUnitFromChange : function(cmp, evt, helper) {    
        //console.log("onUnitFromChange()");
        var selectedCategory = cmp.get("v.selectedCategory");
        //console.log("selectedCategory="+selectedCategory);
        // Call the appropriate helper function for each unit category.
        if (selectedCategory == "Length") {
            helper.convertLengthUnits(cmp, evt, helper);
        } else if (selectedCategory == "Temperature") {
        	helper.convertTemperatureUnits(cmp, evt, helper);
        } else if (selectedCategory == "Mass") {
            helper.convertMassUnits(cmp, evt, helper);
        } else if (selectedCategory == "Volume") {
            helper.convertVolumeUnits(cmp, evt, helper);
        } else if (selectedCategory == "Area") {
            helper.convertAreaUnits(cmp, evt, helper);
        }                        
    },
	onInputFocus : function(cmp, evt, helper) {
		// Chrome and Firefox don't clear the placeholder text 
		// in the input field when clicked in. IE does.
		// So clear the input field explicitly.
        if (evt.getSource().get("v.placeholder")==cmp.get("v.placeholderInputText") ||
            evt.getSource().get("v.placeholder")==cmp.get("v.placeholderOutputText")) {            
            evt.getSource().set("v.placeholder", "");        	
        }
	},
    onInputNumberBlur : function(cmp, evt, helper) {
        // Chrome and Firefox don't clear the placeholder text 
		// in the input field when clicked in. IE does.
		// So if it was cleared explicitly by onInputFocus(), reset the text
		// when the focus is lost.		
		if ((evt.getSource().get("v.placeholder")==null) || 
            (evt.getSource().get("v.placeholder")=="")) {
            // For some reason, cmp.get("v.placeholderInputText") returns nothing, so
            // have to hardcode the string value.
            evt.getSource().set("v.placeholder", "Value to convert..."); 
        }		
	},
    onOutputNumberBlur : function(cmp, evt, helper) {
        // Chrome and Firefox don't clear the placeholder text 
		// in the input field when clicked in. IE does.
		// So if it was cleared explicitly by onInputFocus(), reset the text
		// when the focus is lost.		
		if ((evt.getSource().get("v.placeholder")==null) || 
            (evt.getSource().get("v.placeholder")=="")) { 
			// For some reason, cmp.get("v.placeholderOutputText") returns nothing, so
            // have to hardcode the string value.
            evt.getSource().set("v.placeholder", "Output..."); 
        }		
	}
})
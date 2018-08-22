({
    convertUnits : function(cmp, helper, multiplier) {                   
        // Get the measurement input to convert
        var inputCmp = cmp.find("inputNumberToConvert");        
        
        // Validate input
        if (helper.validateInput(inputCmp)) {            
            // Get input value
            var input = inputCmp.get("v.value");
            //console.log('input='+input);
            
            // Convert the measurement
            var output = (new BigDecimal(String(input))).multiply(multiplier);
            //console.log('formula='+multiplier);
            //console.log('output='+output);
            
            // Set the output value on the select list component
            cmp.find("inputNumberConverted").set("v.value",output); 
        }                
    },
    validateInput : function(inputCmp) {
        var input = inputCmp.get("v.value");
        var isValid = false;
        
        // Validate input
        if ((input==null) || (input=='')) {
            // Clear previous error message first
            // so we don't get a list of errors displayed for this component.
            inputCmp.set("v.errors", null);            
            // Set error message
            //inputCmp.setValid("v.value", false);            
            inputCmp.set("v.errors", [{message:"Enter a number to convert."}]); 
        } else if (isNaN(input)) {
             // Clear previous error message first
             // so we don't get a list of errors displayed for this component.
            inputCmp.set("v.errors", null);            
            // Set error message
            //inputCmp.setValid("v.value", false);            
            inputCmp.set("v.errors", [{message:"Input is not a number."}]);                   
        } else {
            // Clear errors
            inputCmp.set("v.errors", null);
            isValid = true;
        }
        return isValid;
    },
    getSelectedUnitFromIndex : function(cmp) {
        var unitFromValue = cmp.find("inputSelectUnitFrom").get("v.value");        
        var unitFromSelectOptionList = cmp.find("inputSelectUnitFrom").get("v.options");        
        // Get selected value index in the options From list
        var unitFromIndex = unitFromSelectOptionList.map(function(option){ 
            return option.value; }).indexOf(unitFromValue);
        //console.log('unitFromIndex=' + unitFromIndex);
        return unitFromIndex;
    },
    getSelectedUnitToIndex : function(cmp) {
        var unitToValue = cmp.find("inputSelectUnitTo").get("v.value");
        var unitToSelectOptionList = cmp.find("inputSelectUnitTo").get("v.options");                
		// Get selected value index in the options To list
        var unitToIndex = unitToSelectOptionList.map(function(option){ 
            return option.value; }).indexOf(unitToValue);
        //console.log('unitToIndex='+unitToIndex);
        return unitToIndex;
    },
	convertMassUnits : function(cmp, evt, helper) {
		// Two-dimensional array stores the formula for each conversion.
        // Row index is unit from.
        // Column index is unit to.
        // Array rows and columns correspond to the following units:
        // KILOGRAM: 0,GRAM: 1, MILLIGRAM: 2,METRIC TON: 3, SHORT TON: 4, LONG TON: 5, POUND: 6, OUNCE: 7, STONE: 8
        // So cell [0][0] is 1 Kilogram -> Kilogram conversion, 
        // and cell [0][1] is 1 kilogram -> gram conversion.
        // NOTE: Values are taken from Google's Unit Converter.
        //     See https://support.google.com/websearch/answer/3284611?hl=en#unitconverter        
        //     and http://www.mathsisfun.com/unit-conversion-tool.php
        var massFormulaTable = [[1,1000,1000000,0.001,0.00110231136,0.0009842064397,2.204622622,35.27396195,0.157473], // Kilogram
                                [0.001,1,1000,1000000,0.00000110231136,0.0000009842064397,0.002204622622,0.03527396195,0.000157473], // Gram
                                [1/1000000,0.001,1,0.000000001,0.00000000110231136,0.0000000009842064397,0.000002204622622,0.00003527396195,0.000000157473], // Milligram 0.000001
                                [1000,1000000,1000000000,1,1.10231136,0.9842064397,2204.622622,35274,157.473], // Metric Ton
                                [0.00110231136,0.00000110231136,0.00000000110231136,0.9071847,1,0.8928570233,2000,32000,142.857], // Short Ton (US)
                                [0.0009842064397,0.0000009842064397,0.0000000009842064397,1.016047,1,2240,35840.00322,160], // Long Ton
                                [0.45359237,453.592,453592,0.000453592,0.000500000022,0.0004464285313,1,16,0.0714286], // Pound
                                [0.0283495,28.3495,28349.5,0.00002835,0.00003125000138,0.00002790178321,0.0625,1,0.00446429], // Ounce
                                [6.35029,6350.29,6350290,0.00635029,0.007,0.00625,14,224,1]]; // Stone       
        
        var unitFromIndex = helper.getSelectedUnitFromIndex(cmp);
        var unitToIndex = helper.getSelectedUnitToIndex(cmp);
        var multiplier = new BigDecimal(String(massFormulaTable[unitFromIndex][unitToIndex]));
        helper.convertUnits(cmp, helper, multiplier);
	},
    
    convertLengthUnits : function(cmp, evt, helper) {
		// Two-dimensional array stores the formula for each conversion.
        // Row index is unit from.
        // Column index is unit to.
        // Array rows and columns correspond to the following units:
        // Kilometer,Meter,Centimeter,Millimeter,Mile,Yard,Foot,Inch,Nautical Mile
        // So cell [0][0] is 1 Kilometer -> Kilometer conversion, 
        // and cell [0][1] is 1 Kilometer -> Meter conversion.
        // NOTE: Values are taken from Google's Unit Converter.
        //     See https://support.google.com/websearch/answer/3284611?hl=en#unitconverter.
        var lengthFormulaTable = [[1,1000,100000,1000000,0.621371,1093.613298,3280.84,39370.1,0.539957], // Kilometer
                                [0.001,1,100,1000,0.000621371,1.09361,3.28084,39.3701,0.000539957], // Meter
                                [0.00001,0.01,1,10,0.00000621371,0.0109361,0.0328084,0.393701,0.00000539957], // Centimeter
                                [0.000001,0.001,0.1,1,0.000000621371,0.00109361,0.00328084,0.0393701,0.000000539957], // Millimeter
                                [1.60934,1609.34,160934,1609340,1,1760,5280,63360,0.868976], // Mile
                                [0.0009144,0.9144,91.44,914.4,0.000568182,1,3,36,0.000493737], // Yard
                                [0.0003048,0.3048,30.48,304.8,0.000189394,0.333333,1,12,0.000164579], // Foot
                                [0.0000254,0.0254,2.54,25.4,0.000015783,0.0277778,0.0833333,1,0.000013715], // Inch
                                [1.852,1852,185200,1852000,1.15078,2025.37,6076.12,72913.4,1]]; // Nautical Mile      
        
        var unitFromIndex = helper.getSelectedUnitFromIndex(cmp);
        var unitToIndex = helper.getSelectedUnitToIndex(cmp);
        var multiplier = new BigDecimal(String(lengthFormulaTable[unitFromIndex][unitToIndex]));
        //console.log('multiplier in convertlengthUnits(): ' + multiplier);
        helper.convertUnits(cmp, helper, multiplier);        
	},
    
    convertTemperatureUnits : function(cmp, evt, helper) {
		// Can't use an array for temperature because the units
		// are not proportional.
		// Using the formula instead for each conversion.
		var unitFromValue = cmp.find("inputSelectUnitFrom").get("v.value"); 
		var unitToValue = cmp.find("inputSelectUnitTo").get("v.value");
        
        // Validate input
        var inputCmp = cmp.find("inputNumberToConvert");
        if (helper.validateInput(inputCmp)) {
            // Get the measurement input to convert
            var input = cmp.find("inputNumberToConvert").get("v.value");
            var output;
            var celsius = "Celsius";
            var fahrenheit = "Fahrenheit";
            var kelvin = "Kelvin";
            var inputBigD = new BigDecimal(String(input));
            var inputBigD = new BigDecimal(String(input));
            var nine = new BigDecimal("9");
            var five = new BigDecimal("5");
            var thirtyTwo = new BigDecimal("32");
            var kelvinAdd = new BigDecimal("273.15");
            var kelvinMultiplier = new BigDecimal("1.8");
            if (unitFromValue == unitToValue) {
                output = input;
            } else if ((unitFromValue==celsius) && (unitToValue==fahrenheit)) {
                // Fahrenheit = Celsius*9/5 + 32
                output = inputBigD.multiply(nine).divide(five).add(thirtyTwo);
            } else if ((unitFromValue==celsius) && (unitToValue==kelvin)) {
                // Kelvin = Celsius + 273.15
                output = inputBigD.add(kelvinAdd);
            } else if ((unitFromValue==fahrenheit) && (unitToValue==celsius)) {
                // Celsius = (Fahrenheit-32)*5/9
                output = inputBigD.subtract(thirtyTwo).multiply(five).divide(nine);
            } else if ((unitFromValue==fahrenheit) && (unitToValue==kelvin)) {
                // Kelvin = (Fahrenheit-32)/1.8 + 273.15
                output = inputBigD.subtract(thirtyTwo).divide(kelvinMultiplier).add(kelvinAdd);
            } else if ((unitFromValue==kelvin) && (unitToValue==celsius)) {
                // Celsius = Kelvin - 273.15
                output = inputBigD.subtract(kelvinAdd);
            } else if ((unitFromValue==kelvin) && (unitToValue==fahrenheit)) {
                // Fahrenheit =(Kelvin - 273.15)* 1.8 + 32
                output = inputBigD.subtract(kelvinAdd).multiply(kelvinMultiplier).add(thirtyTwo);
            }
     
            // Set the output value on the select list component
            cmp.find("inputNumberConverted").set("v.value",output);
        }            
	},
    
    convertVolumeUnits : function(cmp, evt, helper) {
        // Two-dimensional array stores the formula for each conversion.
        // Row index is unit from.
        // Column index is unit to.
        // Array rows and columns correspond to the following units:
        // Gallon,Quart,Pint,Liter,Ounce
        // So cell [0][0] is Gallon -> Gallon conversion, 
        // and cell [0][1] is Gallon -> Quart conversion.
        // NOTE: Values are taken from Google's Unit Converter.
        //     See https://support.google.com/websearch/answer/3284611?hl=en#unitconverter.
        var volumeFormulaTable = [
            [1,4,8,3.78541,128], // Gallon
            [0.25,1,2,0.946353,32], // Quart
            [0.125,0.5,1,0.473176,16], // Pint
            [0.264172,1.05669,2.11338,1,33.814], // Liter
            [0.0078125,0.03125,0.0625,0.0295735,1] // Ounce
        ];        
        
        var unitFromIndex = helper.getSelectedUnitFromIndex(cmp);
        var unitToIndex = helper.getSelectedUnitToIndex(cmp);
        var multiplier = new BigDecimal(String(volumeFormulaTable[unitFromIndex][unitToIndex]));
        helper.convertUnits(cmp, helper, multiplier);
    },
    
	convertAreaUnits : function(cmp, evt, helper) {
        // Two-dimensional array stores the formula for each conversion.
        // Row index is unit from.
        // Column index is unit to.
        // Array rows and columns correspond to the following units:
        // Square km,square meter,acre,hectare,square foot,square inch, square yard,square mile
        // So cell [0][0] is 1 Square km -> Square km conversion, 
        // and cell [0][1] is 1 Square km -> Square meter conversion.
        // NOTE: Values are taken from Google's Unit Converter.        
        //     See http://www.mathsisfun.com/unit-conversion-tool.php
        var areaFormulaTable = [
            [1,1000000,247.1053815,100,10763910.42,1550003100,1195990.046,0.3861021584], // Square km
            [0.000001,1,0.0002471053815,0.0001,10.76391042,1550.0031,1.195990046,0.0000003861021584], // square meter
            [0.004046856422,4046.856422,1,0.4046856422,43560,6272640,4840,0.0015625], // acre
            [0.01,10000,2.471053815,1,107639.1042,15500031,11959.90046,0.003861021584], // hectare
            [0.00000009290304,0.09290304,0.00002295684114,0.000009290304001,1,144,0.1111111111,0.00000003587006428], // square foot
            [0.00000000064516,0.00064516,0.0000001594225079,0.000000064516,0.006944444444,1,0.0007716049382,0.0000000002490976686], // square inch
            [0.00000083612736,0.83612736,0.0002066115702,0.00008361273598,9,1296,1,0.0000003228305785], // square yard
            [2.58998811,2589988.11,640,258.998811,27878400,4014489600,3097600,1] // square mile
        ];        
        
        var unitFromIndex = helper.getSelectedUnitFromIndex(cmp);
        var unitToIndex = helper.getSelectedUnitToIndex(cmp);
        var multiplier = new BigDecimal(String(areaFormulaTable[unitFromIndex][unitToIndex]));
        helper.convertUnits(cmp, helper, multiplier);
    },
    // ui:inputNumber has type="text" instead of type="Number", so change it after 
    // the component is rendered.
    changeInputTypeAttribute : function(cmp, cmpId) {                
		var inputNumber = cmp.find(cmpId);
    	if (inputNumber) {
    		var typeAttr = inputNumber.get('v.type');
            console.log('type attribute=' + typeAttr);
        	if (typeAttr == "text") {
            	inputNumber.set('v.type', 'number');
        	}
            // Adjust the style to remove the number spin button
            //var spinButton = inputNumber.get('v.style.');
		}		        
    },
})
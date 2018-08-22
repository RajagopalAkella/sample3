({
    attFile : function(component) {
        var fileInput = component.find("file").getElement();
    	var file = fileInput.files[0];
    	var MAX_FILE_SIZE = 4500000;
    	var CHUNK_SIZE = 500000;
        if (file.size > MAX_FILE_SIZE) {
            alert('File size cannot exceed ' + MAX_FILE_SIZE + ' bytes.\n' +
    		  'Selected file size: ' + file.size);
    	    return;
        }
        var fr = new FileReader();
		//var self = this;
        fr.onload = $A.getCallback(function() {
            var fileContents = fr.result;
    	    var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);
            console.log('Total file size: ' + file.size + 'MB base64Mark: ' + fileContents.length);
    	    upload(component, file, fileContents, CHUNK_SIZE);
        });
        fr.readAsDataURL(file);
        
        var upload = function(component, file, fileContents, CHUNK_SIZE) {
            var fromPos = 0;
            var toPos = Math.min(fileContents.length, fromPos + CHUNK_SIZE);
            var ChunkStatus = '';
            toPos >= fileContents.length ? ChunkStatus = 'FinalChunk' : ChunkStatus = 'NotFinalChunk';
            console.log('Upload first chunk from: 0 to : ' + toPos);
            uploadChunk(component, file, fileContents, CHUNK_SIZE, fromPos, toPos, ChunkStatus, '');   
        }
        
        var uploadChunk = function(component, file, fileContents, CHUNK_SIZE, fromPos, toPos, ChunkStatus, attachId) {
            var action = component.get("c.saveTheChunk"); 
            var chunk = fileContents.substring(fromPos, toPos);
            action.setParams({
                parentId: component.get("v.parentId"),
                fileName: file.name,
                base64Data: encodeURIComponent(chunk), 
                contentType: file.type,
                fileId: attachId,
                attDesc: ChunkStatus
            });
            //var self = this;
            action.setCallback(this, function(a) {
                attachId = a.getReturnValue();
                fromPos = toPos;
                toPos = Math.min(fileContents.length, fromPos + CHUNK_SIZE);
            var ChunkStatus = '';
            toPos >= fileContents.length ? ChunkStatus = 'FinalChunk' : ChunkStatus = 'NotFinalChunk';
                if (fromPos < toPos) {
                    console.log('Upload again chunk from: ' + fromPos + ' to: ' + toPos);
                    uploadChunk(component, file, fileContents, CHUNK_SIZE, fromPos, toPos, ChunkStatus, attachId);  
                }
                else {
                    console.log('Attachment done Id: ' + attachId);
                }
            });
            $A.enqueueAction(action); 
        }
    
        
    }    
})
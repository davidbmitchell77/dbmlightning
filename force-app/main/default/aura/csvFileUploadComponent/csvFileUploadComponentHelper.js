({  
    updateDocument: function(component, event, id)
    {  
        var action = component.get("c.updateFiles");
        var fName = component.find("fileName").get("v.value");
        action.setParams({ "documentId": Id, "title": fName, "recordId": component.get("v.recordId") });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state == "SUCCESS")
            {
                var result = response.getReturnValue(); 
                console.log('Result returned: ' + result);
                component.find("fileName").set("v.value", " ");
                component.set("v.files", result);
            }  
        });
        $A.enqueueAction(action);
    }
 })
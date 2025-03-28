({
    handleClick: function(component, event, helper)
    {
        alert("handleClick!");
    },
    handleUpload: function(component, event, helper)
    {
        alert("handleUpload!");
        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        helper.updateDocument(component, event, documentId);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ "title": "Success!", "message": "File " + fileName + " uploaded successfully." });
        toastEvent.fire();
     /* Open File after upload
        $A.get('e.lightning:openFiles').fire({ recordIds: [documentId] });
     */
    },
    openFile: function(component, event, helper)
    {
        var recId = event.currentTarget.id;
        $A.get('e.lightning:openFiles').fire({ recordIds: [recId] });
    },
    initialize: function(component, event, helper)
    {
        alert("initialize!");
        component.set("v.extensions", [ '.csv', '.tab', '.tsv', '.txt' ]);
        component.set("v.recordId", "0066g000003P9e2AAC");

        var action = component.get("c.getFiles");
        action.setParams({ "recordId": component.get("v.recordId") });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state == "SUCCESS")
            {
                var result = response.getReturnValue();
                console.log("result: " + result);
                component.set("v.files", result);
            }
        });
        $A.enqueueAction(action);
    }
})
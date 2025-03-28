({
    initialize : function(component, event, helper)
    {
        var isValid = component.isValid();

        if (isValid) {
            $A.enqueueAction(helper.getData(component), false);
        }
        else {
            console.error("component.isValid():", component.isValid());
        }
    },
    clickHandler : function(component, event, helper)
    {
        var label = event.getSource().get("v.label").toLowerCase();
        var name = event.getSource().get("v.name").toLowerCase();

        if (label === "start learning!")
        {
            helper.fireEvent(component, event)
        }
    },
    gotoUrl : function(component, event, helper)
    {
        var params = event.getParams();
        var url = params.url;
        
        window.open(url, "_blank");
    }
})
({
	getData : function(component, event)
    {
        var courseType = component.get("v.trainingType");

        var action = component.get("c.getTrainings");
        action.setParams({ courseType: courseType });

        action.setCallback
        (
            this,
            (response) =>
            {
                var state = response.getState();
                if (state === "SUCCESS")
                {
                    var returnValue = response.getReturnValue();
                    console.info("returnValue:", JSON.stringify(returnValue, null, 2));
                    component.set("v.trainingList", returnValue);
                }
                else {
                    var e = response.getError();
            		console.error(state, e);
                }
            }
        );

        return action;
	},
    fireEvent : function(component, event)
    {
        var eventName = event.getName();

        if (eventName = "gotoUrl")
        {
            var theUrl = event.getSource().get("v.name");
            var urlEvent = component.getEvent("gotoUrl");
            urlEvent.setParams({ url: theUrl });
            urlEvent.fire();
        }
    },
    helperMethod03 : function(component, event)
    {

    },
    helperMethod04 : function(component, event)
    {

    },
    helperMethod05 : function(component, event)
    {

    },
    helperMethod06 : function(component, event)
    {

    },
    helperMethod07 : function(component, event)
    {

    },
    helperMethod08 : function(component, event)
    {

    },
    helperMethod09 : function(component, event)
    {

    },
    helperMethod10 : function(component, event)
    {

    }
})
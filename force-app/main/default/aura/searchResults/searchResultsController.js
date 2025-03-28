({
	doInit : function(component, event, helper)
    {
        document.title = "Lightning Search";
		var action = component.get("c.getMap");
        action.setParams( { searchString : component.get("v.searchString") } );
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.theMap", response.getReturnValue());
            } else {
                var errorMessage = "doInit() failed with state: " + state;
                console.log(errorMessage);
                alert(errorMessage);
            }
        });
        $A.enqueueAction(action);
	}
})
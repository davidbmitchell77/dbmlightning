({
	handleClick : function(component, event, helper)
    {
		var btn = event.getSource();
        var motd = btn.get("v.label");
        console.log("handleClick: " + motd);
        component.set("v.message", motd);
	}
})
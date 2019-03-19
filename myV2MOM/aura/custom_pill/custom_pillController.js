({
    destroyPill: function (component, event, helper) {
    	// Check to see if this component is in Strike Fiddler so we stop user from removing it
    	if (component.get('v.destroyable')) {
            helper.notifyParent(component);
            helper.destroyComponent(component);
        }
    }
})
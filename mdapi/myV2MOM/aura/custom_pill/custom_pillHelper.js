({
    destroyComponent: function (component) {
        component.destroy();
    },
    notifyParent: function (component) {
        var destroyEvent = component.getEvent("strike_evt_componentDestroyed");
        destroyEvent.setParams({
            'data' : {"value": component.get('v.value')}
        });
        destroyEvent.fire();
    }
})
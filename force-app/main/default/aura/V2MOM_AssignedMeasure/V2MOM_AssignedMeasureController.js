({
	editMethod : function(component, event, helper) {
        var params = event.getParam('arguments');
        component.set('v.measure', params.measure);
        helper.modalHelper(component, 'srModal', 'modalBkdrp', true);
	},
    SaveAssignedMeasure : function(component, event, helper) {
        var appEvent = $A.get("e.c:V2MOM_ChildRecordEvent");
        appEvent.setParams({
            "record" : component.get('v.measure')
        });
        appEvent.fire();
        helper.modalHelper(component, 'srModal', 'modalBkdrp', false);
    },
    closeModal : function(component, event, helper) {
        helper.modalHelper(component, 'srModal', 'modalBkdrp', false);
    },
})
({
    openModal : function(component, event, helper) {
        helper.modalHelper(component, 'srModal', 'modalBkdrp', true);
    },
    closeModal : function(component, event, helper) {
        helper.modalHelper(component, 'srModal', 'modalBkdrp', false);
    },
    adoptMeasure : function(component,event,helper){
        var params = event.getParam('arguments');
        component.set('v.SelectecMeasureRecord', params.measureRecord);
        helper.modalHelper(component, 'srModal', 'modalBkdrp', true);
    },
    doInit : function(component,event,helper){
        var action = component.get("c.getCurrentV2MOMMethods");
        action.setParams({ "currentUsedV2MOMId" : component.get("v.currentUserV2MOMId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.currentV2MOMMethods",response.getReturnValue());
            }else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.");
            }else if (state === "ERROR") {
                console.log('An unknown error occured.');
            }
        });
        $A.enqueueAction(action);
    },
    save : function(component,event,helper){
        var action = component.get("c.copyMeasureToMyV2MOM");
        var selectedOption_Measure = component.get("v.selectedOption_Measure");
        if(selectedOption_Measure == 'New Measure'){
            action.setParams({
                "methodId" : null,
                "measure" : component.get("v.SelectecMeasureRecord"),
                "currentUsedV2MOMId" : component.get("v.currentUserV2MOMId"),
                "measureName" : component.get('v.newMeasureName')
            });
        }else{
            action.setParams({
                "methodId" : component.get('v.selectedMeasure'),
                "measure" : component.get("v.SelectecMeasureRecord"),
                "currentUsedV2MOMId" : component.get("v.currentUserV2MOMId"),
                "measureName" : null
            });
        }
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.newMeasureName', null);
                component.set('v.selectedOption_Measure', 'Existing Measure');
                helper.modalHelper(component, 'srModal', 'modalBkdrp', false);
                helper.toastMessage('Success!', 'The measure was copied to your V2MOM successfully.', 'success');
            }else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.");
            }else if (state === "ERROR") {
                console.log('An unknown error occured.');
            }
        });
        $A.enqueueAction(action);
    }
})
({  
    doInit: function(component, event, helper){
        var cmpTarget = component.find('srModal');
        $A.util.toggleClass(cmpTarget, 'HideModal');
    },
    handleCancel : function(component, event, helper) {
        component.find("overlayLib").notifyClose();
    },
    deleteMeasureAction : function(component,event,helper){
        console.log("inside delete method");
        var action = component.get("c.deleteMeasure");
        var selectedMeasureId = component.get("v.mId");
        console.log("measure to delete: "+selectedMeasureId);
        action.setParams({
            mId : selectedMeasureId
        });
        $A.enqueueAction(action);
        component.find("overlayLib").notifyClose();
    }
})
({
    modalHelper : function(component, modal, backdrop, tf) {
        var mdl = component.find(modal).getElement();
        var bkdrp = component.find(backdrop).getElement();
        if(tf){
            $A.util.addClass(mdl, 'slds-fade-in-open');
            $A.util.addClass(bkdrp, 'slds-backdrop_open');
        }else{
            $A.util.removeClass(mdl, 'slds-fade-in-open');
            $A.util.removeClass(bkdrp, 'slds-backdrop_open');
        }
    },
    updateMethodsOrder : function(component, event, helper) {
        var action = component.get("c.updateMethodSequence");
        action.setParams({"methodstoBeUpdated":component.get("v.methodsTobeUpdated")});
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                helper.showToast('Success','Methods re-ordered successfully.', 'success',component, event, helper);
                helper.modalHelper(component, 'srModal', 'modalBkdrp', false);
                var valueChangeEvent = component.getEvent("updateView");
                valueChangeEvent.fire();
            }else if (state === "ERROR") {
                console.log('An unknown error occured.');
            }
            
        });
        $A.enqueueAction(action);
    },
    showToast: function(resultStatus,message, messageType, component, event, helper) {
        let toastParams = {
                    title: resultStatus,
                    message: message,
                    type: messageType
                };
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
        
    }
})
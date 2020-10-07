({
	myAction : function(component, event, helper) {
		
	},
    closeModal : function(component, event, helper) {
        helper.modalHelper(component, 'srModal', 'modalBkdrp', false);
        component.set("v.method",{'sobjectType':'Method__c'});
        component.set("v.v2momId", '');
    },
    showMethodModal : function(component, event, helper){
        var params = event.getParam('arguments');
        if(params.method != 'undefined' && params.method != null){
            component.set("v.method",params.method);
        }else{
            component.set("v.method",{'sobjectType':'Method__c'});
        }
        component.set("v.v2momId",params.v2momId);
        component.set("v.isReadOnly",params.isReadOnly);
        helper.modalHelper(component, 'srModal', 'modalBkdrp', true);       
    },
    
    saveMethod : function(component, event, helper){
        var action = component.get('c.createMethod');
        action.setParams({
            method : component.get("v.method"),
            v2MOMId : component.get("v.v2momId")
        });
        action.setCallback(component,function(response) {
            var state = response.getState();
            if (state === 'SUCCESS'){
                var successMessage = 'Method \''+component.get("v.method.Name")+ '\' saved successfully.';
                helper.toastMessage('Success!', successMessage, 'success');
                component.set("v.method",{'sobjectType':'Method__c'});
                component.set("v.v2momId", '');
            } else if (state === 'INCOMPLETE'){
                console.log("No response from server or client is offline.");
            }else if (state === 'ERROR'){
                console.log('An unknown error occured.');
            }
             
        });
        $A.enqueueAction(action);
        
        var valueChangeEvent = component.getEvent("updateView");
        valueChangeEvent.fire();
        helper.modalHelper(component, 'srModal', 'modalBkdrp', false);
        
    }
})
({
	doInit : function(component, event, helper) {
		
	},
    closeModal : function(component, event, helper) {
        helper.modalHelper(component, 'srModal', 'modalBkdrp', false);
    },
    showObstaclesComments : function(component, event, helper){
        var params = event.getParam('arguments');
        if(params.currentUserId == params.v2momUserId && !params.isAssignedMeasure){
            component.set("v.isReadOnly",false);
        }else{
            component.set("v.isReadOnly",true);
        }
        
        var action = component.get('c.getObstaclesAndComments');
        action.setParams({
            'mId': params.measureId
        });
        action.setCallback(this, function(res){
            var state = res.getState();
            if(state === 'SUCCESS'){
                var rVal = res.getReturnValue();
                helper.modalHelper(component, 'srModal', 'modalBkdrp', true);
                component.set("v.measure",rVal); 
            }else if(state === 'ERROR'){
                var errors = res.getError();
                var errorMsg;
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMsg = errors[0].message;
                    }
                } else {
                    errorMsg = "An Unknown error occured."
                }
                console.log('An unknown error occured.');
            }else{
                //console.log(state);
            }
        });
        $A.enqueueAction(action);        
    },
    
    saveObsComm : function(component, event, helper){
        var action = component.get('c.saveObstaclesAndComments');
        action.setParams({
            'meas': component.get("v.measure")
        });
        action.setCallback(this, function(res){
            var state = res.getState();
            if(state === 'SUCCESS'){
                helper.toastMessage('Success!', 'Obstacle or Comment updated successfully.', 'success');
                helper.modalHelper(component, 'srModal', 'modalBkdrp', false);
            }if(state === 'ERROR'){
                console.log('An unknown error occured.');
            }
        });
        $A.enqueueAction(action);
    },
    
    hideObstaclesComments : function(component, event, helper){
        helper.modalHelper(component, 'srModal', 'modalBkdrp', false);
    }
})
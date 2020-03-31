({  
    doInit : function(component, event, helper) {
        var action = component.get('c.getAllMeasurePickLists');
        action.setCallback(this, function(res){
            var state = res.getState();
            if(state === 'SUCCESS'){
                var rVal = res.getReturnValue();
                component.set('v.trackProgressOptions', rVal.progress);
                component.set('v.priorityOptions', rVal.priority);
                component.set('v.statusOptions', rVal.status);
            }else if(state === 'ERROR'){
                console.log('An unknown error occured.');
            }else{
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    },
	handleProgressRadioChange : function(component, event, helper) {
        var currentValue = event.getParam('value')[0];
        if(currentValue){
            component.set('v.trackProgressOptionvalue', currentValue);
        }
	},
    
})
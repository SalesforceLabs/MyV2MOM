({
	doInit : function(component, event, helper) {
        var action = component.get('c.getOrgUsers');
        /*action.setParams({
            'placeName': sStr
        });*/
        action.setCallback(this, function(res){
            var state = res.getState();
            if(state === 'SUCCESS'){
                var rVal = res.getReturnValue();
                console.log(rVal);
                component.set('v.userList', rVal);
            }else if(state === 'ERROR'){
                console.log('An unknown error occured.');
            }else{
                console.log(state);
            }
        });
        $A.enqueueAction(action);
	}
})
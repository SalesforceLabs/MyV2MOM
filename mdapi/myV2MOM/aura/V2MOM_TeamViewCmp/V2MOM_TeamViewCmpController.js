({
	doInit : function(component, event, helper) {
		var action = component.get("c.fetchUsers");
        action.setParams({v2momId : component.get("v.v2momId")});
        action.setCallback(this, function(a) {
            var state = a.getState();
            var usersMap = a.getReturnValue();
            if (state === "SUCCESS") {
                var usersList = [];
                var conts = a.getReturnValue();
                for (var key in conts ) {
                    usersList.push({value:conts[key], key:key});
                }
                component.set("v.usersMapAttr",usersList);
            }else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.");
            }else if (state === "ERROR") {
                console.log('An unknown error occured.');
            }
        });
        
        
        $A.enqueueAction(action);  
	},
    
    redirectV2MOMHandler : function(component, event, helper) {
        var selectedUserId = event.currentTarget.dataset.userid;
        var action = component.get("c.redirectV2MOM");
        action.setParams({v2momId : component.get("v.v2momId"),
                          selUserId : selectedUserId});
        action.setCallback(this, function(a) {
            var state = a.getState();
            var redUserV2MOMId = a.getReturnValue();
            if (state === "SUCCESS") {
                if(redUserV2MOMId != ''){
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                      "recordId": redUserV2MOMId
                    });
                    navEvt.fire();
                    
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "",
                        "message": "V2MOM not drafted.",
                        "type": "info",
                        "duration":3000
                    });
                    toastEvent.fire();
                }
            }else if (state === "INCOMPLETE") {
                
            }else if (state === "ERROR") {
                console.log('An unknown error occured.');
            }
        });
        
        $A.enqueueAction(action);  
    }
})
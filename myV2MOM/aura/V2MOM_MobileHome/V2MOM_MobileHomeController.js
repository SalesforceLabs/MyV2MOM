({
    doInit: function(component, event, helper){
        var action = component.get("c.fetchUserId");
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                component.set('v.currentUserId', a.getReturnValue());
            }else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.");
            }else if (state === "ERROR") {
                console.log('An unknown error occured.');
            }
        });
        
        $A.enqueueAction(action);  
        
        var checkIfUserIsManagerAction = component.get("c.isUserAManagerMob");
        checkIfUserIsManagerAction.setParams({
            uId : component.get("v.v2momUserId")
        });
        checkIfUserIsManagerAction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isManager", response.getReturnValue());
                
                helper.createDynComponent(component, event, "c:V2MOMMobileV2");
                helper.createDynComponent(component, event, "c:V2MOMMobileMOM");
            }
        });
        $A.enqueueAction(checkIfUserIsManagerAction);
        
        var opts = [];
        var v2momOpts = component.get("v.v2momOptions");
        for(var i=0; i< v2momOpts.length; i++){
            var optObj = {};
            optObj.value = v2momOpts[i].Id;
            optObj.label = 'FY'+v2momOpts[i].myV2MOM__FY_Year__c;
            opts.push(optObj);
        }
        
        component.set("v.v2momOptionsArr", opts);
    },
    
    selV2MOMChange: function (component, event) {
    	var selV2momId = event.getParam('value');
		var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": selV2momId
        });
        navEvt.fire();
    },
    
    handleDelectedTab : function (component, event) {
        component.set('v.currentTab',parseInt(event.getSource().getLocalId()));
    },
    
    publishV2MOMJS : function (component, event) {
        var action = component.get("c.publishV2MOMMob");
        action.setParams({v2momIdVal : component.get("v.v2momId")});
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            
            if (state === "SUCCESS") {
                component.set("v.v2momObj", a.getReturnValue());
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "V2MOM published successfully.",
                    "type": "success"
                });
                toastEvent.fire();
            }else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.");
            }else if (state === "ERROR") {
                console.log('An unknown error occured.');
            }
        });
        
        $A.enqueueAction(action);  
    },
    
    navManagerV2MOM : function (component, event) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.managerV2MOMId")
        });
        navEvt.fire();
    },
    
    navToCurrV2mom : function (component, event) {
    	var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.currentUserV2MOMId")
        });
        navEvt.fire();
    }
})
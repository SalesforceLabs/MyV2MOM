({
	doInit : function(component, event, helper) {
		var action = component.get("c.fetchV2V");
        action.setParams({v2momIdVal : component.get("v.v2momId")});
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var v2momObj = a.getReturnValue();
                component.set("v.visionAttr", v2momObj.myV2MOM__Vision__c);
                component.set("v.valueAttr", v2momObj.myV2MOM__Values__c);
                component.set("v.v2momId", v2momObj.Id);
            }else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.");
            }else if (state === "ERROR") {
                console.log('An unknown error occured.');
            }
        });
        
        $A.enqueueAction(action);  
	},
      copytoclip:function(component, event, helper) {        
        component.find('MgrVision').getElement().select();
        console.log(component.find('MgrVision').getElement());
        document.queryCommandSupported('copy');
        document.execCommand('copy');
        helper.toastMessage('Success!', 'Manager vision copied to clipboard.', 'success');
    },
    copyValuestoclip:function(component, event, helper) {        
        component.find('MgrValues').getElement().select();
        console.log(component.find('MgrValues').getElement());
        document.queryCommandSupported('copy');
        document.execCommand('copy');
        helper.toastMessage('Success!', 'Manager vision copied to clipboard.', 'success');
    },
    
    saveV2VJS : function(component, event, helper) {
		var action = component.get("c.saveV2V");
        
        action.setParams({ visionVal : component.get("v.visionAttr"),  
                           valueVal : component.get("v.valueAttr"),
                           v2momIdVal : component.get("v.v2momId")});

        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var v2momObj = a.getReturnValue();
                component.set("v.visionAttr", v2momObj.myV2MOM__Vision__c);
                component.set("v.valueAttr", v2momObj.myV2MOM__Values__c);
                component.set("v.v2momId", v2momObj.Id);
                component.set("v.v2momUserId", v2momObj.CreatedById);
                
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": v2momObj.Id,
                    "isredirect": true
                });
                navEvt.fire();
                
                helper.toastMessage('Success!', 'V2MOM drafted successfully.', 'success');
            }else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.");
            }else if (state === "ERROR") {
                console.log('An unknown error occured.');
            }
        });
        
        $A.enqueueAction(action);  
	},
    
    referMgrVision : function(component, event, helper) {
        var action = component.get("c.referManagerVisionMob");
         action.setParams({"V2MOMrec":component.get('v.myV2mom')});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
               // component.set("v.visionAttr", response.getReturnValue()); 
                if(response.getReturnValue() == "" || response.getReturnValue() == null){
                    helper.toastMessage('Error!', 'Manager V2MOM vision does not exist!', 'error');
                }else{
                    helper.modalHelper(component, 'srModal', 'modalBkdrp', true);
                    component.set("v.MgrVision", response.getReturnValue());
                }
            }else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.");
            }else if (state === "ERROR") {
                console.log('An unknown error occured.');
            }
        });
        $A.enqueueAction(action);
    },
    
    referMgrValue : function(component, event, helper) {
        var action = component.get("c.referManagerValueMob");
         action.setParams({"V2MOMrec":component.get('v.myV2mom')});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
               // component.set("v.valueAttr", response.getReturnValue());
                if(response.getReturnValue() == "" || response.getReturnValue() == null){
                    helper.toastMessage('Error!', 'Manager V2MOM value does not exist!', 'error');
                }else{
                    helper.modalHelper(component, 'ValuesModal', 'modalBkdrp', true);
                    component.set("v.MgrValues", response.getReturnValue());
                }
            }else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.");
            }else if (state === "ERROR") {
                console.log('An unknown error occured.');
            }
        });
        $A.enqueueAction(action);
    },
      closeModal : function(component, event, helper) {
        helper.modalHelper(component, 'srModal', 'modalBkdrp', false);
    },
     closeValuesModal : function(component, event, helper) {
        helper.modalHelper(component, 'ValuesModal', 'modalBkdrp', false);
    },
})
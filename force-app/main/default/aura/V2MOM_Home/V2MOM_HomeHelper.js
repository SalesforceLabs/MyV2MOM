({
	helperdoInit : function(component, event, helper) {
        
        var action = component.get("c.V2MOM_InIt");
        action.setParams({
            v2MOMId : component.get("v.v2momId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var rVal = response.getReturnValue();
                var vMom = rVal.v2momRecord;
                component.set('v.newMnMWrapper', rVal.newMnMsvar);
                component.set("v.uName", rVal.userName);
                component.set("v.currentUserId", rVal.userId);
                component.set("v.myV2mom", vMom);                
                component.set("v.vision", vMom.Vision__c); 
                component.set("v.value", vMom.Values__c);
                component.set("v.v2momId", vMom.Id);
                component.set("v.v2momUserId", vMom.CreatedById);
                component.set("v.allMethods", rVal.allMethods);
                component.set("v.measWrapper", rVal.allMeasures);
                component.set("v.isManager", rVal.isUserManager);
                component.set("v.v2momOptions", rVal.v2momOptions);

                var opts = [];
                var v2momOpts = component.get("v.v2momOptions");
                for(var i=0; i< v2momOpts.length; i++){
                    var optObj = {};
                    optObj.value = v2momOpts[i].Id;
                    optObj.label = 'FY'+v2momOpts[i].FY_Year__c;
                    opts.push(optObj);
                }
                component.set("v.v2momOptionsArr", opts);
                component.set("v.selV2MOM", vMom.Id);
            }else if(state === 'ERROR'){
            var errors = response.getError();
                var errorMsg;
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMsg = errors[0].message;
                    }
                } else {
                    errorMsg = "An Unknown error occured."
                }
            }else{
                console.log(state);
            }
        });
        $A.enqueueAction(action);
        
	},
    toastMessage : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type" : type
            });
            if(toastEvent){
                toastEvent.fire();
            }
        }
    },
    navToRec : function(recId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recId
        });
        navEvt.fire();
    },
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
    }
})
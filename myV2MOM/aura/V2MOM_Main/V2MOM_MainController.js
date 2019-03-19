({
	doInit : function(component, event, helper) {
        var mobDevice = $A.get("$Browser.isPhone");
		var action = component.get("c.fetchV2MOMRec");
        
        action.setParams({v2momId: component.get("v.recordId")});
        action.setCallback(this, function(a) {
            var state = a.getState();
            
            if (state === "SUCCESS") {
                var v2momObjW = a.getReturnValue();
                var v2momObj = v2momObjW.v2momObj;
                component.set("v.v2momUserId", v2momObj.CreatedById);
                component.set("v.v2momObj", v2momObj);
                component.set("v.managerV2MOMId", v2momObjW.managerV2momId);
                component.set("v.v2momOptions", v2momObjW.v2momOptions);
                component.set("v.selV2MOM", v2momObj.Id);
                component.set("v.currentUserV2MOMId", v2momObjW.currentUserV2MOMId);
                component.set("v.lastupdatedDate", v2momObjW.lastupdatedDate);
                
                var compName;
                if(mobDevice){
                    compName = 'c:V2MOM_MobileHome';
                }else{
                    compName = 'c:V2MOM_Home';
                }
                
                $A.createComponent(
                    compName,
                    {
                        "v2momId": v2momObj.Id,
                        "v2momUserId": component.get('v.v2momUserId'),
                        "v2momObj": component.get('v.v2momObj'),
                        "managerV2MOMId": component.get('v.managerV2MOMId'),
                        "v2momOptions": component.get('v.v2momOptions'),
                        "selV2MOM": component.get('v.selV2MOM'),
                        "currentUserV2MOMId": component.get('v.currentUserV2MOMId'),
                        "lastupdatedDate": component.get('v.lastupdatedDate')
                    },
                    function(v2momComp, status, errorMessage){
                        
                        if (status === "SUCCESS") {
                            var body = component.get("v.body");
                            body.push(v2momComp);
                            component.set("v.body", body);
                        }
                        else if (status === "INCOMPLETE") {
                            console.log("No response from server or client is offline.");
                        }
                        else if (status === "ERROR") {
                            console.log('An unknown error occured.');
                        }
                    }
                );
            }else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.");
            }else if (state === "ERROR") {
                console.log('An unknown error occured.');
            }
        });
        
        $A.enqueueAction(action);  
	},
    
    showSpinner : function (component, event, helper) {
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    
    hideSpinner : function (component, event, helper) {
       var spinner = component.find("spinner");
       $A.util.removeClass(spinner, "slds-show");
       $A.util.addClass(spinner, "slds-hide");
    }
})
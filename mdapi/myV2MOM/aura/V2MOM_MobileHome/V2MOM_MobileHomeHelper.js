({
	createDynComponent : function(component, event, compName) {
		$A.createComponent(
            compName,
            {
                "v2momId": component.get('v.v2momId'),
                "v2momUserId": component.get('v.v2momUserId'),
                "currentUserId": component.get('v.currentUserId'),
                "isManager": component.get('v.isManager'),
                "currentUserV2MOMId": component.get('v.currentUserV2MOMId'),
                "myV2mom":component.get('v.v2momObj')
            },
            function(CompCallBack, status, errorMessage){
                
                if (status === "SUCCESS") {
                    if(compName == "c:V2MOMMobileV2"){
                        var mobileV2CmpBody = component.get("v.mobileV2Cmp");
                        mobileV2CmpBody.push(CompCallBack);
                        component.set("v.mobileV2Cmp", mobileV2CmpBody);
                    }else if(compName == "c:V2MOMMobileMOM"){
                        var mobileMOMCmpBody = component.get("v.mobileMOMCmp");
                        mobileMOMCmpBody.push(CompCallBack);
                        component.set("v.mobileMOMCmp", mobileMOMCmpBody);
                    }
                    
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.");
                }
                    else if (status === "ERROR") {
                        console.log('An unknown error occured.');
                    }
            }
        );
	}
})
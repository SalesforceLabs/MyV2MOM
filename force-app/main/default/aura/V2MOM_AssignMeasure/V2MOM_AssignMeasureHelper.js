({
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
    selectedUsersChangeHelper : function(component, event){
        
        var existingMeasureList = component.get('v.existingMeasureList');
        var measureTarList = component.get('v.measureTarList');
        var selectedUsersAttr = component.get("v.selectedUsers");
        var currentMeasureTargetAttr = component.get("v.currentMeasureTarget");
        
        if(selectedUsersAttr != null && selectedUsersAttr != ''){
            
            var selectedUsersArr = selectedUsersAttr.split(";");
            var userListAttr = component.get("v.userList");
            
            var measureTarArr = [];
            for (var i = 0; i < selectedUsersArr.length; i++) { 
                for (var j = 0; j < userListAttr.length; j++) { 
                    if(selectedUsersArr[i] == userListAttr[j].Id){
                        var measureTarObj = {};
                        measureTarObj.userId = userListAttr[j].Id;
                        measureTarObj.userName = userListAttr[j].Name;
                        if(existingMeasureList[i] != undefined){
                            measureTarObj.percentTar = existingMeasureList[i].Percentage__c;
                            measureTarObj.actualTar = currentMeasureTargetAttr * (measureTarObj.percentTar/100);
                            measureTarObj.currVal = existingMeasureList[i].Current_Value__c;
                            measureTarObj.Status = existingMeasureList[i].Status__c;
                        }else if(measureTarList[i] != undefined && measureTarList[i].userId == userListAttr[j].Id){
                            measureTarObj.percentTar = measureTarList[i].percentTar;
                            measureTarObj.actualTar = currentMeasureTargetAttr * (measureTarObj.percentTar/100);
                            measureTarObj.currVal = measureTarList[i].currVal;
                            measureTarObj.Status = measureTarList[i].Status;
                        }else{
                            measureTarObj.percentTar = 0;
                            measureTarObj.actualTar = 0;
                            measureTarObj.currVal = 0;
                            measureTarObj.Status = '';
                        }
                        measureTarArr.push(measureTarObj);
                        
                    }
                }
            }
            
            component.set("v.measureTarList",measureTarArr);
        }else{
            component.set("v.measureTarList",[]);
        }
        
    }
})
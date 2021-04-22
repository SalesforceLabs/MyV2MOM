({
    doInit : function(component, event, helper) {
        var action = component.get('c.getOrgUsers');
        action.setParams({
            'typeCode' : 'TeamMembers'
        });
        action.setCallback(this, function(res){
            var state = res.getState();
            if(state === 'SUCCESS'){
                var rVal = res.getReturnValue();
                component.set('v.userList', rVal);
                component.set('v.numberOfReportees', rVal.length);
            }else if(state === 'ERROR'){
                console.log('An unknown error occured.');
            }else{
                console.log(state);
            }
        });
        $A.enqueueAction(action);
        
        
    },
    closeModal : function(component, event, helper) {
        helper.modalHelper(component, 'srModal', 'modalBkdrp', false);
    },
    adoptMeasure : function(component, event, helper) {
        var params = event.getParam('arguments');
        var mId = params.measureId;
        var action = component.get('c.adoptMeasureHelper');
        action.setParams({
            'MeasureId': mId
        });
        action.setCallback(this, function(res){
            var state = res.getState();
            if(state === 'SUCCESS'){
                var rVal = res.getReturnValue();
                helper.toastMessage('Success!', 'Measure added to your V2MOM.', 'success');
            }else if(state === 'ERROR'){
                console.log('An unknown error occured.');
            }else{
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    },
    refreshAssignments : function(component, event, helper) {
        var params = event.getParam('arguments');
        component.set('v.currentMeasureName', params.measureName);
        component.set('v.currentMeasureId', params.measureId.Id);
        component.set('v.currentMeasureTarget', params.measureId.Target_Value__c);
        component.set('v.measureTotalCurrVal', params.measureId.Assigned_Current_Value__c);
        component.set('v.measureTrackProgress', params.measureId.Track_Progress_By__c);
        
        var action = component.get('c.getMeasureAssignees');
        action.setParams({
            'MeasureId': params.measureId.Id
        });
        action.setCallback(this, function(res){
            var state = res.getState();
            if(state === 'SUCCESS'){
                var rVal = res.getReturnValue();
                helper.modalHelper(component, 'srModal', 'modalBkdrp', true);
                var rvalLen = rVal.length;
                if(rvalLen > 0){
                    var userLstStr = [];
                    var meaTeamStr = '';
                    for(var i=0; i<rvalLen; i++){
                        userLstStr.push(rVal[i].Member__c);
                        meaTeamStr += rVal[i].Member__c +';';
                    }
                    component.set('v.existingMeasureList', rVal);
                    userLstStr = userLstStr.join(';');
                    component.set('v.previousMembers',userLstStr);
                    component.find('teamMembers').externalValueChange(userLstStr);
                    
                    meaTeamStr = meaTeamStr.substring(0, meaTeamStr.length - 1);
                    
                    helper.selectedUsersChangeHelper(component, event);
                    
                }else{
                    component.set('v.existingMeasureList', []);
                    component.set('v.previousMembers','');
                    component.find('teamMembers').externalValueChange('');
                }                
            }else if(state === 'ERROR'){
                console.log('An unknown error occured.');
            }else{
                console.log(state);
            }
        });
        $A.enqueueAction(action);
        
    },
    saveAssignments : function(component, event, helper){
        var measureTarList = component.get('v.measureTarList');
        var currentMeasureTarget = component.get('v.currentMeasureTarget');
        var isTotPerValid = 0;
        var isPerZero = false;
        
        var measureTarListFinal = [];
        for (var i = 0; i < measureTarList.length; i++) { 
            var measureTarObj = {};
            measureTarObj.userId = measureTarList[i].userId;
            measureTarObj.userName = measureTarList[i].userName;
            measureTarObj.percentTar = measureTarList[i].percentTar;
            measureTarObj.actualTar = currentMeasureTarget * (measureTarObj.percentTar/100);
            measureTarObj.currVal = measureTarList[i].currVal;
            measureTarObj.Status = measureTarList[i].Status;
            measureTarListFinal.push(measureTarObj);
            isTotPerValid += measureTarObj.percentTar;
            if(measureTarObj.percentTar == 0 && !isPerZero){
                isPerZero = true;
            }
        }
        component.set('v.measureTarList', measureTarListFinal);
        
        if(isPerZero && component.get('v.measureTrackProgress') == 'Numbers Completed'){
            helper.toastMessage('Error!', 'One of the Assigned percentages is 0.', 'error');            
        }else if(isTotPerValid > 100 && component.get('v.measureTrackProgress') == 'Numbers Completed'){
            helper.toastMessage('Error!', 'Total percentage split cannot exceed 100.', 'error'); 
        }else{
            var action = component.get('c.setMeasureAssignees');
            var currentTeam = component.get('v.selectedUsers');
            var previousTeam = component.get('v.previousMembers');
            action.setParams({
                'MeasureId': component.get('v.currentMeasureId'),
                'currentUserIds' : currentTeam,
                'previousUserIds' : previousTeam,
                'measureTarStr' : JSON.stringify(component.get('v.measureTarList'))
            });
            action.setCallback(this, function(res){
                var state = res.getState();
                if(state === 'SUCCESS'){
                    var rVal = res.getReturnValue();
                    component.set('v.previousMembers', currentTeam);
                    helper.toastMessage('Success!', 'Measure assignment was successful.', 'success');
                    helper.modalHelper(component, 'srModal', 'modalBkdrp', false);
                }else if(state === 'ERROR'){
                    console.log('An unknown error occured.');
                }else{
                    console.log(state);
                }
            });
            $A.enqueueAction(action);
        }
    },
    selectedUsersChange : function(component, event, helper){
        
        helper.selectedUsersChangeHelper(component, event);
        
    }
})
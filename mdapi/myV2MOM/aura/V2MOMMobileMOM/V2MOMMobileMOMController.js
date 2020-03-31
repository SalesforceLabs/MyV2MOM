({
    doInit : function(component, event, helper) {
        
        var currentUserId = component.get('v.currentUserId');
        var v2momUserId = component.get('v.v2momUserId');
        
        var statusPicklistaction = component.get('c.getMeasureStatusPicklistValues');
        statusPicklistaction.setCallback(this, function(res){
            var state = res.getState();
            if(state === 'SUCCESS'){
                var rVal = res.getReturnValue();
                component.set('v.statusPicklistValues', rVal);
            }else if(state === 'ERROR'){
                console.log('An unknown error occured.');
            }else{
                console.log(state);
            }
        });
        $A.enqueueAction(statusPicklistaction);
     	var v2momId = component.get('v.v2momId');
        var action = component.get('c.getMnMNew');
        action.setParams({
            "v2MOMId" : v2momId
        });
        action.setCallback(this, function(res){
            var state = res.getState();
            if(state === 'SUCCESS'){
            var rVal = res.getReturnValue();
                //console.clear();
                component.set('v.myMnM', rVal.myMnM);
                component.set('v.assignedMnM', rVal.assignedMnM);
                component.set('v.adoptedMnM', rVal.adoptedMnM);
            }else if(state === 'ERROR'){
            	console.log('An unknown error occured.');
            }else{
                console.log(state);
            }
        });
        $A.enqueueAction(action);
	},
    measureHandleSelect : function(component, event, helper){
        var selectedMenuItemValue = event.getParam("action");
        var measure = event.getParam("measure");
        var isMeasureTeam = event.getParam('isMeasureTeam');
        var currentUserId = component.get('v.currentUserId');
        var v2momUserId = component.get('v.v2momUserId');
        if(selectedMenuItemValue == 'Show Comments'){
            component.set('v.isSelectedMeasureTeam', isMeasureTeam);
            component.set('v.selectedMeasure', measure);            
        }else{
            var recId = measure.recId;
            var recName = measure.recName;
            if(selectedMenuItemValue == "View Obstacles and Comments"){
                component.find('showObsAndComments').showObstaclesComments(recName, recId.Id, currentUserId, v2momUserId, isMeasureTeam);
            }else if(selectedMenuItemValue == "Assign this measure"){
                component.find('assignMeasureComponent').refreshAssignments(recName, recId);
            }else if(selectedMenuItemValue == "Copy to my V2MOM"){
                component.find('adoptMeasureComponent').adoptMeasure(recId);
            }
        }
    },
})
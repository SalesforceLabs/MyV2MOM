({
    doInit : function(component, event, helper) {
        
    },
    mMapchange : function(component, event, helper) {
        
    },
    measureHandleSelect : function(component, event, helper) {
        helper.communicateActions(component, event, false);
    },
    showComments : function(component, event, helper) {
        helper.communicateActions(component, event, true);
    },
    toggleViewAllQuarters : function(component, event, helper) {
        component.set('v.showQuarter', !component.get('v.showQuarter'));
    },
    handleSearch : function(component, event, helper) {
        var melements = component.find('measureId');
        var srchString = event.getParam('value').toLowerCase();
        var CurrentMeasures = component.get('v.CurrentMeasures');
        var isMeasureTeam = component.get('v.isMeasureTeam');
        var toShow = [];
        if(!$A.util.isUndefinedOrNull(srchString)){
            for(var i=0; i<CurrentMeasures.length; i++){
                var mName = !isMeasureTeam ? CurrentMeasures[i].Name : CurrentMeasures[i].myV2MOM__Measure__r.Name;
                if(mName.toLowerCase().includes(srchString)){
                    toShow.push(i);
                }
            }
            if(toShow.length == 0){
                    $A.util.addClass(component.find('methodId'),'slds-hide');
                }else{
                    $A.util.removeClass(component.find('methodId'),'slds-hide');
                }
            if(!$A.util.isUndefinedOrNull(melements)){
                for(var i=0; i<melements.length; i++){
                    if(toShow.indexOf(i) != -1){
                        $A.util.removeClass(melements[i],'slds-hide');
                    }else{
                        $A.util.addClass(melements[i],'slds-hide');
                    }
                }
            }
        }
    }
})
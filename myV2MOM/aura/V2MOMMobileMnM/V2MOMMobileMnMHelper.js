({
	communicateActions : function(component, event, forComments) {
        var isMeasureTeam = component.get('v.isMeasureTeam');
        var compEvent = component.getEvent("V2MOMMobileEvt");
        var selectedMenuItemValue;
        var measure;
        if(forComments){
            selectedMenuItemValue = 'Show Comments';
            var idx = event.currentTarget.dataset.measureid;
            measure = component.get('v.CurrentMeasures')[idx];
        }else{
            selectedMenuItemValue = event.getParam("value");
            var recId = event.getSource().get('v.value');
            var recName = event.getSource().get('v.name');
            if(isMeasureTeam){
                recId = recId.myV2MOM__Measure__r;
            }
            measure = {"recId": recId, "recName": recName};
        }
        compEvent.setParams({
            "action" : selectedMenuItemValue,
            "measure" : measure,
            "isMeasureTeam" : component.get('v.isMeasureTeam')
        });
        compEvent.fire();
	},
    showHideMnMs : function(component, toShow) {
        
    }
})
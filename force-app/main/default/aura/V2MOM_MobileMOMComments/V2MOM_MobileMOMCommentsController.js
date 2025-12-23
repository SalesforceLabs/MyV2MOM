({
	refreshComments : function(component, event, helper) {
		var measure = component.get('v.measure');
		var isMeasureTeam = component.get('v.isMeasureTeam');
        if(measure){
            if(isMeasureTeam){
                component.find('commentComponent').showPopoverModal(measure.Measure__r.Name,measure.Id);
            }else{
                component.find('commentComponent').showPopoverModal(measure.Name,measure.Id);
            }
        }
	},
    showHideComments : function(component, event, helper) {
       	var evtParams = event.getParams();
        if(evtParams.value === true){
            component.set('v.measure', null);
            component.set('v.showComments', false);
        }
    }
})
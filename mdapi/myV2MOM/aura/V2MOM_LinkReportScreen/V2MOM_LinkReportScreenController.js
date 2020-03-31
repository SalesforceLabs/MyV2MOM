({
	doInit : function(component, event, helper) {
        component.set("v.reportSelected",false);
		var action = component.get("c.getReportList");
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            var rec = response.getReturnValue();
            console.log('return after save: '+rec);
            component.set("v.reportList",rec);
            
        });
        $A.enqueueAction(action); 
	},
    onSelectChange : function(component, event, helper) {
        console.log('inside onSelectChange ');
        component.set("v.reportSelected",true);
        var selected = component.find("selectReport").get("v.value");
        console.log('selected:'+selected);
        
        var action = component.get("c.getAggregates");
        action.setParams({ "rId" : selected });
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            var rec = response.getReturnValue();
            console.log('return after save: '+rec);
            component.set("v.aggregateList",rec);
            
        });
        $A.enqueueAction(action); 
    },
    onAggregateChange : function(component, event, helper) {
        var selectedAggregate = component.find("selectAggregate").get("v.value");
        console.log('selectedAggregate:'+selectedAggregate);
        var selectedReport = component.find("selectReport").get("v.value");
        console.log('selectedReport:'+selectedReport);
        
        var action = component.get("c.getAggregateValue");
        action.setParams({ "rId" : selectedReport , "aggName" : selectedAggregate });
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            var rec = response.getReturnValue();
            console.log('return after save: '+rec);
            component.set("v.aggValue",rec);
            
        });
        $A.enqueueAction(action); 
    }
})
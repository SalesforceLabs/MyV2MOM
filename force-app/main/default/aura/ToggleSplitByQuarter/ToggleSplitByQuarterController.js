({
    doInit : function(component, event, helper) {
        var action = component.get('c.getCurrentFiscalQuarter');
        action.setCallback(this, function(res){
            var state = res.getState();
            if(state === 'SUCCESS'){
                var rVal = res.getReturnValue();
                component.set('v.currentQuarter', rVal);
            }else if(state === 'ERROR'){
                console.log('An unknown error occured.');
            }else{
                console.log(state);
            }
        });
        $A.enqueueAction(action);
        helper.calcSumOfQuarters(component);
    },
    resetForm : function(component, event, helper){
        var notifiElem = component.find('notificationMessage');
        $A.util.addClass(notifiElem, 'slds-hide');
        for(var i=1;i<=4;i++){
            component.set('v.Q'+i, 0);
            component.set('v.TargetQ'+i, null);
        }
    },
    testvalueCha : function(component, event, helper) {
        var inptElems = component.find('splitInput')[3];
        alert(inptElems.get('v.value'));
        inptElems.set('v.value', null);
    },
    splitValue : function(component, event, helper) {
        helper.calculateCurrentSplit(component,event,helper);
        helper.splitByQuarter(component,event,helper);
    },
    handleTargetValueChange : function(component, event, helper) {
        helper.validateTargetSplit(component, event, helper);
    },
    handleCurrentValueChange : function(component, event, helper) {
        
    },
    handleQValChange : function(component, event, helper) {
        var quater = event.getSource().get('v.label');
        helper.calcSumOfQuarters(component);
    }
})
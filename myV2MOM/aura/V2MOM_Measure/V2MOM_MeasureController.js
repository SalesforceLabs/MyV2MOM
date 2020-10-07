({
    doInit : function(component, event, helper) {
        
    },
     checkVal : function(component, event, helper) {
         var flag=false;
         var validityC = component.get("v.measure.Current_Value__c");
         var validityT = component.get("v.measure.Target_Value__c");  
         if((validityC<0 || validityT<0)){
             flag=true;
         }
         
         component.set("v.isNegative",flag);
          console.log('is not valid'+component.get('v.isNegative'));
   },
    CompletionQuarterChanged : function(component, event, helper){
        var currentSelectedQuarter = event.getSource().get('v.value');        
        if(currentSelectedQuarter != '' && !$A.util.isUndefinedOrNull(currentSelectedQuarter)){
            var action = component.get('c.getQuarterEndDate');
            action.setParams({
                'currentQuarter': parseInt(currentSelectedQuarter.substr(1))
            });
            action.setCallback(this, function(res){
                var state = res.getState();
                if(state === 'SUCCESS'){
                    var rVal = res.getReturnValue();
                    component.set('v.measure.Completion_By_Date__c', rVal);
                }else if(state === 'ERROR'){
                    console.log('An unknown error occured.');
                }else{
                    console.log(state);
                }
            });
            $A.enqueueAction(action);
        }else{
            component.set('v.measure.Completion_By_Date__c', null);
        }
        
    },
    openMeasureModal: function(component,event,helper) {
        helper.doInitHandler(component,event,helper);
        helper.modalHelper(component, 'srModal', 'modalBkdrp', true);
        helper.resetForm(component);
    },
    closeMeasureModal: function(component,event,helper) {
        helper.modalHelper(component, 'srModal', 'modalBkdrp', false);
        helper.resetForm(component);
    },
    createMeasureMethod: function(component,event,helper){
        if(component.get("v.measure.name") != ""){
            var m = component.get("v.measure");
            m.Method__c = component.get("v.methodId");
            var action = component.get("c.createMeasure");
            action.setParams({
                'measure': m
            });
            action.setCallback(this, function(res){
                var state = res.getState();
                if(state === 'SUCCESS'){
                    var rVal = res.getReturnValue();
                    helper.modalHelper(component, 'srModal', 'modalBkdrp', false);
                    var valueChangeEvent = component.getEvent("updateView");
                    valueChangeEvent.fire();
                    helper.resetForm(component);
                    helper.toastMessage('Success!', 'Measure saved successfully.', 'success');
                }else if(state === 'ERROR'){
                    console.log('An unknown error occured.');
                }else{
                    console.log(state);
                }
            });
            $A.enqueueAction(action);
            component.set("v.editView",false);
        }else{
            helper.toastMessage('Warning!', 'Please provide a method name', 'warning');
        }
    },
    EditMeasure : function(component,event,helper){
        helper.doInitHandler(component,event,helper);
        component.set("v.measureHeader",'Edit Measure');
        var params = event.getParam('arguments');
        component.set('v.measure', params.measure_edit);
        helper.modalHelper(component, 'srModal', 'modalBkdrp', true);
    },
    onDateValueChange : function(component,event,helper){
        var currentDate = new Date();
        var year = currentDate.getFullYear();
        var month = currentDate.getMonth()+1;
        if (month < 10) month = "0" + month;
        var day = currentDate.getDate();
        if (day < 10) day = "0" + day;
        currentDate = year + "-" + month + "-" + day;
        if(component.get("v.measure.Completion_By_Date__c") < currentDate){
            component.set("v.completionDateError","Please select future date");
            component.set("v.measure.Completion_By_Date__c","");
        }else{
            component.set("v.completionDateError","");
        }
        
    }
    
})
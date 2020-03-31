({
    resetForm : function(component){
        console.log("reset measure form");
        component.set("v.selectedStatus", null);
        component.set("v.progressTypeSelected", "Numbers Completed");
        component.set("v.prioritySelected", "Medium");
        component.set("v.selectedQuarter","");
        component.set("v.trackStatusByNumber",true);
        component.set("v.measure",{'sobjectType': 'Measure__c',
                                                                       'Name': '',
                                                                       'Completion_By_Date__c' : '',
                                                                       'Track_Progress_By__c': 'Numbers Completed',
                                                                       'Split_By_Quarter__c' : false,
                                                                       'Status__c' : 'Not Started',
                                                                       'Target_Value__c':0,
                                                                       'Current_Value__c':0,
                                                                       'Q1__c' : 0,
                                                                       'Q2__c' : 0,
                                                                       'Q3__c' : 0,
                                                                       'Q4__c' : 0,
                                                                       'Q1_Target__c' : 0,
                                                                       'Q2_Target__c' : 0,
                                                                       'Q3_Target__c' : 0,
                                                                       'Q4_Target__c' : 0,
                                                                       'Obstacles__c' : '',
                                                                       'Comments__c' : '',
                                                                       'Priority__c' : 'Medium',
                                                                       'Measure_Team_Member_Count__c' : 0,
                                                                       'Assigned_Current_Value__c' : 0});
    },
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
    
    doInitHandler: function(component, event, helper) {
        var populateProgressPicklists = component.get("c.getProgressTypes");
        var ProgressOptions = [];     
        
        populateProgressPicklists.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                ProgressOptions.push({label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            component.set("v.progressTypes", ProgressOptions);
        });
        $A.enqueueAction(populateProgressPicklists);
        
        var populatePriorityPicklists = component.get("c.getPriorityTypes");
        var priorityOptions = [];     
        
        populatePriorityPicklists.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                priorityOptions.push({label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            component.set("v.priorityTypes", priorityOptions);
            component.set("v.prioritySelected", "Medium");
        });
        
        $A.enqueueAction(populatePriorityPicklists);
        
        var populateStatusPicklists = component.get("c.getStatusTypes");
        var statusOptions = [];   
        populateStatusPicklists.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                statusOptions.push(a.getReturnValue()[i]);
            }
            component.set("v.statusTypes", statusOptions);
            console.log(component.get("v.statusTypes"));
        });
        $A.enqueueAction(populateStatusPicklists);
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
    }
})
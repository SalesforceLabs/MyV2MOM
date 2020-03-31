({
    doInit: function(component, event, helper){
        helper.helperdoInit(component, event, helper);
    },
    setCurrentTab : function(component,event,helper) {
        return false;
        var cTab = event.getSource().get('v.selectedTabId');
        component.set('v.selectedMnMTab', cTab);
    },
    reorderMethods : function(component,event,helper) {
        component.find('MethodReorderComp').reloadForm();
    },
    openMeasureModal: function(component,event,helper) {
        component.set("v.selectedMethodId", event.getSource().get("v.value"));
        var cmpTarget = component.find('measureCompId');
        cmpTarget.measureModal();
    },
    toggleVisionSection: function(component,event,helper){
        var cmpTarget = component.find('visionSectionId');
        $A.util.toggleClass(cmpTarget, 'slds-is-open'); 
    },
    toggleValueSection: function(component,event,helper){
        var cmpTarget = component.find('valueSectionId');
        $A.util.toggleClass(cmpTarget, 'slds-is-open'); 
    },
    
    refresh : function(component, event, helper) {
        helper.helperdoInit(component, event, helper);
    },
    closeModal : function(component, event, helper) {
        helper.modalHelper(component, 'srModal', 'modalBkdrp', false);
    },
     closeValuesModal : function(component, event, helper) {
        helper.modalHelper(component, 'ValuesModal', 'modalBkdrp', false);
    },
    referMgrVision : function(component, event, helper) {
        var action = component.get("c.referManagerVision");
        action.setParams({"V2MOMrec":component.get('v.myV2mom')});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.disableSaveVisionAndValueButton", true);
                if(response.getReturnValue() == "" || response.getReturnValue() == null){
                    helper.toastMessage('Error!', 'Manager V2MOM vision does not exist!', 'error');
                }else{
                    helper.modalHelper(component, 'srModal', 'modalBkdrp', true);
                    component.set("v.MgrVision", response.getReturnValue());
                    //helper.toastMessage('Success!', 'Manager vision copied successfully.', 'success');
                }
            }else if(state === "ERROR"){                
            }
        });
        $A.enqueueAction(action);
    },
    copytoclip:function(component, event, helper) {        
        component.find('MgrVision').getElement().select();
        console.log(component.find('MgrVision').getElement());
        document.queryCommandSupported('copy');
        document.execCommand('copy');
        helper.toastMessage('Success!', 'Manager vision copied to clipboard.', 'success');
    },
    copyValuestoclip:function(component, event, helper) {        
        component.find('MgrValues').getElement().select();
        console.log(component.find('MgrValues').getElement());
        document.queryCommandSupported('copy');
        document.execCommand('copy');
        helper.toastMessage('Success!', 'Manager vision copied to clipboard.', 'success');
    },
    
    referMgrValue : function(component, event, helper) {
        var action = component.get("c.referManagerValue");
          action.setParams({"V2MOMrec":component.get('v.myV2mom')});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.disableSaveVisionAndValueButton", true);
                if(response.getReturnValue() == "" || response.getReturnValue() == null){
                    helper.toastMessage('Error!', 'Manager V2MOM value does not exist!', 'error');
                }else{
                    helper.modalHelper(component, 'ValuesModal', 'modalBkdrp', true);
                    component.set("v.MgrValues", response.getReturnValue());
                }
            }else if(state === "ERROR"){
                
            }
        });
        $A.enqueueAction(action);
    },
    /*
    showQuarterValues : function(component, event, helper){
        var measures = component.get("v.measWrapper");
        for(var i=0; i< measures.length; i++){
            if((measures[i].ms.Id) == event.getSource().get("v.value")){
                measures[i].showQuarter = true;
            }
        }
        component.set("v.measWrapper",measures);
    },
    hideQuarterValues : function(component, event, helper){
        var measures = component.get("v.measWrapper");
        for(var i=0; i< measures.length; i++){
            if((measures[i].ms.Id) == event.getSource().get("v.value")){
                measures[i].showQuarter = false;
            }
        }
        component.set("v.measWrapper",measures);
    },*/
    measureHandleSelect : function(component, event, helper){
        var selectedMenuItemValue = event.getParam("value");
        var recId = event.getSource().get('v.value');
        var recName = event.getSource().get('v.name');
        if(selectedMenuItemValue == "View Obstacles and Comments"){
            component.find('showObsAndComments').showObstaclesComments(recName, recId.Id, component.get("v.currentUserId"),component.get("v.v2momUserId"));
        }else if(selectedMenuItemValue == "Assign this measure"){
            component.find('assignMeasureComponent').refreshAssignments(recName, recId);
        }else if(selectedMenuItemValue == "Copy to my V2MOM"){
            component.find('adoptMeasureComponent').adoptMeasure(recId);
        }
    },
    showMeasureChatter : function(component, event, helper){
        var selectedMenuItemValue = event.getParam("value");
        var recId = event.getSource().get('v.value');
        var recName = event.getSource().get('v.name');
        component.find('showMeasureChatId').showPopoverModal(recName, recId);
    },
    
    saveV2VJS : function(component, event, helper) {
        if(component.get("v.vision") != '' && component.get("v.value") != '' && 
          	component.get("v.vision") != undefined && component.get("v.value") != undefined){
            var action = component.get("c.saveV2V");
            
            action.setParams({ visionVal : component.get("v.vision"),  
                              valueVal : component.get("v.value"),
                              v2momIdVal : component.get("v.v2momId")});
            action.setCallback(this, function(a) {
                var state = a.getState();
                if (state === "SUCCESS") {
                    var v2momObj = a.getReturnValue();
                    component.set("v.vision", v2momObj.Vision__c);
                    component.set("v.value", v2momObj.Values__c);
                    component.set("v.v2momId", v2momObj.Id);
                    component.set("v.disableSaveVisionAndValueButton", true);
                    component.set("v.disablePublishButton", false);
                    helper.toastMessage('Success!', 'Your Vision & Values were saved successfully!', 'success');
                    helper.helperdoInit(component, event, helper);
                    component.set("v.editVV", false);
                }else if (state === "INCOMPLETE") {
                    
                }else if (state === "ERROR") {
                    
                }
            });
            $A.enqueueAction(action);
        }else{
            helper.toastMessage('Error!', 'Please enter both vision and values.', 'error');
        }        
        
    },
    editV2VJS : function(component, event, helper) {
        component.set("v.editVV", true);
    },
    onChangeVisionOrValue : function(component, event, helper) {
        var value = component.get("v.value");
        var vision = component.get("v.vision");
        var visionOld = component.get("v.myV2mom.Vision__c");
        var valueOld = component.get("v.myV2mom.Values__c");
        if(value && vision){
            if(value.length <=0 || vision.length <=0){
                component.set("v.disableSaveVisionAndValueButton", true);
                component.set("v.disablePublishButton", true);
            }else if(component.get("v.v2momId") != ''){
                if(valueOld == value && visionOld == vision){
                    component.set("v.disableSaveVisionAndValueButton", true);
                    component.set("v.disablePublishButton", false);
                }else{
                    component.set("v.disableSaveVisionAndValueButton", false);
                    component.set("v.disablePublishButton", true);
                }
            }else{
                component.set("v.disablePublishButton", true);
                component.set("v.disableSaveVisionAndValueButton", false);
            }
        }
        
        
    },
    editMeasureAction : function(component, event, helper) {
        var selectedMeasureValue = event.getSource().get("v.value");
        component.find("MeasureCompId").EditMeasure(selectedMeasureValue);
    },
    
    publishMyV2MOM : function(component, event, helper) {
        var action = component.get("c.publishV2MOM");
        action.setParams({
            v2MOMId : component.get("v.v2momId") 
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var v2momObj = a.getReturnValue();
                helper.toastMessage('Success!', 'V2MOM Published successfully.', 'success');
                component.set("v.myV2mom.Status__c", v2momObj.Status__c);
                component.set("v.myV2mom.Published_Date__c", v2momObj.Published_Date__c);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    handleDeleteMeasure: function(component, event, helper) {
        var selectedMeasureId = event.getSource().get("v.value");
        var modalBody;
        var modalFooter;
        $A.createComponents([
            ["c:DeleteMeasureDialogue",{mName : selectedMeasureId.Name, objType : 'measure'}],
            ["c:DeleteMeasureDialogueFooter",{mId : selectedMeasureId.Id}]
        ],function(components, status){
            if (status === "SUCCESS") {
                modalBody = components[0];
                modalFooter = components[1];
                component.find('overlayLib').showCustomModal({
                    header: "DELETE MEASURE",
                    body: modalBody, 
                    footer: modalFooter,
                    showCloseButton: true,
                    cssClass: "my-modal,my-custom-class,my-other-class",
                    closeCallback: function() {
                        //alert('You closed the alert!');
                        helper.helperdoInit(component, event, helper);
                    }
                })
            }
        });
    },
    
    handleDeleteMethod: function(component, event, helper) {
        var selectedMethod = event.getSource().get("v.value");
        var modalBody;
        var modalFooter;
        $A.createComponents([
            ["c:DeleteMeasureDialogue",{mName : selectedMethod.Name, objType : 'method'}],
            ["c:DeleteMeasureDialogueFooter",{mId : selectedMethod.Id}]
        ],function(components, status){
            if (status === "SUCCESS") {
                modalBody = components[0];
                modalFooter = components[1];
                component.find('overlayLib').showCustomModal({
                    header: "DELETE METHOD",
                    body: modalBody, 
                    footer: modalFooter,
                    showCloseButton: true,
                    cssClass: "my-modal,my-custom-class,my-other-class,slds-modal__header",
                    closeCallback: function() {
                        helper.helperdoInit(component, event, helper);
                    }
                })
            }
        });
    },
    
    handleEditMethod: function(component, event, helper) {
        var selectedMethod = event.getSource().get("v.value");
        component.set("v.editMethod", selectedMethod);
    },
    handleCancelEditMethod: function(component, event, helper) {
        component.set("v.editMethod", null);
    },
    addMethod: function(component, event, helper) {
        var selectedMethod = event.getSource().get("v.value");
        var isReadOnly = true;
        if(component.get("v.v2momUserId") == component.get("v.currentUserId")){
            isReadOnly = false;
        }
        component.find('MethodCompId').showMethodModal(selectedMethod, component.get("v.v2momId"), isReadOnly);
    },
    NavigateToV2MOM : function(component, event, helper) {
        var recId = event.getSource().get('v.value');
        helper.navToRec(recId);
    },
    viewAssignedMeasureObstaclesAndComments : function(component, event, helper) {
        var rec = event.getSource().get('v.value');
        component.find('showObsAndComments').showObstaclesComments(rec.Measure__r.Name, rec.Measure__r.Id, component.get("v.currentUserId"),component.get("v.v2momUserId"),true);
    },
    editAssignedMeasure : function(component, event, helper) {
        var rec = event.getSource().get('v.value');
        component.find('editAssignedMeasure').editMethod(rec);
    },
    handleAssignedMeasureUpdate : function(component, event, helper) {
        var action = component.get('c.updateAssignedMeasure');
        action.setParams({
            'mtRecord': event.getParam("record")
        });
        action.setCallback(this, function(res){
            var state = res.getState();
            if(state === 'SUCCESS'){
                var rVal = res.getReturnValue();
                helper.helperdoInit(component, event, helper);
            }else if(state === 'ERROR'){
                var errors = res.getError();
                var errorMsg;
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMsg = errors[0].message;
                    }
                } else {
                    errorMsg = "An Unknown error occured."
                }
            }else{
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    },
    selV2MOMChange: function (component, event) {
        var selV2momId = event.getParam('v.value');
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.selV2MOM")
        });
        navEvt.fire();
    },
    handleAccordion : function (component, event) {
        var accordion = event.currentTarget.dataset.controls;
        $A.util.toggleClass(component.find(accordion), 'slds-is-open');
    }
})
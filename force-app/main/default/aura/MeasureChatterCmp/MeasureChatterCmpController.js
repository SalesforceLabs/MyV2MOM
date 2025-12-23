({
    doInit : function(component, event, helper) {
        helper.measureFeedHelper(component);
        //helper.modalHelper(component, 'srModal', 'modalBkdrp', true);
    },
    postToMeasure : function(component, event, helper){
        helper.postToMeasureHelper(component);
    },
    showHideButton : function(component, event, helper) {
        helper.showHideButtonHelper(component);
    },
    handleClick : function(component, event, helper) {
        var fId = event.getSource().get('v.name');
        component.set("v.editFeedId",fId);
    },
    updateMeasure :  function(component, event, helper) {
        helper.updateMeasureHelper(component,event);
        
    },
    updateCancel :  function(component, event, helper) {
        component.set("v.editFeedId",'');
    },
    hidePopoverModal: function(component,event,helper) {
        var mdl = component.find('popoverId').getElement();
        $A.util.addClass(mdl, 'hidePopover');
        component.set('v.popoverHidden', true);
    },
    showPopoverModal: function(component,event,helper) {
        var params = event.getParam('arguments');
        component.set('v.recordId', params.measureId);
        component.set('v.currentMeasureName', params.measureName);
        helper.measureFeedHelper(component);
        var mdl = component.find('popoverId').getElement();
        $A.util.removeClass(mdl, 'hidePopover');
    }
})
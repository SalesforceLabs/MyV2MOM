({
    scriptsLoaded : function(component, event, helper) {
        var from = component.find('methodList');
        var drake = dragula([from.getElement()],{direction: 'vertical'});
        drake.on('drop', $A.getCallback(function(el, target, source, sibling) {
            var methodsTobeUpdated = [];
            var methodLis = el.parentNode.children;
            for(var i=0;i<methodLis.length;i++){
                var method = {};
                var liDataset = methodLis[i].dataset;
                method.sObjectType = 'myV2MOM__Method__c';
                method.Id = liDataset.recid;
                method.myV2MOM__Order__c = i;
                method.Name = liDataset.recname;
                methodsTobeUpdated.push(method);
            }
            component.set('v.methodsTobeUpdated', methodsTobeUpdated);
        }));
    },
    reloadForm : function(component, event, helper) {
        helper.modalHelper(component, 'srModal', 'modalBkdrp', true);
    },
	openModal : function(component, event, helper) {
        helper.modalHelper(component, 'srModal', 'modalBkdrp', true);
    },
    closeModal : function(component, event, helper) {
        helper.modalHelper(component, 'srModal', 'modalBkdrp', false);
    },
    handleSave : function(component, event, helper) {
        helper.updateMethodsOrder(component, event, helper);
    }
})
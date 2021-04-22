({	
    validateTargetSplit : function(component,event,helper) {
        var targetValue = component.get('v.targetValue');
        var totalTargetSplit = 0;
        for(var i=1; i<5; i++){
            totalTargetSplit += parseFloat(component.get('v.TargetQ'+i));
        }
        var notifiElem = component.find('errNotificationMessage');
        if(totalTargetSplit < targetValue){
            $A.util.removeClass(notifiElem, 'slds-hide');
        }else{
            $A.util.addClass(notifiElem, 'slds-hide');
        }
    },
    splitByQuarter : function(component,event,helper) {
        var doSplit = component.get('v.isSplit');
        var currentQuarter = component.get('v.currentQuarter');
        var currentValue = component.get('v.currentValue');
        var targetValue = component.get('v.targetValue');
        var completionDate = component.get('v.completionDate');
        var div = 5-currentQuarter;
        var splitValue;
        
        var totalSplitValue = 0;
        if(doSplit){// && !isPublished
            splitValue = targetValue/4; 
            for(var i=1; i<5; i++){
                totalSplitValue += parseFloat(splitValue.toFixed(2));
                component.set('v.TargetQ'+i, parseFloat(splitValue.toFixed(2)));
            }
            if(totalSplitValue < targetValue){
                var currentQuarterValue = component.get('v.TargetQ'+currentQuarter);
                component.set('v.TargetQ'+currentQuarter, parseFloat(((targetValue - totalSplitValue) + currentQuarterValue).toFixed(2)));
            }else if(totalSplitValue > targetValue){
                var currentQuarterValue = component.get('v.TargetQ'+currentQuarter);
                component.set('v.TargetQ'+currentQuarter, parseFloat((currentQuarterValue - (totalSplitValue - targetValue)).toFixed(2)));
            }
        }  
    },
    calculateCurrentSplit : function(component,event,helper) {
        var doSplit = component.get('v.isSplit');
        var currentQuarter = component.get('v.currentQuarter');
        var currentValue = component.get('v.currentValue');
        var currentValSplit;
        
        var totalSplitCurrentVal = 0;
        if(doSplit){// && !isPublished
            if(currentValue > 0){
                currentValSplit = currentValue/currentQuarter;
                for(var i=1; i<=currentQuarter; i++){
                    totalSplitCurrentVal += parseFloat(currentValSplit.toFixed(2));
                    component.set('v.Q'+i, parseFloat(currentValSplit.toFixed(2)));
                }
                if(totalSplitCurrentVal < currentValue){
                    var currentQuarterValue = component.get('v.Q'+currentQuarter);
                    component.set('v.Q'+currentQuarter, parseFloat(((currentValue - totalSplitCurrentVal) + currentQuarterValue).toFixed(2)));
                }else if(totalSplitCurrentVal > currentValue){
                    var currentQuarterValue = component.get('v.Q'+currentQuarter);
                    component.set('v.Q'+currentQuarter, parseFloat((currentQuarterValue - (totalSplitCurrentVal - currentValue)).toFixed(2)));
                }
            }else{
                for(var i=1; i==4; i++){
                    component.set('v.Q'+i, 0);
                }
            }  
        }
    },
    calcSumOfQuarters : function(component){
        var isSplit = component.get('v.isSplit');
        var sumOfQuarters = 0;
        if(isSplit){
            var currentQuarter = component.get('v.currentQuarter');
            var totalVal = 0;
            var totalCurrentVal = 0;
            for(var i=0; i<=currentQuarter; i++){
                var curqval = component.get('v.Q'+i);
                var curTarVal = component.get('v.TargetQ'+i);
                if(curqval){
                    totalCurrentVal += parseFloat(curqval);
                }
                if(curTarVal){
                    totalVal += parseFloat(curTarVal);
                }
            }
            var notifiElem = component.find('notificationMessage');
            var currentQuarter = component.get('v.currentQuarter');
            var cQCurVal = component.get('v.Q'+currentQuarter);
            var cQTarVal = component.get('v.TargetQ'+currentQuarter);
            if(cQTarVal > cQCurVal){
                $A.util.removeClass(notifiElem, 'slds-hide');           
            }else{
                $A.util.addClass(notifiElem, 'slds-hide');
            }
            for(var i=1; i<5; i++){
                var curQVal = component.get('v.Q'+i);
                if(!$A.util.isUndefinedOrNull(curQVal) && ! isNaN(curQVal)){
                    sumOfQuarters += parseFloat(curQVal);        
                }
            }
            component.set('v.calcCurrentValue', sumOfQuarters);
            component.set('v.currentValue', sumOfQuarters);
        }
    }
})
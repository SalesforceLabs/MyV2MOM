({
    scriptsLoaded : function(component, event, helper) {
        try {
        var currentVal = component.get('v.currentVal');
        var targetVal = component.get('v.targetVal');
        var hasNumber = component.get('v.hasNumber');
        var status = component.get('v.status');
        var container = component.find('container').getElement();
        var sWidth = 6;
        if(!($A.util.isUndefinedOrNull(hasNumber)&&$A.util.isUndefinedOrNull(currentVal)&&$A.util.isUndefinedOrNull(targetVal)) && hasNumber){
            var percentage = (currentVal/targetVal);
            var bar = new ProgressBar.Circle(component.find('container').getElement(), {
                color: '#aaa',
                // This has to be the same size as the maximum width to
                // prevent clipping
                strokeWidth: sWidth,
                trailWidth: sWidth,
                easing: 'easeInOut',
                duration: 900,
                text: {
                    autoStyleContainer: false
                },
                from: { color: '#0070D2', width: sWidth },
                to: { color: '#4bca81', width: sWidth },
                // Set default step function for all animate calls
                step: function(state, circle) {
                    circle.path.setAttribute('stroke', state.color);
                    circle.path.setAttribute('stroke-width', state.width);
                    
                    var value = Math.round(circle.value() * 100);
                    if (value === 0) {
                        circle.setText('0%');
                    } else {
                        if(percentage < 1){
                            circle.setText((percentage*100).toFixed(1)+'%');
                        }else if(percentage >=1 ){
                            circle.setText(Math.floor(percentage*100)+'%');
                        }
                    }
                }
            });
            bar.text.style.fontSize = '1.5rem';
            if(percentage < 1){
                bar.set(percentage);
            }else if(percentage >=1 ){
                bar.set(1);
            }
        }else{
            var colorArray = {
                "On Track" : "#0070D2",
                "Not Started" : "#b0adab",
                "Behind Schedule" : "#870500",
                "On Hold" : "#ff9a3c",
                "Completed" : "#4bca81"
            };
            var circle = new ProgressBar.Circle(container, {
                color: colorArray[status] ? colorArray[status] : '#aaaaaa',
                strokeWidth: sWidth,
                trailWidth: sWidth,
                text: {
                    value: status ? status : 'No Status'
                }
            });
            circle.text.style.fontSize = '1rem';
            circle.set(1);
        }
        
        }catch(error) {
            
        }
    }
})
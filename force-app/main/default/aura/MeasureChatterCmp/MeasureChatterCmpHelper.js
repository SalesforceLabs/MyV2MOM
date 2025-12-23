({
    measureFeedHelper : function(component) {
        var vRecordId = component.get("v.recordId");//a00B0000006nwVbIAI';
        
        ////
        if(vRecordId){
            var action = component.get("c.getCurrentMeasureFeed");
            action.setParams({ measureId : vRecordId });
            // Create a callback that is executed after 
            // the server-side action returns
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    component.set('v.lstFeedComments',result);
                    console.log(result);
                    if(result == '' || result == null || result == 'undefined' || result == undefined){
                        component.set('v.recordId',vRecordId);
                    }/*else{
                        component.set('v.parentFeedId',result[0].sParentFeedId);
                    }*/
                }
                else if (state === "INCOMPLETE") {
                    console.log("No response from server or client is offline.");
                }
                    else if (state === "ERROR") {
                        console.log('An unknown error occured.');
                    }
            });
            $A.enqueueAction(action);
        } 
        // $A.enqueueAction adds the server-side action to the queue.
        
    },
    postToMeasureHelper :  function(component) {
        /*var vParentFeed = component.get("v.parentFeedId");
        var vRecordId;
        if(vParentFeed == null || vParentFeed == '' || vParentFeed == undefined || vParentFeed == 'undefined'){
            vRecordId = component.get("v.recordId");//'a00B0000006nwVbIAI';//
        }else{
            vRecordId = vParentFeed;
        }*/
        var vRecordId = component.get("v.recordId");
        var vPost = component.get("v.commentFeed");
        var action = component.get("c.createMeasureFeedComment"); 
        var self = this;
        action.setParams({ sRecordId : vRecordId,sPost: vPost});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                self.measureFeedHelper(component);
                component.set("v.commentFeed",'')
                self.showHideButtonHelper(component);
                var commentsDiv = component.find('commentsList').getElement();
                commentsDiv.scrollTop = commentsDiv.scrollHeight;
            }
            else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.");
            }
                else if (state === "ERROR") {
                    console.log('An unknown error occured.');
                }
        });
        
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
        
    },
    updateMeasureHelper : function(component,event) {
        //var vRecordId = component.get("v.editFeedId");
        var vFeedItemId =  component.get("v.editFeedId");
        
        var vPost =  event.getSource().get('v.name');
        var action = component.get("c.updateMeasureFeedComment"); 
        var self = this;
        action.setParams({sFeedItemId : vFeedItemId,sPost: vPost});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                self.measureFeedHelper(component);
                 component.set("v.editFeedId",'');
            }
            else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.");
            }
                else if (state === "ERROR") {
                    console.log('An unknown error occured.');
                }
        });
        
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    },
    showHideButtonHelper : function(component) {
        var vCommentBody = component.get('v.commentFeed');
        if(vCommentBody.length > 0){
            component.set('v.bCommentFlag',false);
        }else{
            component.set('v.bCommentFlag',true);
        }
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
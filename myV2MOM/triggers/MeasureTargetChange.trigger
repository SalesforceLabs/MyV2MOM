trigger MeasureTargetChange on myV2MOM__Measure__c (after update) {
    
    User userObj = [select id, ManagerId from User where id =: UserInfo.getUserId()];
    for(integer i=0; i<trigger.new.size(); i++){
        String chatterBodyStr = '';
        if(trigger.new[i].myV2MOM__Target_Value__c != trigger.old[i].myV2MOM__Target_Value__c){
            chatterBodyStr += 'Target from '+trigger.old[i].myV2MOM__Target_Value__c+' to ';
            chatterBodyStr += trigger.new[i].myV2MOM__Target_Value__c+'\n';
        }
        if(trigger.new[i].myV2MOM__Q1_Target__c != trigger.old[i].myV2MOM__Q1_Target__c){
            chatterBodyStr += 'Q1 Target from '+trigger.old[i].myV2MOM__Q1_Target__c+' to ';
            chatterBodyStr += trigger.new[i].myV2MOM__Q1_Target__c+'\n';
        }
        if(trigger.new[i].myV2MOM__Q2_Target__c != trigger.old[i].myV2MOM__Q2_Target__c){
            chatterBodyStr += 'Q2 Target from '+trigger.old[i].myV2MOM__Q2_Target__c+' to ';
            chatterBodyStr += trigger.new[i].myV2MOM__Q2_Target__c+'\n';
        }
        if(trigger.new[i].myV2MOM__Q3_Target__c != trigger.old[i].myV2MOM__Q3_Target__c){
            chatterBodyStr += 'Q3 Target from '+trigger.old[i].myV2MOM__Q3_Target__c+' to ';
            chatterBodyStr += trigger.new[i].myV2MOM__Q3_Target__c+'\n';
        }
        if(trigger.new[i].myV2MOM__Q4_Target__c != trigger.old[i].myV2MOM__Q4_Target__c){
            chatterBodyStr += 'Q4 Target from '+trigger.old[i].myV2MOM__Q4_Target__c+' to ';
            chatterBodyStr += trigger.new[i].myV2MOM__Q4_Target__c+'\n';
        }
        
        if(chatterBodyStr != ''){
            if(userObj.ManagerId != null){
                V2MOM_UtilCls.postChatterMsg(userObj.ManagerId, ',\n Below target values got changed : \n'+ chatterBodyStr, trigger.new[i].Id);
            }else{
                V2MOM_UtilCls.postChatterMsg(userObj.Id , ',\n Below target values got changed : \n'+ chatterBodyStr, trigger.new[i].Id);
            }
        }
    }
}
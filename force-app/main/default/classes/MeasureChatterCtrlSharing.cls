/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
/* This class helps in manually sharing the records. 
 * Used without sharing keyword, as the org-wide default is public read-only. */
public without sharing class MeasureChatterCtrlSharing {
    
    /* This method helps in manually sharing the records with edit permission */ 
    public static void shareMeasureManually(String measureId, List<String> userList){
        if(! (FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(), 'Measure__c') && FLSCheck.isCreateable(MeasureChatterCtrlSharing.getMeasureFields(), 'Measure__c')) ){
            return;
        }
        
        List<Measure__Share> meaShareExists = new  List<Measure__Share>();
        meaShareExists = [select id,UserOrGroupId from Measure__Share where ParentId =: measureId];
        List<String> remoUsers = new List<String>();
        for(Measure__Share meaShare : meaShareExists){
            remoUsers.add(meaShare.UserOrGroupId);
        }
        
        Set<String> usersToShare = new Set<String>();
        usersToShare.addAll(userList);
        usersToShare.removeAll(remoUsers);
        
        List<Measure__Share> mRecdShareList = new List<Measure__Share>();
        for(String userId : usersToShare){
            Measure__Share mRecdShare = new Measure__Share();
            mRecdShare.AccessLevel = 'Edit';
            mRecdShare.ParentId = measureId;
            mRecdShare.UserOrGroupId = userId;
            mRecdShareList.add(mRecdShare);
        }
        if(mRecdShareList != null && mRecdShareList.size() > 0){
            insert mRecdShareList;
        }
    }
    
    /* This method will return all the editable fields on myV2MOM_Method__c object for System Admin */
    public static List<String> getMethodFields(){
        List<String> fieldNames = new List<String>();
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Method__c.fields.getMap();
        for (Schema.SObjectField sfield : m.Values()) {
            if (sfield.getDescribe().isUpdateable()) {
                //system.debug('field-->'+sfield.getDescribe().getname());
                fieldNames.add(sfield.getDescribe().getname());
            }
        }
        return fieldNames;
    } 
    
     /* This method will return all the editable fields on myV2MOM_Measure__c object for System Admin */
    public static List<String> getMeasureFields(){
        List<String> fieldNames = new List<String>();
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Measure__c.fields.getMap();
        for (Schema.SObjectField sfield : m.Values()) {
            if (sfield.getDescribe().isUpdateable()) {
                //system.debug('field-->'+sfield.getDescribe().getname());
                fieldNames.add(sfield.getDescribe().getname());
            }
        }
        return fieldNames;
    } 
    
     /* This method will return all the editable fields on myV2MOM_V2MOM__c object for System Admin */
    public static List<String> getV2MOMFields(){
        List<String> fieldNames = new List<String>();
        Map<String,Schema.SObjectField> m = Schema.SObjectType.V2MOM__c.fields.getMap();
        for (Schema.SObjectField sfield : m.Values()) {
            if (sfield.getDescribe().isUpdateable()) {
                //system.debug('field-->'+sfield.getDescribe().getname());
                fieldNames.add(sfield.getDescribe().getname());
            }
        }
        return fieldNames;
    } 
    
    /* This method will return all the editable fields on Measure_Team__c object for System Admin */
    public static List<String> getMeasureTeamFields(){
        List<String> fieldNames = new List<String>();
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Measure_Team__c.fields.getMap();
        for (Schema.SObjectField sfield : m.Values()) {
            if (sfield.getDescribe().isUpdateable()) {
                //system.debug('field-->'+sfield.getDescribe().getname());
                fieldNames.add(sfield.getDescribe().getname());
            }
        }
        return fieldNames;
    } 
}
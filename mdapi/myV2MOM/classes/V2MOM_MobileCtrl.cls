/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
/* This is a handler class which solves business logic requests from lightning components in mobile. */
public with sharing class V2MOM_MobileCtrl {
    
    /* This is a wrapper class for displaying methods and its measures both in mobile and desktop. 
    public class MethodAndMeasureWrap{
        @AuraEnabled
        public Map<Id, Method__c> mtWrap {get; set;}
        @AuraEnabled
        public Map<Id, List<MeasuresWrapper>> mnm {get; set;}
        public MethodAndMeasureWrap(Map<Id, Method__c> mtWrap, Map<Id, List<MeasuresWrapper>> mnm){
            this.mtWrap = mtWrap;
            this.mnm = mnm;
        }
    }
    */
    /* This method helps in returning data for methods and measures. */ 
    @AuraEnabled
    public static V2MOM_UtilCls.newMethodAndMeasureWrap getMnMNew(string v2MOMId){
      	return V2MOM_UtilCls.getMnMNew(v2MOMId);
    }
    
    /* This method helps in searching the users. */
    @AuraEnabled
    public static List<User> searchUsers(String vSearchStr){
        List<String> checkUserFields = new List<String>();
        checkUserFields.add('Name');
        checkUserFields.add('SmallPhotoUrl');
        checkUserFields.add('Title');
        if(! FLSCheck.isAccessible(checkUserFields, 'User') ){
            return new List<User>();
        }
        
        vSearchStr = String.escapeSingleQuotes('%'+vSearchStr+'%');
        List<User> userList = [select Id, Name, SmallPhotoUrl, Title from User where Name LIKE: vSearchStr];
        return userList;
    }
    
    /* This method helps in fetching logged in user id. */
    @AuraEnabled
    public static String fetchUserId(){
        return V2MOM_UtilCls.getUserId();
    }
    
    /* This method helps in fetching Measure object-Status field picklist values from schema. */
    @AuraEnabled
    public static List<V2MOM_UtilCls.labelValueWrap> getMeasureStatusPicklistValues(){
        return V2MOM_UtilCls.getStatusPicklistValues();
    }
    
    /* This method helps in saving and updating vision and values. */
    @AuraEnabled
    public static V2MOM__c saveV2V(String visionVal, String valueVal, String v2momIdVal){
        if(!(FLSCheck.isAccessible(MeasureChatterCtrlSharing.getV2MOMFields(), 'V2MOM__c')  && FLSCheck.isCreateable(MeasureChatterCtrlSharing.getV2MOMFields(), 'V2MOM__c') && FLSCheck.isUpdateable(MeasureChatterCtrlSharing.getV2MOMFields(), 'V2MOM__c'))){
            return new V2MOM__c();
        }
        
        V2MOM__c v2momObj;
        if(v2momIdVal != ''){
            List<V2MOM__c> v2momObjList = [select Id, Vision__c, Values__c from V2MOM__c where id =: v2momIdVal];
            if(v2momObjList != null && v2momObjList.size() > 0){
                v2momObj = v2momObjList[0];
                v2momObj.Vision__c = visionVal;
                v2momObj.Values__c = valueVal;
                update v2momObj;
            }else{
                String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
                
                v2momObj = new V2MOM__c();
                v2momObj.Vision__c = visionVal;
                v2momObj.Values__c = valueVal;
                v2momObj.FY_Year__c = currentFiscalYear;
                v2momObj.Status__c = 'Draft';
                v2momObj.Name = 'FY'+v2momObj.FY_Year__c+' V2MOM '+UserInfo.getName();
                insert v2momObj;
            }
        }else{
            String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
            
            v2momObj = new V2MOM__c();
            v2momObj.Vision__c = visionVal;
            v2momObj.Values__c = valueVal;
            v2momObj.FY_Year__c = currentFiscalYear;
            v2momObj.Status__c = 'Draft';
            v2momObj.Name = 'FY'+v2momObj.FY_Year__c+' V2MOM '+UserInfo.getName();
            insert v2momObj;
        }
        return v2momObj;
    }
    
    /* This method helps in fetching existing vision and values. */
    @AuraEnabled
    public static V2MOM__c fetchV2V(String v2momIdVal){
        if(! FLSCheck.isAccessible(MeasureChatterCtrlSharing.getV2MOMFields(), 'V2MOM__c') ){
            return new V2MOM__c();
        }
        
        V2MOM__c v2momObj;
        if(v2momIdVal != ''){
            List<V2MOM__c> v2momObjList = [select Id, Vision__c, Values__c from V2MOM__c where id =: v2momIdVal];
            if(v2momObjList != null && v2momObjList.size() > 0){
                v2momObj = v2momObjList[0];
            }else{
                v2momObj = new V2MOM__c();
            }
        }else{
            v2momObj = new V2MOM__c();
        }
        
        return v2momObj;
    }
    
    /* This method helps in fetching existing v2mom rec in the mobile home screen. */
    @AuraEnabled
    public static V2MOMHomeW fetchV2MOMRec(String v2momId){
        if(! FLSCheck.isAccessible(MeasureChatterCtrlSharing.getV2MOMFields(), 'V2MOM__c') ){
            return new V2MOMHomeW();
        }
        
        V2MOMHomeW v2momHWObj = new V2MOMHomeW();
        String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
        List<V2MOM__c> v2momObjList = new List<V2MOM__c>();
        
        if(v2momId != null && v2momId != ''){
            v2momObjList = [select Id, CreatedById, Name, Vision__c, Values__c, FY_Year__c, Published_Date__c, Status__c, LastModifiedDate from V2MOM__c where id =: v2momId];
        }else{
            v2momObjList = [select Id, Vision__c, Values__c, CreatedById, FY_Year__c, Published_Date__c, Status__c, Name, LastModifiedDate from V2MOM__c where FY_Year__c =: currentFiscalYear AND CreatedById =: UserInfo.getUserId()];
        }
        
        V2MOM__c v2momObj;
        if(v2momObjList != null && v2momObjList.size() > 0){
            v2momObj = v2momObjList[0];
        }else{
            v2momObj = new V2MOM__c();
        }
        v2momHWObj.v2momObj = v2momObj;
        
        List<User> userList = [select id, ManagerId from User where id =: v2momHWObj.v2momObj.CreatedById];
        if(userList != null && userList.size() > 0){
            List<V2MOM__c> v2momObjListM = [select id from V2MOM__c where FY_Year__c =: currentFiscalYear AND CreatedById =: userList[0].ManagerId];
            V2MOM__c v2momObjM;
            if(v2momObjListM != null && v2momObjListM.size() > 0){
                v2momObjM = v2momObjListM[0];
            }else{
                v2momObjM = new V2MOM__c();
            }
            v2momHWObj.managerV2momId = v2momObjM.Id;
        }else{
            v2momHWObj.managerV2momId = '';
        }
        
        List<V2MOM__c> v2momObjOptList = new List<V2MOM__c>();
        if(v2momId != null && v2momId != ''){
            v2momObjOptList = [select Id, FY_Year__c from V2MOM__c where CreatedById =: v2momObj.CreatedById
                                         order by CreatedDate DESC];
        }else{
            v2momObjOptList = [select Id, FY_Year__c from V2MOM__c where CreatedById =: UserInfo.getUserId()];
        }
        
        if(v2momObjOptList != null && v2momObjOptList.size() > 0){
            v2momHWObj.v2momOptions = v2momObjOptList;
        }else{
            v2momHWObj.v2momOptions = new List<V2MOM__c>();
        }
        
        List<V2MOM__c> v2momObjcurrList =  [Select Id from V2MOM__c where FY_Year__c =: currentFiscalYear AND CreatedById =: UserInfo.getUserId()];
        V2MOM__c v2momObjCurr;
        if(v2momObjcurrList != null && v2momObjcurrList.size() > 0){
            v2momObjCurr = v2momObjcurrList[0];
        }else{
            v2momObjCurr = new V2MOM__c();
        }
        v2momHWObj.currentUserV2MOMId = v2momObjCurr.Id;
        
        if(v2momObjList != null && v2momObjList.size() > 0){
             v2momHWObj.lastupdatedDate = V2MOM_UtilCls.calcLastupdatedDate(v2momHWObj.v2momObj);
             system.debug('v2momHWObj.lastupdatedDate: '+v2momHWObj.lastupdatedDate);
        }else{
            v2momHWObj.lastupdatedDate = null;
        }
        
        return v2momHWObj;
    }
    
    /* Wrapper for mobile home screen. */
    public class V2MOMHomeW{
    	@AuraEnabled
        public V2MOM__c v2momObj;
        @AuraEnabled
        public String managerV2momId;
        @AuraEnabled
        public List<V2MOM__c> v2momOptions;
        @AuraEnabled
        public string currentUserV2MOMId;
        @AuraEnabled
        public DateTime lastupdatedDate;
    }
    
    /* Method to check if logged in user a manager. */
    @AuraEnabled
    public static boolean isUserAManagerMob(String uId){
        return V2MOM_Controller.isUserAManager(uId);
    }
    
    /* This method helps in returning manager's vision. */
    @auraEnabled
    public static String referManagerVisionMob(V2MOM__c V2MOMrec){
        System.debug('In Mobile Ctrl::'+V2MOMrec);
        return V2MOM_Controller.referManagerVision(V2MOMrec);
    }
    
    /* This method helps in returning manager's values. */
    @auraEnabled
    public static String referManagerValueMob(V2MOM__c V2MOMrec){
        return V2MOM_Controller.referManagerValue(V2MOMrec);
    }
    
    /* This method helps in publishing your V2MOM. */
    @AuraEnabled
    public static V2MOM__c publishV2MOMMob(String v2momIdVal){
        if(! FLSCheck.isAccessible(MeasureChatterCtrlSharing.getV2MOMFields(), 'V2MOM__c') ){
            return new V2MOM__c();
        }
        
        V2MOM__c v2MOMObj = V2MOM_Controller.publishV2MOM(v2momIdVal);
        v2MOMObj = [select id, CreatedById, Name, Vision__c, Values__c, FY_Year__c, Published_Date__c, Status__c from V2MOM__c where id=: v2MOMObj.Id];
    	return v2MOMObj;
    }
}
/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
public with sharing class V2MOM_Measure_Controller {
    
    @AuraEnabled
    //Method to return current quarter end date
    public static date getQuarterEndDate(Integer currentQuarter){
        try{
            return V2MOM_UtilCls.getFiscalQuarterEndDate(currentQuarter);
        }catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @auraEnabled
    //Method to create a Measure
    public static void createMeasure(Measure__c measure){
        if(measure.Priority__c == 'H'){
            measure.Priority__c = 'High';
        }else if(measure.Priority__c == 'M'){
            measure.Priority__c = 'Medium';
        }else if(measure.Priority__c == 'L'){
            measure.Priority__c = 'Low';
        }
        
        if(measure.Track_Progress_By__c == 'N'){
            measure.Track_Progress_By__c = 'Numbers Completed';
        }else if(measure.Track_Progress_By__c == 'C'){
            measure.Track_Progress_By__c = 'Completion Status';
        }
        List<String> measFields = MeasureChatterCtrlSharing.getMeasureFields();
        if(FLSCheck.isAccessible(measFields,'Measure__c') && FLSCheck.isCreateable(measFields,'Measure__c') && FLSCheck.isUpdateable(measFields,'Measure__c')){
            upsert measure; 
        }
        
    }
    
    //---------------- For Mobile ----------------
    @AuraEnabled
    //Set picklist values on the lightning component
    public static Map<String, List<V2MOM_UtilCls.labelValueWrap>> getAllMeasurePickLists(){
        Map<String, List<V2MOM_UtilCls.labelValueWrap>> pickMap = new Map<String, List<V2MOM_UtilCls.labelValueWrap>>();
        pickMap.put('progress', getProgressTypesMobile());
        pickMap.put('priority', getPriorityTypesMobile());
        pickMap.put('status', getStatusTypesMobile());
        return pickMap;
    }
    
    @AuraEnabled
    //get all available progress type values
    public static List<V2MOM_UtilCls.labelValueWrap> getProgressTypesMobile(){
        List<V2MOM_UtilCls.labelValueWrap> options = new List<V2MOM_UtilCls.labelValueWrap>();
        if(FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(),'Measure__c')){
            Schema.DescribeFieldResult fieldResult = Measure__c.Track_Progress_By__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(new V2MOM_UtilCls.labelValueWrap(f.getLabel(), f.getValue()));
            }
        }
        return options;
    }
    @AuraEnabled
    //Method to return available priority types from Priority__c field on Measure__c object
    public static List<V2MOM_UtilCls.labelValueWrap> getPriorityTypesMobile(){
        List<V2MOM_UtilCls.labelValueWrap> options = new List<V2MOM_UtilCls.labelValueWrap>();
        if(FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(),'Measure__c')){
            Schema.DescribeFieldResult fieldResult = Measure__c.Priority__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(new V2MOM_UtilCls.labelValueWrap(f.getLabel(), f.getValue()));
            }
        }
        return options;
    }
    
    @AuraEnabled
    //Method to return available status types from Status__c field on Measure__c object
    public static List<V2MOM_UtilCls.labelValueWrap> getStatusTypesMobile(){
        List<V2MOM_UtilCls.labelValueWrap> options = new List<V2MOM_UtilCls.labelValueWrap>();
        if(FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(),'Measure__c')){
            Schema.DescribeFieldResult fieldResult = Measure__c.Status__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(new V2MOM_UtilCls.labelValueWrap(f.getLabel(), f.getValue()));
            }
        }
        return options;
    }
    //---------------- For Mobile ----------------
    
    @AuraEnabled
    //get all available progress type values
    public static List<String> getProgressTypes(){
        List<String> options = new List<String>();
        if(FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(),'Measure__c')){
            Schema.DescribeFieldResult fieldResult = Measure__c.Track_Progress_By__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(f.getLabel());
            }
        }
        return options;
    }
    @AuraEnabled
    //Method to return available priority types from Priority__c field on Measure__c object
    public static List<String> getPriorityTypes(){
        List<String> options = new List<String>();
        if(FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(),'Measure__c')){
            Schema.DescribeFieldResult fieldResult = Measure__c.Priority__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(f.getLabel());
            }
        }
        return options;
    }
    
    @AuraEnabled
    //Method to return available status types from Priority__c field on Measure__c object
    public static List<String> getStatusTypes(){
        List<String> options = new List<String>();
        if(FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(),'Measure__c')){
            Schema.DescribeFieldResult fieldResult = Measure__c.Status__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(f.getLabel());
            }
        }
        return options;
    }
    @AuraEnabled
    //Method to return available details on a measure based on the measure id passed
    public static Measure__c getMeasureDetails(String measId){
        List<String> measFields = MeasureChatterCtrlSharing.getMeasureFields();
        if(!FLSCheck.isAccessible(measFields,'Measure__c')){
            Measure__c measure = new Measure__c();
            return measure;
        }
        Measure__c meas = [SELECT Id, Name, Track_Progress_By__c, Priority__c, Status__c, Method__c, Target_Value__c, Current_Value__c, Split_By_Quarter__c, Completion_By_Date__c, Completion_By_Quarter__c, Q1__c, Q2__c, Q3__c, Q4__c, Q1_Target__c, Q2_Target__c, Q3_Target__c, Q4_Target__c, Comments__c, Obstacles__c FROM Measure__c WHERE Id =: measId];
        return meas;
    }
    
}
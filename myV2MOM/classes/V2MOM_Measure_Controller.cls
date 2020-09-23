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
    public static void createMeasure(myV2MOM__Measure__c measure){
        if(measure.myV2MOM__Priority__c == 'H'){
            measure.myV2MOM__Priority__c = 'High';
        }else if(measure.myV2MOM__Priority__c == 'M'){
            measure.myV2MOM__Priority__c = 'Medium';
        }else if(measure.myV2MOM__Priority__c == 'L'){
            measure.myV2MOM__Priority__c = 'Low';
        }
        
        if(measure.myV2MOM__Track_Progress_By__c == 'N'){
            measure.myV2MOM__Track_Progress_By__c = 'Numbers Completed';
        }else if(measure.myV2MOM__Track_Progress_By__c == 'C'){
            measure.myV2MOM__Track_Progress_By__c = 'Completion Status';
        }
        List<String> measFields = MeasureChatterCtrlSharing.getMeasureFields();
        if(FLSCheck.isAccessible(measFields,'myV2MOM__Measure__c') && FLSCheck.isCreateable(measFields,'myV2MOM__Measure__c') && FLSCheck.isUpdateable(measFields,'myV2MOM__Measure__c')){
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
        if(FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(),'myV2MOM__Measure__c')){
            Schema.DescribeFieldResult fieldResult = myV2MOM__Measure__c.myV2MOM__Track_Progress_By__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(new V2MOM_UtilCls.labelValueWrap(f.getLabel(), f.getValue()));
            }
        }
        return options;
    }
    @AuraEnabled
    //Method to return available priority types from myV2MOM__Priority__c field on myV2MOM__Measure__c object
    public static List<V2MOM_UtilCls.labelValueWrap> getPriorityTypesMobile(){
        List<V2MOM_UtilCls.labelValueWrap> options = new List<V2MOM_UtilCls.labelValueWrap>();
        if(FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(),'myV2MOM__Measure__c')){
            Schema.DescribeFieldResult fieldResult = myV2MOM__Measure__c.myV2MOM__Priority__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(new V2MOM_UtilCls.labelValueWrap(f.getLabel(), f.getValue()));
            }
        }
        return options;
    }
    
    @AuraEnabled
    //Method to return available status types from myV2MOM__Status__c field on myV2MOM__Measure__c object
    public static List<V2MOM_UtilCls.labelValueWrap> getStatusTypesMobile(){
        List<V2MOM_UtilCls.labelValueWrap> options = new List<V2MOM_UtilCls.labelValueWrap>();
        if(FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(),'myV2MOM__Measure__c')){
            Schema.DescribeFieldResult fieldResult = myV2MOM__Measure__c.myV2MOM__Status__c.getDescribe();
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
        if(FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(),'myV2MOM__Measure__c')){
            Schema.DescribeFieldResult fieldResult = myV2MOM__Measure__c.myV2MOM__Track_Progress_By__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(f.getLabel());
            }
        }
        return options;
    }
    @AuraEnabled
    //Method to return available priority types from myV2MOM__Priority__c field on myV2MOM__Measure__c object
    public static List<String> getPriorityTypes(){
        List<String> options = new List<String>();
        if(FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(),'myV2MOM__Measure__c')){
            Schema.DescribeFieldResult fieldResult = myV2MOM__Measure__c.myV2MOM__Priority__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(f.getLabel());
            }
        }
        return options;
    }
    
    @AuraEnabled
    //Method to return available status types from myV2MOM__Priority__c field on myV2MOM__Measure__c object
    public static List<String> getStatusTypes(){
        List<String> options = new List<String>();
        if(FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(),'myV2MOM__Measure__c')){
            Schema.DescribeFieldResult fieldResult = myV2MOM__Measure__c.myV2MOM__Status__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(f.getLabel());
            }
        }
        return options;
    }
    @AuraEnabled
    //Method to return available details on a measure based on the measure id passed
    public static myV2MOM__Measure__c getMeasureDetails(String measId){
        List<String> measFields = MeasureChatterCtrlSharing.getMeasureFields();
        if(!FLSCheck.isAccessible(measFields,'myV2MOM__Measure__c')){
            myV2MOM__Measure__c measure = new myV2MOM__Measure__c();
            return measure;
        }
        myV2MOM__Measure__c meas = [SELECT Id, Name, myV2MOM__Track_Progress_By__c, myV2MOM__Priority__c, myV2MOM__Status__c, myV2MOM__Method__c, myV2MOM__Target_Value__c, myV2MOM__Current_Value__c, myV2MOM__Split_By_Quarter__c, myV2MOM__Completion_By_Date__c, myV2MOM__Completion_By_Quarter__c, myV2MOM__Q1__c, myV2MOM__Q2__c, myV2MOM__Q3__c, myV2MOM__Q4__c, myV2MOM__Q1_Target__c, myV2MOM__Q2_Target__c, myV2MOM__Q3_Target__c, myV2MOM__Q4_Target__c, myV2MOM__Comments__c, myV2MOM__Obstacles__c FROM myV2MOM__Measure__c WHERE Id =: measId];
        return meas;
    }
    
}
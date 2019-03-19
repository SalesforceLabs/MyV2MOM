public with sharing class V2MOM_InItWrapper {
    @auraEnabled
    public String userName;
    @auraEnabled
    public String userId;
    @auraEnabled
    public V2MOM__c v2momRecord;
    @auraEnabled
    public Boolean isUserManager;
    @AuraEnabled
    public V2MOM_UtilCls.newMethodAndMeasureWrap newMnMsvar;
    @AuraEnabled
    public List<V2MOM__c> v2momOptions;
    /*@AuraEnabled
    public string brandColor;*/
    
    public V2MOM_InItWrapper(String userNameVar, String userIdVar, V2MOM__c v2momRecordVar, Boolean isUserManagerVar, V2MOM_UtilCls.newMethodAndMeasureWrap newMnMs, List<V2MOM__c> v2momOptionsVar){
        userName = userNameVar;
        userId = userIdVar;
        v2momRecord = v2momRecordVar;
        isUserManager = isUserManagerVar;
        newMnMsvar = newMnMs;
        v2momOptions = v2momOptionsVar;
        //brandColor = brandColor;
    }
}
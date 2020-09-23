public with sharing class V2MOM_InItWrapper {
    @auraEnabled
    public String userName;
    @auraEnabled
    public String userId;
    @auraEnabled
    public myV2MOM__V2MOM__c v2momRecord;
    @auraEnabled
    public Boolean isUserManager;
    @AuraEnabled
    public V2MOM_UtilCls.newMethodAndMeasureWrap newMnMsvar;
    @AuraEnabled
    public List<myV2MOM__V2MOM__c> v2momOptions;
    /*@AuraEnabled
    public string brandColor;*/
    
    public V2MOM_InItWrapper(String userNameVar, String userIdVar, myV2MOM__V2MOM__c v2momRecordVar, Boolean isUserManagerVar, V2MOM_UtilCls.newMethodAndMeasureWrap newMnMs, List<myV2MOM__V2MOM__c> v2momOptionsVar){
        userName = userNameVar;
        userId = userIdVar;
        v2momRecord = v2momRecordVar;
        isUserManager = isUserManagerVar;
        newMnMsvar = newMnMs;
        v2momOptions = v2momOptionsVar;
        //brandColor = brandColor;
    }
}
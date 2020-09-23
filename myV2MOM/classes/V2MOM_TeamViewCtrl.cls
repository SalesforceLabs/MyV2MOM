/* This class holds the business logic for team view in v2mom for both mobile and desktop. */
public with sharing class V2MOM_TeamViewCtrl {

    /* This method fetches list of users grouped by title that are displayed in team view of a V2MOM. */
    @AuraEnabled
    public static Map<String, List<UserWrap>> fetchUsers(String v2momId){
        String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
        
        List<String> checkUserFields = new List<String>();
        checkUserFields.add('Name');
        checkUserFields.add('SmallPhotoUrl');
        checkUserFields.add('Title');
        if(! FLSCheck.isAccessible(checkUserFields, 'User') ){
            return new Map<String, List<UserWrap>>();
        }
        
        Map<String, List<UserWrap>> userTitleMap = new Map<String, List<UserWrap>>();
        List<User> usersList = [select id, Name, SmallPhotoUrl, Title from User where Title != null AND ManagerId =: UserInfo.getUserId() AND IsActive = true];
        
        Map<String, User> userMap = new Map<String, User>();
        for(User userObj : usersList){
            userMap.put(userObj.id, userObj);
        }
        
        if(! FLSCheck.isAccessible(MeasureChatterCtrlSharing.getV2MOMFields(), 'myV2MOM__V2MOM__c') ){
            return new Map<String, List<UserWrap>>();
        }
        
        Map<String, V2MOM__c> v2momUserMap = new Map<String, V2MOM__c>();
        List<V2MOM__c> v2momList = [select id, CreatedById from V2MOM__c where CreatedById IN: userMap.keySet() AND
                                   	FY_Year__c =: currentFiscalYear];
        for(V2MOM__c v2momObj : v2momList){
            v2momUserMap.put(v2momObj.CreatedById, v2momObj);
        }
        
        if(! FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(), 'myV2MOM__Measure__c') ){
            return new Map<String, List<UserWrap>>();
        }
        
        List<AggregateResult> aggMeasList = [select count(id) statusChecker, CreatedById, Status__c from myV2MOM__Measure__c 
                                             where Method__r.V2MOM__r.FY_Year__c =: currentFiscalYear
                                             AND CreatedById IN: userMap.keySet() Group By CreatedById, Status__c];

        Map<Id, UserWrap> userWrapMap = new Map<Id, UserWrap>();
        for(AggregateResult aggRes : aggMeasList){
            UserWrap userWrapObj = new UserWrap();
            userWrapObj.userObj = userMap.get(String.valueOf(aggRes.get('CreatedById')));
            
            if(userWrapMap.containsKey(userWrapObj.userObj.Id)){
                UserWrap userWrapObjTemp = userWrapMap.get(userWrapObj.userObj.Id);
                if(userWrapObjTemp.userStatus == 'Needs Attention'){
                    userWrapObjTemp.userStatus = 'Needs Attention';
                }else{
                    if(aggRes.get('myV2MOM__Status__c') == 'Behind Schedule'){
                        userWrapObjTemp.userStatus = 'Needs Attention';
                    }else{
                        userWrapObjTemp.userStatus = 'On Track';
                    }
                }
                userWrapMap.put(userWrapObjTemp.userObj.Id, userWrapObjTemp);
            }else{
            	if(aggRes.get('myV2MOM__Status__c') == 'Behind Schedule'){
                    userWrapObj.userStatus = 'Needs Attention';
                }else{
                    userWrapObj.userStatus = 'On Track';
                }
                userWrapMap.put(userWrapObj.userObj.Id, userWrapObj);    
            }
        }
        
        for(User userObj : userMap.values()){
            UserWrap userWrapObj = userWrapMap.get(userObj.Id);
            if(userWrapObj != null){
                if(userTitleMap.containsKey(userWrapObj.userObj.Title)){
                    List<UserWrap> userList = userTitleMap.get(userWrapObj.userObj.Title);
                    userList.add(userWrapObj);
                    userTitleMap.put(userWrapObj.userObj.Title, userList);
                }else{
                    List<UserWrap> userList = new List<UserWrap>();
                    userList.add(userWrapObj);
                    userTitleMap.put(userWrapObj.userObj.Title, userList);
                }
            }else{
                UserWrap userWrapObjTemp = new UserWrap();
                userWrapObjTemp.userObj = userObj;
                if(v2momUserMap.get(userObj.Id) != null){
                    userWrapObjTemp.userStatus = 'Draft';
                }else{
                    userWrapObjTemp.userStatus = 'Not Started';
                }
                
                if(userTitleMap.containsKey(userWrapObjTemp.userObj.Title)){
                    List<UserWrap> userList = userTitleMap.get(userWrapObjTemp.userObj.Title);
                    userList.add(userWrapObjTemp);
                    userTitleMap.put(userWrapObjTemp.userObj.Title, userList);
                }else{
                    List<UserWrap> userList = new List<UserWrap>();
                    userList.add(userWrapObjTemp);
                    userTitleMap.put(userWrapObjTemp.userObj.Title, userList);
                }
            }
        }
        
        return userTitleMap;
    }
    
    /* Wrapper used to display the status of a user in team view v2mom. */
    public class UserWrap{
        @AuraEnabled
        public String userStatus;
        @AuraEnabled
        public User userObj;
    }
    
    /* This method with help in redirecting to a v2mom from team view v2mom. */
    @AuraEnabled
    public static String redirectV2MOM(String v2momId, String selUserId){
        if(! FLSCheck.isAccessible(MeasureChatterCtrlSharing.getV2MOMFields(), 'myV2MOM__V2MOM__c') ){
            return '';
        }
        
        String redV2MOMId;
        V2MOM__c v2momObj = [select id, FY_Year__c from V2MOM__c where id =: v2momId];
        List<V2MOM__c> v2momList = [select Id from V2MOM__c where CreatedById =: selUserId AND FY_Year__c =: v2momObj.FY_Year__c];
        if(v2momList != null && v2momList.size() > 0){
            redV2MOMId = v2momList[0].Id;
        }else{
            redV2MOMId = '';
        }
        
        return redV2MOMId;
    }
}
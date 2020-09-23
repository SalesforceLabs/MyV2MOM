public with sharing class V2MOM_Controller { 
    
    @AuraEnabled
    //Method to update shared measure record
    public static void updateAssignedMeasure(myV2MOM__Measure_Team__c mtRecord){
        try{
            List<String> userShareList = new List<String>();
            userShareList.add(UserInfo.getUserId());
            MeasureChatterCtrlSharing.shareMeasureManually(mtRecord.Measure__c, userShareList);
            List<String> mtFields = MeasureChatterCtrlSharing.getMeasureTeamFields();
            if(FLSCheck.isAccessible(mtFields,'myV2MOM__Measure_Team__c') && FLSCheck.isCreateable(mtFields,'myV2MOM__Measure_Team__c') && FLSCheck.isUpdateable(mtFields,'myV2MOM__Measure_Team__c')){
                upsert mtRecord; 
            }            
        }catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    //Method to fetch V2MOM details based on the provided v2MOM id.
    @auraEnabled
    public static V2MOM_InItWrapper V2MOM_InIt(String v2MOMId){
        Id managerV2MOMId;
        String uName = V2MOM_Controller.getUserName();
        String usId = UserInfo.getUserId();
        /*Fetch V2MOM Record and Manager V2MOM Id*/
        myV2MOM__V2MOM__c v2momRec;
        V2MOM_UtilCls.newMethodAndMeasureWrap allMnMs;
        List<V2MOM__c> v2momObjOptList = new List<V2MOM__c>();
        
        //String brandColor = V2MOM_Controller.getThemeBackground();
        //string brandColor = '';
		
        if(v2MOMId == null || v2MOMId == ''){
            String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
            v2momRec = new myV2MOM__V2MOM__c();
            List<myV2MOM__Method__c> myMnM = new List<myV2MOM__Method__c>();
            List<V2MOM_UtilCls.recListWrap> assignedMnM = new List<V2MOM_UtilCls.recListWrap>();
            List<V2MOM_UtilCls.recListWrap> adoptedMnM = new List<V2MOM_UtilCls.recListWrap>();
            allMnMs = new V2MOM_UtilCls.newMethodAndMeasureWrap(myMnM, assignedMnM, adoptedMnM);
            List<String> v2momFields = MeasureChatterCtrlSharing.getV2MOMFields();
            if(!FLSCheck.isAccessible(v2momFields,'myV2MOM__V2MOM__c')){
                return null;
            }
            v2momObjOptList = [select Id, FY_Year__c from V2MOM__c where CreatedById =: UserInfo.getUserId()
                               order by CreatedDate DESC];
        }else{
            List<String> v2momFields = MeasureChatterCtrlSharing.getV2MOMFields();
            if(!FLSCheck.isAccessible(v2momFields,'myV2MOM__V2MOM__c')){
                return null;
            }
            v2momRec = [SELECT Id, myV2MOM__Vision__c, myV2MOM__Values__c, CreatedById, CreatedBy.Name,  myV2MOM__FY_Year__c, myV2MOM__Status__c, myV2MOM__Published_Date__c
                        from myV2MOM__V2MOM__c WHERE id =: v2MOMId];
            allMnMs= V2MOM_UtilCls.getMnMNew(v2MOMId);
            v2momObjOptList = [select Id, FY_Year__c from V2MOM__c where CreatedById =: v2momRec.CreatedById
                               order by CreatedDate DESC];
        }
        boolean isUserMgr = V2MOM_Controller.isUserAManager(usId);
        
        V2MOM_InItWrapper inItWrapper = new V2MOM_InItWrapper(uName, usId, v2momRec, isUserMgr, allMnMs, v2momObjOptList);
        return inItWrapper;
    }
    /*
    public static string getThemeBackground(){
        String brandColor = '#5978A2';
		String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm(); 
        String restAPIURL = sfdcURL + '/services/data/v43.0/ui-api/themes/active';  
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(restAPIURL);
        request.setMethod('GET');
        request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());       
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        HttpResponse response = http.send(request);
        system.debug(response.getStatusCode());
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            Map<String, Object> o = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            system.debug(o.get('brandColor'));
            brandColor = string.valueof(o.get('brandColor'));
        }
         return brandColor;
    }
    */
    @auraEnabled
    public static myV2MOM__V2MOM__c getMyV2MOM(String v2MOMId){
        List<String> v2momFields = MeasureChatterCtrlSharing.getV2MOMFields();
        
        myV2MOM__V2MOM__c vm;
        if(v2MOMId == null || v2MOMId == ''){
            String usId = UserInfo.getUserId();
            String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
            
            if(!FLSCheck.isAccessible(v2momFields,'myV2MOM__V2MOM__c')){
                return null;
            }
            vm = [SELECT Id, myV2MOM__Vision__c, myV2MOM__Values__c, CreatedById, CreatedBy.Name ,  myV2MOM__FY_Year__c, myV2MOM__Status__c  from myV2MOM__V2MOM__c WHERE CreatedById =: usId AND myV2MOM__FY_Year__c =: currentFiscalYear];
        }else{
            
            if(!FLSCheck.isAccessible(v2momFields,'myV2MOM__V2MOM__c')){
                return null;
            }
            vm = [SELECT Id, myV2MOM__Vision__c, myV2MOM__Values__c, CreatedById, CreatedBy.Name,  myV2MOM__FY_Year__c, myV2MOM__Status__c  from myV2MOM__V2MOM__c WHERE id =: v2MOMId];
        }
        User usr = [Select Id, ManagerId from User where Id =: vm.CreatedById];
        if(usr.ManagerId != null && usr.ManagerId != ''){
            if(!FLSCheck.isAccessible(v2momFields,'myV2MOM__V2MOM__c')){
                return null;
            }
            myV2MOM__V2MOM__c managerV2MOM = [Select Id from myV2MOM__V2MOM__c where CreatedById =: usr.ManagerId order by createddate desc limit 1];
        }
        return vm;
    }
    
    @AuraEnabled
    //return current user's id
    public static String getUserId() {
        return V2MOM_UtilCls.getUserId();
    }
    
    @auraEnabled
    //return current user's name
    public static String getUserName(){
        return V2MOM_UtilCls.getUserName();
    }
    
    @auraEnabled
    //Method to create a new Method on the V2MOM
    public static List<myV2MOM__Method__c> createMethod(myV2MOM__Method__c method, String v2MOMId){
        myV2MOM__Method__c md = new myV2MOM__Method__c();
        md = method;
        md.myV2MOM__V2MOM__c = v2MOMId;
        List<String> mtFields = MeasureChatterCtrlSharing.getMethodFields();
        if(FLSCheck.isAccessible(mtFields,'myV2MOM__Method__c') && FLSCheck.isCreateable(mtFields,'myV2MOM__Method__c') && FLSCheck.isUpdateable(mtFields,'myV2MOM__Method__c')){
            upsert md; 
        }
        if(!FLSCheck.isAccessible(mtFields,'myV2MOM__Method__c')){
            return new List<myV2MOM__Method__c>();
        }
        return [SELECT Id, Name, myV2MOM__V2MOM__c, myV2MOM__Description__c FROM myV2MOM__Method__c WHERE myV2MOM__V2MOM__c =: v2MOMId];
    }
    
    @AuraEnabled
    //Method to save V2MOM
    public static V2MOM__c saveV2V(String visionVal, String valueVal, String v2momIdVal){
        return V2MOM_MobileCtrl.saveV2V(visionVal, valueVal, v2momIdVal);
    }
    
    @auraEnabled
    //Copy Manger's Vision
    public static String referManagerVision(myV2MOM__V2MOM__c V2MOMrec){
        
        System.debug('V2MoM:::'+V2MOMrec);
        string managerId =  [Select Id, ManagerId FROM User WHERE Id = :UserInfo.getUserId()].ManagerId;
        String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
        
        List<String> v2momFields = MeasureChatterCtrlSharing.getV2MOMFields();
        if(!FLSCheck.isAccessible(v2momFields,'myV2MOM__V2MOM__c')){
            return '';
        }
        List <myV2MOM__V2MOM__c> v2momList=new  List <myV2MOM__V2MOM__c>();
        System.debug('V2MOM::'+V2MOMrec);
        if(V2MOMrec!=null && V2MOMrec.Id!=null ){
            v2momList = [SELECT Id, myV2MOM__Vision__c from myV2MOM__V2MOM__c WHERE 
                         CreatedById =: managerId AND myV2MOM__FY_Year__c =: V2MOMrec.myV2MOM__FY_Year__c];
        }else{
            v2momList = [SELECT Id, myV2MOM__Vision__c from myV2MOM__V2MOM__c WHERE 
                         CreatedById =: managerId AND myV2MOM__FY_Year__c =: currentFiscalYear];
        }
        String vision;
        if(v2momList != null && v2momList.size() > 0){
            vision = v2momList[0].myV2MOM__Vision__c;
        }else{
            vision = '';
        }
        
        return vision;
    }
    
    @auraEnabled
    //Copy Manger's Value
    public static String referManagerValue(myV2MOM__V2MOM__c V2MOMrec){
        string managerId =  [Select Id, ManagerId FROM User WHERE Id = :UserInfo.getUserId()].ManagerId;
        String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
        List<String> v2momFields = MeasureChatterCtrlSharing.getV2MOMFields();
        if(!FLSCheck.isAccessible(v2momFields,'myV2MOM__V2MOM__c')){
            return '';
        }
         List <myV2MOM__V2MOM__c> v2momList=new  List <myV2MOM__V2MOM__c>();
       if(V2MOMrec!=null && V2MOMrec.Id!=null ){
        v2momList = [SELECT Id, myV2MOM__Values__c from myV2MOM__V2MOM__c 
                                              WHERE CreatedById =: managerId AND myV2MOM__FY_Year__c =: V2MOMrec.myV2MOM__FY_Year__c];
        }else{
        v2momList = [SELECT Id, myV2MOM__Values__c from myV2MOM__V2MOM__c 
                                              WHERE CreatedById =: managerId AND myV2MOM__FY_Year__c =: currentFiscalYear];
        }
        String value;
        if(v2momList != null && v2momList.size() > 0){
            value = v2momList[0].myV2MOM__Values__c;
        }else{
            value = '';
        }
        return value;
    }
    
    
    @auraEnabled
    //get obstacles and comments for a measure based on the measure id provided
    public static myV2MOM__Measure__c getObstaclesAndComments(String mId){
        List<String> measureFields = MeasureChatterCtrlSharing.getMeasureFields();
        if(!FLSCheck.isAccessible(measureFields,'myV2MOM__Measure__c')){
            myV2MOM__Measure__c newMeasure = new myV2MOM__Measure__c();
            return newMeasure;
        }
        return [SELECT Id, myV2MOM__Obstacles__c, myV2MOM__Comments__c, myV2MOM__Method__r.myV2MOM__V2MOM__r.myV2MOM__User__c FROM myV2MOM__Measure__c WHERE Id =: mId];
    }
    
    @auraEnabled
    //update measure's obstacles and comments if edited
    public static void saveObstaclesAndComments(myV2MOM__Measure__c meas){
        List<String> measFields = MeasureChatterCtrlSharing.getMeasureFields();
        if(FLSCheck.isAccessible(measFields,'myV2MOM__Measure__c') && FLSCheck.isCreateable(measFields,'myV2MOM__Measure__c') && FLSCheck.isUpdateable(measFields,'myV2MOM__Measure__c')){
            upsert meas; 
        }
    }
    
    @auraEnabled
    //Methos to check if the user us assigned a manager
    public static boolean isUserAManager(String uId){
        List<User> usrs = [SELECT Id FROm USER WHERE managerId =: UserInfo.getUserId()];
        if(usrs.size()>0){
            return true;
        }else{
            return false;
        }
    }
    
    @auraEnabled
    //method to mark V2MOM as published
    public static myV2MOM__V2MOM__c publishV2MOM(String v2MOMId){
        myV2MOM__V2MOM__c vm = new myV2MOM__V2MOM__c();
        vm.Id = v2MOMId;
        vm.myV2MOM__Status__c = 'Published';
        vm.myV2MOM__Published_Date__c = Date.today();
        
        List<String> v2momFields = MeasureChatterCtrlSharing.getV2MOMFields();
        if(FLSCheck.isAccessible(v2momFields,'myV2MOM__V2MOM__c') && FLSCheck.isCreateable(v2momFields,'myV2MOM__V2MOM__c') && FLSCheck.isUpdateable(v2momFields,'myV2MOM__V2MOM__c')){
            update vm; 
        }
        
        List<User> userList = [select ManagerId from User where id=:UserInfo.getUserId()];
        if(userList != null && userList.size() > 0){
            User userObj = userList[0];
            if(userObj.ManagerId != null){
                V2MOM_UtilCls.postChatterMsg(userObj.ManagerId, ' ,\n'+Userinfo.getName()+' published V2MOM.' ,String.valueOf(vm.Id));
            }
        }
        
        
        return vm;
    }
    
    @AuraEnabled
    // handle deletion of a method
    public static void deleteMeasure(Id mId){
        if(mId.getSObjectType() == myV2MOM__Measure__c.SObjectType){
            myV2MOM__Measure__c measure = new myV2MOM__Measure__c();
            measure.Id = mId;
            List<String> measFields = MeasureChatterCtrlSharing.getMeasureFields();
            if(FLSCheck.isDeletable('myV2MOM__Measure__c')){
                delete measure; 
            }
            
        }else if(mId.getSObjectType() == Schema.myV2MOM__Method__c.SObjectType){
            List<String> measFields = MeasureChatterCtrlSharing.getMeasureFields();
            List<String> mtFields = MeasureChatterCtrlSharing.getMethodFields();
            myV2MOM__Method__c method = new myV2MOM__Method__c();
            method.Id = mId;
            List<myV2MOM__Measure__c> measures = new List<myV2MOM__Measure__c>();
            if(FLSCheck.isAccessible(measFields,'myV2MOM__Measure__c')){
                measures = [SELECT Id FROM myV2MOM__Measure__c WHERE myV2MOM__Method__c =: mId];
            }
            
            if(measures.size()>0){
                if(FLSCheck.isDeletable('myV2MOM__Measure__c')){
                    delete measures; 
                }
            }
            
            if(FLSCheck.isDeletable('myV2MOM__Method__c')){
                delete method; 
            }
            
        }
    }
    
    @AuraEnabled
    //handles method updates
    public static void saveEditMethod(myV2MOM__Method__c method){
        List<String> mtFields = MeasureChatterCtrlSharing.getMethodFields();
        if(FLSCheck.isAccessible(mtFields,'myV2MOM__Method__c') && FLSCheck.isCreateable(mtFields,'myV2MOM__Method__c') && FLSCheck.isUpdateable(mtFields,'myV2MOM__Method__c')){
            update method;
        }
        
    }
    
    @auraEnabled
    public static void updateMethodSequence(List<myV2MOM__Method__c> methodstoBeUpdated){
        List<String> mtFields = MeasureChatterCtrlSharing.getMethodFields();
        if(FLSCheck.isAccessible(mtFields,'myV2MOM__Method__c') && FLSCheck.isCreateable(mtFields,'myV2MOM__Method__c') && FLSCheck.isUpdateable(mtFields,'myV2MOM__Method__c')){
            update methodstoBeUpdated;
        }
    }
}
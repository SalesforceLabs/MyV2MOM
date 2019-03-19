/* This class helps in handling the common business logic used across the application. */
public with sharing class V2MOM_UtilCls{
    
    public class labelValueWrap{
        @AuraEnabled
        public string label{get; set;}
        @AuraEnabled
        public string value{get; set;}
        
        public labelValueWrap(string label, string value){
            this.label = label;
            this.value = value;
        }
    }
    
    /* Wrapper class used in newMethodAndMeasureWrap wrapper class. */
    public class recListWrap{
        @AuraEnabled
        public sobject method{get;set;}
        @AuraEnabled
        public List<sObject> measures{get;set;}
        public recListWrap(sobject method, List<sObject> measures){
            this.method = method;
            this.measures = measures;
        }
    }
    
    /* This is a wrapper class for displaying methods and its measures both in mobile and desktop. */
    public class newMethodAndMeasureWrap{
        @AuraEnabled
        public List<Method__c> myMnM {get; set;}
        @AuraEnabled
        public List<recListWrap> assignedMnM {get; set;}
        @AuraEnabled
        public List<recListWrap> adoptedMnM {get; set;}
        
        public newMethodAndMeasureWrap(List<Method__c> myMnM, List<recListWrap> assignedMnM, List<recListWrap> adoptedMnM){
            this.myMnM = myMnM;
            this.assignedMnM = assignedMnM;
            this.adoptedMnM = adoptedMnM;
        }
    }
    
    /* This method helps in returning data for methods and measures. */ 
    @AuraEnabled
    public static newMethodAndMeasureWrap getMnMNew(string v2MOMId){
        if(!(FLSCheck.isAccessible(MeasureChatterCtrlSharing.getV2MOMFields(), 'V2MOM__c') && FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMethodFields(), 'Method__c') && FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(), 'Measure__c') && FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureTeamFields(), 'Measure_Team__c'))){
            return null;
        }
        String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
        V2MOM__c v2mom;
        if(v2MOMId != null && v2MOMId != ''){
			v2mom = [Select Id, Name, CreatedById, FY_Year__c, (Select Id, Name from Methods__r) from V2MOM__c where Id =: v2MOMId];            
        }else{
            v2mom = new V2MOM__c();
        }
        
        List<Method__c> myMethods= new List<Method__c>([Select V2MOM__c, Order__c, Description__c, Name, Id, 
                                                                                  (Select Id, Name, Comments__c, Completion_By_Date__c, 
                                                                                   Completion_By_Quarter__c, Current_Value__c, MeasureChatFeedId__c, 
                                                                                   Method__c, Obstacles__c, Priority__c, Q1__c, Q2__c, Q3__c, Q4__c, 
                                                                                   Split_By_Quarter__c, Status__c, Target_Value__c, Track_Progress_By__c, Q1_Target__c, Q2_Target__c, 
                                                                                   Q3_Target__c, Q4_Target__c, Q1_Completion__c, Q2_Completion__c, Q3_Completion__c, Q4_Completion__c, Assigned_Current_Value__c, Total_Current_Value__c, Measure_Team_Member_Count__c
                                                                                   From Measures__r order by Priority__c) 
                                                                          FROM Method__c 
                                                                          WHERE V2MOM__c =: v2MOMId 
                                                                          order by Order__c ASC]);
        
    	List<Measure_Team__c> assignAdoptMeas = new List<Measure_Team__c>([Select Measure__r.Name, Measure__r.Track_Progress_By__c, Measure__r.Method__r.Name, Measure__r.Method__r.Description__c, Measure__r.Method__c,Type__c, 
                                                                                             Target_Value__c, Percentage__c, Current_Value__c, Status__c, Measure__r.Completion_By_Date__c, Measure__r.Priority__c, Member__c, Measure__c, Name, Id, CreatedById 
                                                                                             FROM Measure_Team__c 
                                                                                             WHERE Member__c  =: v2mom.CreatedById AND Measure__r.Method__r.V2MOM__r.FY_Year__c =:v2mom.FY_Year__c ]);
        
        Map<Method__c, List<Measure_Team__c>> assignedMeasures = new Map<Method__c, List<Measure_Team__c>>();
        Map<Method__c, List<Measure_Team__c>> adoptedMeasures = new Map<Method__c, List<Measure_Team__c>>();
        
        List<recListWrap> assignedMnM = new List<recListWrap>();
        List<recListWrap> adoptedMnM = new List<recListWrap>();
        
        for(Measure_Team__c mt : assignAdoptMeas){
            Method__c testMethod1 = new Method__c();
            testMethod1.id = mt.Measure__r.Method__c;
            testMethod1.Name = mt.Measure__r.Method__r.Name;
            testMethod1.Description__c = mt.Measure__r.Method__r.Description__c;
            if(mt.Type__c == 'Assigned'){
                if(assignedMeasures.get(testMethod1) != null){
                    assignedMeasures.get(testMethod1).add(mt);
                }else{
                    assignedMeasures.put(testMethod1, new list<Measure_Team__c>());
                    assignedMeasures.get(testMethod1).add(mt);
                }
            }else if(mt.Type__c == 'Adopted'){
                if(adoptedMeasures.get(testMethod1) != null){
                    adoptedMeasures.get(testMethod1).add(mt);
                }else{
                    adoptedMeasures.put(testMethod1, new list<Measure_Team__c>());
                    adoptedMeasures.get(testMethod1).add(mt);
                }
            }
        }
        
        for(Method__c method : assignedMeasures.keySet()){
            assignedMnM.add(new recListWrap(method, assignedMeasures.get(method)));
        }
        for(Method__c method : adoptedMeasures.keySet()){
            adoptedMnM.add(new recListWrap(method, adoptedMeasures.get(method)));
        }
        
        return new newMethodAndMeasureWrap(myMethods, assignedMnM, adoptedMnM);
        
    }
    
    /* This method helps in getting the logged in user id. */
    @AuraEnabled
    public static String getUserId() {
        return userinfo.getUserId();
    }
    
    /* This method helps in getting the logged in user's name. */
    @auraEnabled
    public static String getUserName(){
        return userinfo.getName();
    }
    
    /* This method helps in getting the methods for a particular V2MOM. */
    @AuraEnabled
    public static List<Method__c> getCurrentV2MOMMethods(string currentUsedV2MOMId){
        if(!FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMethodFields(), 'Method__c')){
            return new List<Method__c>();
        }
        return new List<Method__c>([Select Id, Name from Method__c where V2MOM__c =: currentUsedV2MOMId]);
    }
    
    /* This method helps in creating a measure from other's V2MOM. */
    @AuraEnabled
    public static void copyMeasureToMyV2MOM(string methodId, Measure__c measure, string currentUsedV2MOMId, String measureName){
        system.debug('methodId >>>>> '+ methodId +'   measure   >>>>>> '+measure+'   currentUsedV2MOMId     >>>>>>'+currentUsedV2MOMId+'   measureName    >>>>>>'+measureName);
        try{
            if(FLSCheck.isCreateable(MeasureChatterCtrlSharing.getMeasureFields(), 'Measure__c') && FLSCheck.isCreateable(MeasureChatterCtrlSharing.getMethodFields(), 'Method__c')){
                Measure__c measureCopy = new Measure__c();
                measureCopy = measure.clone();
                if(methodId != null){
                    measureCopy.Method__c = methodId;
                }else{
                    Method__c newMethod = new Method__c(Name = measureName, V2MOM__c = currentUsedV2MOMId);
                    insert newMethod;
                    measureCopy.Method__c = newMethod.Id;
                    measureCopy.Current_Value__c = 0;
                }
                if(measureCopy.Method__c != null){
                    insert measureCopy;
                }
            }else{
                return;
            }
        }catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /* This method helps in fetching Measure object-Status field picklist values from schema. */
    @AuraEnabled
    public static List<labelValueWrap> getStatusPicklistValues(){
        try{
            List<labelValueWrap> options = new List<labelValueWrap>();
            
            if(!FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(), 'Measure__c')){
                return options;
            }
            
            Schema.DescribeFieldResult fieldResult = Measure__c.Status__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple){
                options.add(new labelValueWrap(f.getLabel(), f.getValue()));
            }       
            return options;
        }catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /* This method helps in getting current fiscal quarter from the org. */
    @AuraEnabled
    public static integer getCurrentFiscalQuarter(){
        try{
            Period p = [Select Number From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER];
            return p.Number;
        }catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /* This method helps in getting a fiscal quarter's end date from the org. */
    @AuraEnabled
    public static date getFiscalQuarterEndDate(Integer currentQuarter){
        try{ 
            Period p = [Select EndDate, Number From Period WHERE Type = 'Quarter' AND Number =: integer.valueOf(currentQuarter) AND StartDate = THIS_FISCAL_YEAR];
            system.debug('currentQuarter  > .  '+p.EndDate);
            return p.EndDate;
        }catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /* This method helps in fetching the list of users that are displayed while assigning measures. */
    @AuraEnabled
    public static List<User> getOrgUsers(string typeCode){
        try{
            
            List<String> checkUserFields = new List<String>();
            checkUserFields.add('Id');
            checkUserFields.add('Name');
            if(! FLSCheck.isAccessible(checkUserFields, 'User') ){
                return new List<User>();
            }
            
            if(typeCode == 'ExcludeCurrentUser'){
                return [Select Id, Name from User where Id !=: userInfo.getUserId()];
            }else if(typeCode == 'TeamMembers'){
                return [Select Id, Name from User where Id !=: userInfo.getUserId() and ManagerId =: userInfo.getUserId()];
            }
            else{
                return [Select Id, Name from User];
            }
        }catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /* This method helps in fetchin measure team records of a measure. */
    @AuraEnabled
    public static List<Measure_Team__c> getExistingMeasureTeam(string measureId){
        if(!FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureTeamFields(), 'Measure_Team__c')){
            return new List<Measure_Team__c>();
        }
        try{
            List<Measure_Team__c> meaTeamList = [Select Id, Member__c, Target_Value__c, Percentage__c from Measure_Team__c where Measure__c =: MeasureId and Type__c = 'Assigned'];
            return meaTeamList;
        }catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /* This method helps in fetchin measure team records of a measure. */
    @AuraEnabled
    public static List<Measure_Team__c> getMeasureAssignees(Id MeasureId){
        if(!FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureTeamFields(), 'Measure_Team__c')){
            return new List<Measure_Team__c>();
        }
        try{
            return [Select Id, Member__c, Target_Value__c, Percentage__c, Current_Value__c, Status__c from Measure_Team__c where Measure__c =: MeasureId and Type__c = 'Assigned'];
        }catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /*@AuraEnabled
    public static boolean adoptMeasureHelper(Id MeasureId){
        try{
            Measure_Team__c mtm = new Measure_Team__c();
            mtm.Type__c = 'Adopted';
            mtm.Member__c = userInfo.getUserId();
            mtm.Measure__c = MeasureId;
            system.debug('mtm >>>>>>'+ mtm);
            insert mtm;
            
            Measure__c measureObj = [select id, CreatedById from Measure__c where id =: MeasureId];
            
            postChatterMsg(measureObj.CreatedById, ',\nThis measure is adopted. Please check your V2MOM.' , MeasureId);
            
            return true;
        }catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }   
    }*/
    
    /* This method helps in assigning a measure to a set of users. */
    @AuraEnabled
    public static boolean setMeasureAssignees(Id MeasureId, String currentUserIds, String previousUserIds, String measureTarStr){
        try{
            if(!(FLSCheck.isDeletable('Measure_Team__c') && FLSCheck.isUpdateable(MeasureChatterCtrlSharing.getMeasureTeamFields(), 'Measure_Team__c') && FLSCheck.isCreateable(MeasureChatterCtrlSharing.getMeasureTeamFields(), 'Measure_Team__c') && FLSCheck.isUpdateable(MeasureChatterCtrlSharing.getMeasureTeamFields(), 'Measure_Team__c'))){
                return false;
            }
            
            List<MeasureTeamTarW> measureTarList = (List<MeasureTeamTarW>)JSON.deserialize(measureTarStr, List<MeasureTeamTarW>.class);
            
            Map<Id, MeasureTeamTarW> meaTeamTarWMap = new Map<Id, MeasureTeamTarW>();
            for(MeasureTeamTarW meaTeamTarWObj : measureTarList){
                meaTeamTarWMap.put(meaTeamTarWObj.userId, meaTeamTarWObj);
            }
            
            Set<String> cUsrSet = new Set<String>();
            if(currentUserIds != null){
                cUsrSet.addAll(currentUserIds.split(';'));
            }
            
            Set<String> oUsrSet = new Set<String>();
            if(previousUserIds != null){
                oUsrSet.addAll(previousUserIds.split(';'));    
            }
            
            Set<String> usersToRemove = oUsrSet.clone();
            usersToRemove.removeAll(cUsrSet);
            
            if(usersToRemove.size() > 0){
                delete [Select Id from Measure_Team__c where Measure__c =: MeasureId and Type__c = 'Assigned' and Member__c =: usersToRemove];
            }
            
            Map<Id, Measure_Team__c> exisMeasTeamMap = new Map<Id, Measure_Team__c>();
            List<Measure_Team__c> exisMeasTeam = [Select Id, Member__c from Measure_Team__c where Measure__c =: MeasureId and Type__c = 'Assigned' and Member__c =: cUsrSet];
            for(Measure_Team__c mt : exisMeasTeam){
                exisMeasTeamMap.put(mt.Member__c, mt);
            }
            Set<String> usersToAdd = cUsrSet.clone();
            usersToAdd.removeAll(oUsrSet);
            
            if(cUsrSet.size() > 0){
                    List<String> userShareList = new List<String>();
                    List<Measure_Team__c> mTeam = new List<Measure_Team__c>();
                    List<Measure_Team__c> mTeamUpdate = new List<Measure_Team__c>();
                    for(String s : cUsrSet){
                        if(exisMeasTeamMap.containsKey(s)){
                            Measure_Team__c mtm = exisMeasTeamMap.get(s);
                            mtm.Percentage__c = meaTeamTarWMap.get(mtm.Member__c).percentTar;
                            mTeamUpdate.add(mtm);
                        }else{
                            Measure_Team__c mtm = new Measure_Team__c();
                            mtm.Type__c = 'Assigned';
                            mtm.Member__c = Id.valueOf(s);
                            mtm.Measure__c = MeasureId;
                            //mtm.Target_Value__c = meaTeamTarWMap.get(mtm.Member__c).actualTar;
                            mtm.Percentage__c = meaTeamTarWMap.get(mtm.Member__c).percentTar;
                            mTeam.add(mtm);
                            userShareList.add(mtm.Member__c);
                        }
                    }
                    if(FLSCheck.isCreateable(MeasureChatterCtrlSharing.getMeasureTeamFields(), 'Measure_Team__c')){
                    	insert mTeam;                        
                    }
                    for(Measure_Team__c mTeamObj : mTeam){
                        postChatterMsg(mTeamObj.Member__c, ',\nA measure is assigned. Please check your V2MOM.' ,mTeamObj.Id);
                    }
                    MeasureChatterCtrlSharing.shareMeasureManually(MeasureId,userShareList);
                    
                    if(mTeamUpdate != null && mTeamUpdate.size() > 0){
                        update mTeamUpdate;
                    }
            }
            return true;
        }catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /* Wrapper class used in assigning a measure. */
    public class MeasureTeamTarW{
        public String userId;
        public String userName;
        public Decimal percentTar;
        public Decimal actualTar;
        public Decimal currVal;
        public String Status;
    }
    
    /* This method helps in post a chatter message on a particular record with user at mentions. */ 
    public static void postChatterMsg(String userMentionId, String postText, String recId){
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        
        mentionSegmentInput.id = userMentionId;
        messageBodyInput.messageSegments.add(mentionSegmentInput);
        
        textSegmentInput.text = postText;
        messageBodyInput.messageSegments.add(textSegmentInput);
        
        feedItemInput.body = messageBodyInput;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        feedItemInput.subjectId = recId;
        
        if(!Test.isRunningTest()){
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
        }
    }
    
    public static DateTime calcLastupdatedDate(V2MOM__c v2momObj){
        List<DateTime> maxDates = new List<DateTime>();
        if(v2momObj.LastModifiedDate != null){
            maxDates.add(v2momObj.LastModifiedDate);
        }
        system.debug('v2momObj.LastModifiedDate' + v2momObj.LastModifiedDate);
        
        List<AggregateResult> aggMethodList = [select MAX(LastModifiedDate) maxMethodDate from Method__c where V2MOM__c =: v2momObj.Id];
        List<AggregateResult> aggMeasureList = [select MAX(LastModifiedDate) maxMeasureDate from Measure__c where Method__r.V2MOM__c =: v2momObj.Id];
        List<AggregateResult> aggMeasureTeamList = [select MAX(LastModifiedDate) maxMeasureDTeamDate from Measure_Team__c where Measure__r.Method__r.V2MOM__c =: v2momObj.Id];
        
        DateTime maxMethodDate;
        DateTime maxMeasureDate;
        DateTime maxMeasureDTeamDate;
        
        if(aggMethodList != null && aggMethodList.size() > 0){
            AggregateResult tempAgg = aggMethodList[0];
            maxMethodDate = (DateTime)tempAgg.get('maxMethodDate');
            if(maxMethodDate != null){
                maxDates.add(maxMethodDate);
            }
        }
        if(aggMeasureList != null && aggMeasureList.size() > 0){
            AggregateResult tempAgg = aggMeasureList[0];
            maxMeasureDate = (DateTime)tempAgg.get('maxMeasureDate');
            if(maxMeasureDate != null){
                maxDates.add(maxMeasureDate);
            }
        }
        if(aggMeasureTeamList != null && aggMeasureTeamList.size() > 0){
            AggregateResult tempAgg = aggMeasureTeamList[0];
            maxMeasureDTeamDate = (DateTime)tempAgg.get('maxMeasureDTeamDate');
            if(maxMeasureDTeamDate != null){
               maxDates.add(maxMeasureDTeamDate);
            }
        }
        
        system.debug('maxMethodDate : ' + maxMethodDate);
        system.debug('maxMeasureDate : ' + maxMeasureDate);
        system.debug('maxMeasureDTeamDate : ' + maxMeasureDTeamDate);
        system.debug('before sort maxDates : ' + maxDates);
        
		if(maxDates != null && maxDates.size() > 0){
            maxDates.sort();
            system.debug('after sort maxDates : ' + maxDates);
            system.debug('maxDates[0] : ' + maxDates[maxDates.size()-1]);
            return maxDates[maxDates.size()-1];
        }else{
            return null;
        }
    }
}
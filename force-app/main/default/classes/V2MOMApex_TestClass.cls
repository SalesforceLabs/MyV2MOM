/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
public class V2MOMApex_TestClass {
    
    public static User createTestUser(Id roleId, Id profID, String fName, String lName)
    {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
       
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser = new User(  firstname = fName,
                                lastName = lName,
                                email = uniqueName + '@test' + orgId + '.org',
                                Username = uniqueName + '@test' + orgId + '.org',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = uniqueName.substring(18, 23),
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = profId,
                                UserRoleId = roleId,
                             	Title = 'Test');
        return tuser;
    }
    
    public static testmethod void createData(){
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        List<UserRole> urLst = new List<UserRole>();
        	urLst.add(new UserRole(Name = 'Finance Approver'));
        	urLst.add(new UserRole(Name = 'Finance'));        
        insert urLst;
        
        user manager = V2MOMApex_TestClass.createTestUser(urLst[0].Id, pf.Id, 'Manager', 'LastName');
        insert manager;
        
        user reportee = V2MOMApex_TestClass.createTestUser(urLst[1].Id, pf.Id, 'Reporte', 'LastName');
        reportee.ManagerId = manager.Id;
        insert reportee;
        
        system.assertNotEquals(reportee.Id, null);
    }
    
    public static testmethod void m1(){
        String userName = V2MOM_Controller.getUserName();
        V2MOM_Measure_Controller vmc = new V2MOM_Measure_Controller();
        system.assertNotEquals(userName, null);
    }
    
    
    static testmethod void V2MOM_Controller(){
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        List<UserRole> urLst = new List<UserRole>();
        urLst.add(new UserRole(Name = 'Finance Approver'));
        urLst.add(new UserRole(Name = 'Finance'));        
        insert urLst;
        
        user reportee = V2MOMApex_TestClass.createTestUser(urLst[1].Id, pf.Id, 'Reporte', 'LastName');
        reportee.ManagerId = userInfo.getUserId();
        insert reportee;
        
        user reportee2 = V2MOMApex_TestClass.createTestUser(urLst[1].Id, pf.Id, 'Reportee', 'LastName');
        reportee2.ManagerId = userInfo.getUserId();
        insert reportee2;
		
		Id testMeasureId;
        
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            
            user manager = V2MOMApex_TestClass.createTestUser(urLst[0].Id, pf.Id, 'Manager', 'LastName');
            insert manager;
            
            
            
            /*system.debug('---------- + '+ [Select FirstName from User]);

V2MOM__c vm = new V2MOM__c();
vm.Name = 'Test';*/
            
            V2MOM_Controller.getUserId();
            V2MOM_Controller.getUserName();
            V2MOM_Controller.isUserAManager(userInfo.getUserId());
            V2MOM_Controller.isUserAManager(reportee.Id);
            //V2MOM_Controller.testCreateMethod();
            V2MOM__c v2mom = V2MOM_Controller.saveV2V('Vision', 'Values', null);
            V2MOM_Controller.saveV2V('Vision', 'Values', '');
            V2MOM_Controller.saveV2V('Vision', 'Values', v2mom.Id);
            V2MOM_InItWrapper initWrap = V2MOM_Controller.V2MOM_InIt(v2mom.Id);
            /*V2MOM_Controller.getMyV2MOM(UserInfo.getUserId(), null);
			V2MOM_Controller.getMyV2MOM(null, v2mom.Id);*/
            Method__c method1 = new Method__c();
            method1.Name = 'Method1';
            List<Method__c> methodLst = V2MOM_Controller.createMethod(method1, v2mom.Id);
            //List<Method__c> getAllMethods = V2MOM_Controller.getAllMethods(v2mom.Id);
            Method__c testMet = new Method__c();
            testMet.Name = 'T1';
            testMet.V2MOM__c = v2mom.Id;
            insert testMet;
            system.debug('v2mom.Id '+ v2mom.Id);

            /** For V2MOM_Measure_Controller ****************************************************************************************************/
            
            V2MOM_Measure_Controller.getQuarterEndDate(1);
            V2MOM_Measure_Controller.getProgressTypes();
            V2MOM_Measure_Controller.getPriorityTypes();
            V2MOM_Measure_Controller.getStatusTypes();
            Measure__c measure = new Measure__c();
                measure.Name = 'Assist';
                measure.Track_Progress_By__c = 'N';
                measure.Priority__c = 'H';
                measure.Completion_By_Quarter__c = 'Q1';
                measure.Split_By_Quarter__c = true;
                measure.Target_Value__c = 100;
                measure.Q1__c = 25;
                measure.Q2__c = 25;
                measure.Q3__c = 25;
                measure.Q4__c = 25;
            	measure.Method__c = methodLst[0].Id;
            Measure__c measure1 = new Measure__c();
                measure1.Name = 'Demo Comp';
                measure1.Track_Progress_By__c = 'C';
                measure1.Priority__c = 'M';
                measure1.Completion_By_Quarter__c = 'Q2';
            	measure1.Method__c = methodLst[0].Id;
            Measure__c measure2 = new Measure__c();
                measure2.Name = 'Test';
                measure2.Track_Progress_By__c = 'C';
                measure2.Priority__c = 'L';
                measure2.Completion_By_Quarter__c = 'Q3';
            	measure2.Method__c = methodLst[0].Id;
            V2MOM_Measure_Controller.createMeasure(measure);
            V2MOM_Measure_Controller.createMeasure(measure1);
            V2MOM_Measure_Controller.createMeasure(measure2);
            V2MOM_Measure_Controller.getMeasureDetails(measure2.Id);
            testMeasureId = measure2.Id;
            
            /** For V2MOM_Controller ****************************************************************************************************/
            User us2 = [SELECT Id, managerId FROM User WHERE Id =: userinfo.getUserId()];
            us2.ManagerId = null;
            update us2;
            //V2MOM_Controller.getAllMeasures2(V2MOM_Controller.getAllMeasures(v2mom.Id), measure2.Id);
            V2MOM_Controller.getObstaclesAndComments(measure2.Id);
            V2MOM_Controller.saveObstaclesAndComments(measure2);
            V2MOM_Controller.publishV2MOM(v2mom.Id);
            V2MOM_Controller.getMyV2MOM(v2mom.Id);
            Map<String, List<V2MOM_UtilCls.labelValueWrap>> allmespick = V2MOM_Measure_Controller.getAllMeasurePickLists();
            List<V2MOM_UtilCls.labelValueWrap> allprosressspick = V2MOM_Measure_Controller.getProgressTypesMobile();
            List<V2MOM_UtilCls.labelValueWrap> allPriorityTypespick = V2MOM_Measure_Controller.getPriorityTypesMobile();
            List<V2MOM_UtilCls.labelValueWrap> allStatusTypespick = V2MOM_Measure_Controller.getStatusTypesMobile();
                
            
            /** For V2MOM_TeamViewCtrl ****************************************************************************************************/
            system.runAs(reportee){
                /** For V2MOM_Controller ****************************************************************************************************/
                V2MOM__c v2mom1 = V2MOM_Controller.saveV2V('Vision', 'Values', null);
                 Method__c method2 = new Method__c();
                List<Method__c> methodLst2 = V2MOM_Controller.createMethod(method2, v2mom1.Id);
                Measure__c measure3 = new Measure__c();
                measure3.Name = 'Assist';
                measure3.Track_Progress_By__c = 'N';
                measure3.Priority__c = 'H';
                measure3.Completion_By_Quarter__c = 'Q1';
                measure3.Split_By_Quarter__c = true;
                measure3.Target_Value__c = 100;
                measure3.Q1__c = 25;
                measure3.Q2__c = 25;
                measure3.Q3__c = 25;
                measure3.Q4__c = 25;
                measure3.Status__c = 'Behind Schedule';
            	measure3.Method__c = methodLst[0].Id;
                V2MOM_Measure_Controller.createMeasure(measure3);
                
                Measure__c measure4 = new Measure__c();
                measure4.Name = 'Test';
                measure4.Track_Progress_By__c = 'C';
                measure4.Priority__c = 'L';
                measure4.Completion_By_Quarter__c = 'Q3';
                measure4.Status__c = 'On Track';
                measure4.Method__c = methodLst[0].Id;
                V2MOM_Measure_Controller.createMeasure(measure4);
                
                V2MOM_Controller.referManagerVision(v2mom1);
                V2MOM_Controller.referManagerValue(v2mom1);
                
                /** For V2MOM_MobileCtrl ****************************************************************************************************/
                V2MOM_MobileCtrl.referManagerVisionMob(v2mom1);
                V2MOM_MobileCtrl.referManagerValueMob(v2mom1);
                
                /** For V2MOM_UtilCls ****************************************************************************************************/
                //V2MOM_UtilCls.adoptMeasureHelper(testMeasureId);
            }
            
            V2MOM_TeamViewCtrl.fetchUsers(v2mom.Id);
            V2MOM_TeamViewCtrl.redirectV2MOM(v2mom.Id, reportee.Id);
            
            /** For V2MOM_MobileCtrl ****************************************************************************************************/
            
            //V2MOM_MobileCtrl.getMethodsAndMeasures(v2mom.Id);
            V2MOM_MobileCtrl.fetchV2V(v2mom.Id);
            V2MOM_MobileCtrl.fetchV2MOMRec(v2mom.Id);
            //V2MOM_MobileCtrl.fetchV2MOMNew();
            V2MOM_MobileCtrl.isUserAManagerMob(UserInfo.getUserId());
            V2MOM_MobileCtrl.publishV2MOMMob(v2mom.Id);
            
            /** For V2MOM_UtilCls ****************************************************************************************************/
            V2MOM_UtilCls.getMeasureAssignees(measure2.Id);
            String measTarStr = '[{"userId":"'+reportee.Id+'","userName":"Ronit Naik","percentTar":10,"actualTar":10,"currVal":0}]';
            V2MOM_UtilCls.setMeasureAssignees(measure2.Id, reportee.Id, userinfo.getUserId(),measTarStr);
            V2MOM_UtilCls.getExistingMeasureTeam(measure2.Id);
            V2MOM_UtilCls.copyMeasureToMyV2MOM(methodLst[0].Id, measure2, v2mom.Id, measure2.Name);
            V2MOM_UtilCls.copyMeasureToMyV2MOM(null, measure2, v2mom.Id, measure2.Name);
            V2MOM_UtilCls.getCurrentV2MOMMethods(v2mom.Id);
            Test.StartTest();
            	V2MOMQuarterlyReminder sh1 = new V2MOMQuarterlyReminder();
            	String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1); 
            Test.stopTest();
            /** MeasureChatterCtrl ****************************************************************************************************/
            system.runAs(reportee){
                MeasureChatterCtrl.createMeasureFeedComment(measure2.Id, 'Test Comment');
                List<FeedItem> fList = [Select Body from FeedItem where ParentId =: measure2.Id];
                MeasureChatterCtrl.getCurrentMeasureFeed(measure2.Id);
                MeasureChatterCtrl.updateMeasureFeedComment(fList[0].Id, 'Test Comment');
            }

            /*Method__c testMet1 = new Method__c();
            testMet1.Name = 'T1';
            testMet1.V2MOM__c = v2mom.Id;
            insert testMet1;*/
            V2MOM_Controller.saveEditMethod(testMet);
            V2MOM_Controller.deleteMeasure(testMet.Id);
            //Map<Id,List<MeasuresWrapper>> metMesWrap = V2MOM_Controller.methodAndMeasureMap(v2mom.Id);
        }
        
        system.assertNotEquals(pf, null);
    }    
    
    static testmethod void utilCls(){
        V2MOM_UtilCls.getStatusPicklistValues();
        integer currentFiscalQuarter = V2MOM_UtilCls.getCurrentFiscalQuarter();
        V2MOM_UtilCls.getFiscalQuarterEndDate(1);
        V2MOM_UtilCls.getOrgUsers('test');
        V2MOM_UtilCls.getOrgUsers('ExcludeCurrentUser');
        V2MOM_UtilCls.getOrgUsers('TeamMembers');
        System.assertNotEquals(currentFiscalQuarter,null);
    }
    
    static testmethod void mobileCtrl(){
        V2MOM_MobileCtrl.searchUsers('a');
        Id userId = V2MOM_MobileCtrl.fetchUserId();
        V2MOM_MobileCtrl.getMeasureStatusPicklistValues();
        System.assertNotEquals(userId,null);
    }

    @isTest(SeeAllData='true')
    static void V2MOM_LinkReportClass(){
        List<Report> reportLst = V2MOM_LinkReportClass.getReportList();
        V2MOM_LinkReportClass.getAggregates(reportLst[0].Id);
        V2MOM_LinkReportClass.getAggregateValue(reportLst[0].Id, 'Record Count');
        System.assertNotEquals(reportLst,null);
    }    
    
}
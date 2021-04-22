/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
/* This class holds the business logic for chatter actions on a measure and measure team records. */
public with sharing class MeasureChatterCtrl {
    
    /* This method helps in fetching current measure feed. */
    @AuraEnabled
    public static List<WrapperCommentFeeds> getCurrentMeasureFeed(String measureId){
        String sObjectApi = String.valueOf(Id.valueOf(measureId).getsobjecttype());
        String sQuery;
        List<Measure__c> lstMeasure = new List<Measure__c>();
        List<Measure_Team__c> lstMeasureTeam = new List<Measure_Team__c>();
        
        if(! (FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(), 'Measure__c') && FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureTeamFields(), 'Measure_Team__c')) ){
            return new List<WrapperCommentFeeds>();
        }
       
        if(sObjectApi == 'Measure__c'){
            sQuery = 'SELECT MeasureChatFeedId__c FROM Measure__c WHERE Id=:measureId LIMIT 1';
            lstMeasure = Database.query(sQuery);
        }else{
            sQuery = 'SELECT MeasureTeamChatFeedId__c FROM Measure_Team__c WHERE Id=:measureId LIMIT 1';
        	lstMeasureTeam = Database.query(sQuery);
            system.debug('lstMeasureTeam::'+lstMeasureTeam);
        }
        
        List<Measure__Feed> lstMeasureFeed = new List<Measure__Feed>();
        List<Measure_Team__Feed> lstMeasureTeamFeed = new List<Measure_Team__Feed>();
        
        if(lstMeasure != null && lstMeasure.size() > 0 && lstMeasure[0].MeasureChatFeedId__c != null){
        	lstMeasureFeed =  [SELECT Id, Type,  CreatedById, 
                                              CreatedBy.FirstName, CreatedBy.LastName,
                                              CreatedBy.Name,
                                              ParentId, Parent.Name, 
                                              Body, Title, 
                                              LinkUrl, CreatedDate,
                                              
                                              (SELECT Id, CommentBody, CreatedDate, CreatedBy.Name,
                                               CreatedBy.FirstName, CreatedBy.LastName, CreatedById
                                               FROM FeedComments ORDER BY CreatedDate LIMIT 1000)
                                              
                                              FROM Measure__Feed
                                              WHERE ParentID =: measureId
                                              ORDER BY CreatedDate DESC, Id DESC
                                              LIMIT 1];
        }
        System.debug('lstMeasureFeed::'+lstMeasureFeed);
        
        //recent changes
        if(lstMeasureTeam != null && lstMeasureTeam.size() > 0 && lstMeasureTeam[0].MeasureTeamChatFeedId__c != null){
            lstMeasureTeamFeed = [SELECT Id, Type,  CreatedById, 
                                              CreatedBy.FirstName, CreatedBy.LastName,
                                              CreatedBy.Name,
                                              ParentId, Parent.Name, 
                                              Body, Title, 
                                              LinkUrl, CreatedDate,
                                              
                                              (SELECT Id, CommentBody, CreatedDate, CreatedBy.Name,
                                               CreatedBy.FirstName, CreatedBy.LastName, CreatedById
                                               FROM FeedComments ORDER BY CreatedDate LIMIT 1000)
                                              
                                              FROM Measure_Team__Feed
                                              WHERE ParentID =: measureId
                                              ORDER BY CreatedDate DESC, Id DESC
                                              LIMIT 1];
        }
        //recent changes
        
        Set<Id> setUserIds = new Set<Id>();
        List<FeedComment> lstFeedComment = new List<FeedComment>();
        //object api Measure
        if(lstMeasureFeed != null && lstMeasureFeed.size() > 0){
        	setUserIds.add(lstMeasureFeed[0].CreatedById);
            lstFeedComment = lstMeasureFeed[0].FeedComments;
        }
        //object api Measure_Team
        if(lstMeasureTeamFeed != null && lstMeasureTeamFeed.size() > 0){
            setUserIds.add(lstMeasureTeamFeed[0].CreatedById);
            lstFeedComment = lstMeasureTeamFeed[0].FeedComments;
        }
        
        Map<Id,User> mapUserIdPhotoUrl = new Map<Id,User>();
        //create set of User Ids
        if(lstFeedComment != null && lstFeedComment.size() > 0){
            for(FeedComment objFeedComm : lstFeedComment){
                setUserIds.add(objFeedComm.CreatedById);
            }
        }
        
        List<String> checkUserFields = new List<String>();
        checkUserFields.add('SmallPhotoUrl');
        if(! FLSCheck.isAccessible(checkUserFields, 'User') ){
            return new List<WrapperCommentFeeds>();
        }
        
        //Map of user to get the PhotoURL
        if(setUserIds.size() > 0){
            mapUserIdPhotoUrl = new Map<Id,User>([SELECT SmallPhotoUrl,Id FROM User WHERE Id IN: setUserIds]);
        }
        
        //list of comment feeds for both Measure/Measure Team
        List<WrapperCommentFeeds> lstMeasureCommentFeeds = new List<WrapperCommentFeeds>();
        String sUserPhotoUrl, sFeedBody, sUserName, sUserId, sParentFeedId, sFeedId;
        String sRegex = '<[/a-zAZ0-9]*>';
        Long lTimeStamp;
        String sLoggedInUserId = UserInfo.getUserId();
        //get parent feed body for Measure Feed
        if(lstMeasureFeed != null && lstMeasureFeed.size() > 0){
            sUserPhotoUrl = mapUserIdPhotoUrl.get(lstMeasureFeed[0].CreatedById).SmallPhotoUrl;
            System.debug('sUserPhotoUrl::'+sUserPhotoUrl);
            sUserName = lstMeasureFeed[0].CreatedBy.Name;
            sUserId = lstMeasureFeed[0].CreatedById;
            system.debug('lstMeasureFeed[0].Body.::'+lstMeasureFeed[0].Body);
            sFeedBody = lstMeasureFeed[0].Body.replaceAll(sRegex, '');
            lTimeStamp = lstMeasureFeed[0].CreatedDate.getTime(); 
            sParentFeedId = lstMeasureFeed[0].Id;
            lstMeasureCommentFeeds.add(new WrapperCommentFeeds(sLoggedInUserId,sUserName, sUserId, sFeedBody, sUserPhotoUrl, lTimeStamp, sParentFeedId, sParentFeedId));
        } 
        //get parent feed body for Measure Team Feed
        if(lstMeasureTeamFeed != null && lstMeasureTeamFeed.size() > 0){
            sUserPhotoUrl = mapUserIdPhotoUrl.get(lstMeasureTeamFeed[0].CreatedById).SmallPhotoUrl;
            System.debug('sUserPhotoUrl::'+sUserPhotoUrl);
            sUserName = lstMeasureTeamFeed[0].CreatedBy.Name;
            sUserId = lstMeasureTeamFeed[0].CreatedById;
            system.debug('lstMeasureTeamFeed[0].Body.::'+lstMeasureTeamFeed[0].Body);
            sFeedBody = lstMeasureTeamFeed[0].Body.replaceAll(sRegex, '');
            lTimeStamp = lstMeasureTeamFeed[0].CreatedDate.getTime(); 
            sParentFeedId = lstMeasureTeamFeed[0].Id;
            lstMeasureCommentFeeds.add(new WrapperCommentFeeds(sLoggedInUserId,sUserName, sUserId, sFeedBody, sUserPhotoUrl, lTimeStamp, sParentFeedId, sParentFeedId));
        }
        //Add child feeds to parent feed
        if(lstFeedComment != null && lstFeedComment.size() > 0){
            for(FeedComment objFeedComm : lstFeedComment){
                sUserPhotoUrl = mapUserIdPhotoUrl.get(objFeedComm.CreatedById).SmallPhotoUrl;
                sUserName = objFeedComm.CreatedBy.Name;
                sUserId = objFeedComm.CreatedById;
                sFeedBody = objFeedComm.CommentBody.replaceAll(sRegex, '');
                lTimeStamp = objFeedComm.CreatedDate.getTime();
                sFeedId = objFeedComm.Id;
                lstMeasureCommentFeeds.add(new WrapperCommentFeeds(sLoggedInUserId,sUserName, sUserId, sFeedBody, sUserPhotoUrl, lTimeStamp, sParentFeedId, sFeedId));
            }
        }
        return lstMeasureCommentFeeds;
    }
    
    /* Thi method helps in creating a feed comment. */
    @AuraEnabled
    public static void createMeasureFeedComment(String sRecordId, String sPost){
        if(! (FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureFields(), 'Measure__c') && FLSCheck.isAccessible(MeasureChatterCtrlSharing.getMeasureTeamFields(), 'Measure_Team__c'))){
            return ;
        }
        
        system.debug('sRecordId::'+sRecordId);
        String sObjectApi = String.valueOf(Id.valueOf(sRecordId).getsobjecttype());
        List<Measure__c> lstMeasure = new List<Measure__c>();
        List<Measure_Team__c> lstMeasureTeam = new List<Measure_Team__c>();
        String sQuery;
        if(sObjectApi == 'Measure__c'){
            sQuery = 'SELECT MeasureChatFeedId__c FROM Measure__c WHERE Id=:sRecordId LIMIT 1';
            lstMeasure = Database.query(sQuery);
        }else{
            sQuery = 'SELECT MeasureTeamChatFeedId__c FROM Measure_Team__c WHERE Id=:sRecordId LIMIT 1';
            lstMeasureTeam = Database.query(sQuery);
        }
        
        if(sObjectApi == 'Measure__c' && !String.isEmpty(lstMeasure[0].MeasureChatFeedId__c)){
            FeedComment objPost = new FeedComment();
            objPost.FeedItemId = lstMeasure[0].MeasureChatFeedId__c;
            objPost.CommentBody = sPost;
            insert objPost;
            system.debug('Measure Post::'+objPost.Id);
        }else if(sObjectApi == 'Measure_Team__c' && !String.isEmpty(lstMeasureTeam[0].MeasureTeamChatFeedId__c)){
            FeedComment objPost = new FeedComment();
            objPost.FeedItemId = lstMeasureTeam[0].MeasureTeamChatFeedId__c;
            objPost.CommentBody = sPost;
            insert objPost;
            system.debug('Measure Team Post::'+objPost.Id);
        }else{
            FeedItem objFirstFeed = new FeedItem();
            objFirstFeed.ParentId = sRecordId;
            objFirstFeed.Body = sPost;
             
            
            if(sObjectApi == 'Measure__c'){
                if(! FLSCheck.isUpdateable(MeasureChatterCtrlSharing.getMeasureFields(), 'Measure__c') ){
                    return ;
                }
                
                List<String> userShareList = new List<String>();
                userShareList.add(UserInfo.getUserId());
                MeasureChatterCtrlSharing.shareMeasureManually(sRecordId, userShareList);
                
                insert objFirstFeed;
                system.debug('firstPost::'+objFirstFeed.Id);
                lstMeasure[0].MeasureChatFeedId__c = objFirstFeed.Id;
                update lstMeasure;
            }else{
                if(! FLSCheck.isUpdateable(MeasureChatterCtrlSharing.getMeasureTeamFields(), 'Measure_Team__c') ){
                    return ;
                }
                
                insert objFirstFeed;
                lstMeasureTeam[0].MeasureTeamChatFeedId__c = objFirstFeed.Id;
                update lstMeasureTeam;
            }
        }
        
    }
    
    /* This method helps in updating a measure feed comment. */
    @AuraEnabled
    public static void updateMeasureFeedComment(String sFeedItemId, String sPost){
        String sObjectApi = String.valueOf(Id.valueOf(sFeedItemId).getsobjecttype());
        System.debug('::sObjectApi::'+sObjectApi);
        if(sObjectApi.contains('FeedItem')){//if(sFeedItemId.contains('0D5')){
            FeedItem updateFeed = new FeedItem();
            updateFeed.Id = sFeedItemId;
            updateFeed.Body = sPost;
            update updateFeed;
        }else{
            FeedComment objPost = new FeedComment();
            objPost.Id = sFeedItemId;
            //objPost.FeedItemId = sFeedItemId;
            objPost.CommentBody = sPost;
            update objPost;
        }
    }
   
    //wrapper comment feed
    public class WrapperCommentFeeds{
        @AuraEnabled
        public String sUserName{get;set;}
        @AuraEnabled
        public String sUserId{get;set;}
        @AuraEnabled
        public String sFeeds{get;set;}
        @AuraEnabled 
        public String sSmallPhotoUrl{get;set;}
        @AuraEnabled 
        public Long lTimeStamp{get;set;}
        @AuraEnabled
        public String sParentFeedId{get;set;}
        @AuraEnabled
        public String sFeedId{get;set;}
        @AuraEnabled
        public String sLoggedInUserId{get;set;}
        public WrapperCommentFeeds(String sLoggedInUserId,String sUserName,String sUserId,String sFeeds, String sSmallPhotoUrl, Long lTimeStamp, String sParentFeedId, String sFeedId){
            this.sLoggedInUserId = sLoggedInUserId;
            this.sUserName = sUserName;
            this.sUserId = sUserId;
            this.sFeeds = sFeeds;
            this.sSmallPhotoUrl = sSmallPhotoUrl;
            this.lTimeStamp = lTimeStamp;
            this.sParentFeedId = sParentFeedId;
            this.sFeedId = sFeedId;
        }
    }
   
}
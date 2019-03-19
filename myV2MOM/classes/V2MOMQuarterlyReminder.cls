/* This class helps in sending a quarterly reminder to fill V2MOM. */
global class V2MOMQuarterlyReminder implements Schedulable{
	
    global void execute(SchedulableContext SC) {
        if(! FLSCheck.isAccessible(MeasureChatterCtrlSharing.getV2MOMFields(), 'V2MOM__c') ){
            return ;
        }
        
        String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
        
		List<V2MOM__c> v2momList = [select id, CreatedById from V2MOM__c where FY_Year__c =: currentFiscalYear];
        List<Id> userIds = new List<Id>();
        for(V2MOM__c v2momObj : v2momList){
            userIds.add(v2momObj.CreatedById);
        }

        EmailTemplate template =  [SELECT Id, Name FROM EmailTemplate WHERE DeveloperName = 'V2MOM_Quarterly_Reminder' LIMIT 1];

        Messaging.MassEmailMessage emails=new Messaging.MassEmailMessage(); 
        emails.setTargetObjectIds(userIds);
        emails.setTemplateId(template.Id);
        emails.saveAsActivity = false;
        Messaging.SendEmail(New Messaging.MassEmailMessage[]{emails});
    }
}
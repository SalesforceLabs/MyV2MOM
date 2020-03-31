/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
/* This class holds the business logic for linking a report to a measure. */
public with sharing class V2MOM_LinkReportClass {
    
    /* This method helps in fetching the list of reports. */
    @AuraEnabled
    public static List<Report> getReportList(){
        List<Report> reportList = [SELECT Id,Name,DeveloperName FROM Report];
        if(reportList.size()>0 && reportList != null)
            return reportList;
        else
            return null;
    }
    
    /* This method helps in fetching the aggregated labels of a particular report. */
    @AuraEnabled
    public static List<String> getAggregates(Id rId){
        Report rp = [Select Id,DeveloperName FROM Report where Id=:rId];
        
        List<String> aggrList = new List<String>();
        if(rp != null){
            Reports.ReportResults results = Reports.ReportManager.runReport(rp.Id,true);
            Reports.ReportMetadata rm = results.getReportMetadata();
            List<String> aggList = rm.getAggregates();
            if(aggList.size()>0 && aggList != null){
                for(String s:aggList){
                    if(s.contains('!')){
                        String[] arr = s.split('!');
                        aggrList.add(arr[1]);
                    }
                }
                aggrList.add('Record Count');
            }
        }
        if(aggrList.size()>0 && aggrList != null)
            return aggrList;
        else
            return null;
    }
    
    /* This method helps in fetching the aggregated values of a particular report. */
    @AuraEnabled
    public static Double getAggregateValue(Id rId, String aggName){
        Report report = [SELECT Id,DeveloperName FROM Report where Id=:rId];
        
        String reportId = rId;
        
        if(report != null){
            // Run a report
            Reports.ReportResults results = Reports.ReportManager.runReport(reportId,true);
            
            // Get the report metadata
            Reports.ReportMetadata rm = results.getReportMetadata();
            String ReportFormat = String.valueOf(rm.getReportFormat());
            
            if(ReportFormat == 'TABULAR' || ReportFormat == 'SUMMARY' || ReportFormat == 'MATRIX'){
                String factMapKey = 'T!T';
                Reports.ReportFactWithDetails factDetails =
                    (Reports.ReportFactWithDetails)results.getFactMap().get(factMapKey);
                
                Integer totalAggregates = rm.getAggregates().size();
                
                for(integer k=0;k<totalAggregates;k++){
                    if(rm.getAggregates()[k].contains('!')){
                        String[] aggr = rm.getAggregates()[k].split('!');
                        if(aggr[1].equals(aggName)){
                            Reports.SummaryValue sumVal = factDetails.getAggregates()[k];
                            Double val = Double.valueOf((sumVal.getValue()));
                            return val;
                        }
                        
                    }
                    else{
                        Reports.SummaryValue sumVal = factDetails.getAggregates()[k];
                        Double val = Double.valueOf((sumVal.getValue()));
                        return val;
                    }
                }
            }
        }   
        return null;
    }
    
}
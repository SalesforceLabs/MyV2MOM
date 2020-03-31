/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
public with sharing class FLSCheck{

/* This method ensures the fields are Accessible. Ensuring FLS. */
    public static boolean isAccessible(List<String> fieldNames, String objName){
        boolean isSafe = false;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType myObj = schemaMap.get(objName);
        if(myObj.getDescribe().isAccessible()){ 
            for(String fldName: fieldNames){
                SObjectField myField = myObj.getDescribe().fields.getMap().get(fldName);
                //system.debug('myField '+ myField);
                if(myField.getDescribe().isAccessible()){
                    isSafe = true;
                }else{
                    isSafe = false;
                    break;
                }    
            }
        }else{
            isSafe = false;
        }
        return isSafe;
    }
    
    /* This method ensures the fields are Createable. Ensuring FLS. */
    public static boolean isCreateable(List<String> fieldNames, String objName){
        boolean isSafe = false;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType myObj = schemaMap.get(objName);
        if(myObj.getDescribe().isAccessible()){ 
            for(String fldName: fieldNames){
                SObjectField myField = myObj.getDescribe().fields.getMap().get(fldName);
                if(myField.getDescribe().isAccessible() && myField.getDescribe().isCreateable()){
                    isSafe = true;
                }else{
                    //system.debug('fldName : '+fldName);
                    isSafe = false;
                    break;
                }    
            }
        }else{
            isSafe = false;
        }
        return isSafe;
    }
    
    /* This method ensures the fields are Createable and Updateable. Ensuring FLS. */
    public static boolean isUpdateable(List<String> fieldNames, String objName){
        boolean isSafe = false;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType myObj = schemaMap.get(objName);
        if(myObj.getDescribe().isAccessible()){ 
            for(String fldName: fieldNames){
                SObjectField myField = myObj.getDescribe().fields.getMap().get(fldName);
                if(myField.getDescribe().isAccessible() && myField.getDescribe().isCreateable() && myField.getDescribe().isUpdateable()){
                    isSafe = true;
                }else{
                    isSafe = false;
                    break;
                }    
            }
        }else{
            isSafe = false;
        }
        return isSafe;
    }
    
    /* This method ensures if the object record is deletable. Ensuring FLS. */
    public static boolean isDeletable(string objName){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType myObj = schemaMap.get(objName);
        return myObj.getDescribe().isDeletable();
    }


}
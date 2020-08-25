use opendatasheets;
DROP PROCEDURE IF EXISTS ALERT_BUILD_PCN_CHANGES;
CREATE PROCEDURE `ALERT_BUILD_PCN_CHANGES`()
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      DECLARE msg TEXT;
      DECLARE code CHAR(5) DEFAULT '00000';
      GET DIAGNOSTICS CONDITION 1
      msg = MESSAGE_TEXT, code = RETURNED_SQLSTATE;
      select msg,code;
    END;


    insert into alert_all_changes(SETTING_ID, SCOPE_ID, FEATURE_ID, ROW_NUMBER, BOM_ID, UPLOADED_MAN_ID, MATCHED_MAN_ID,
    UPLOADED_MAN_NAME, MATCHED_MAN_NAME, UPLOADED_MPN, MATCHED_MPN, UPLOADED_CPN, PART_CATEGORY, CHANGE_DATE, MATCHED_COM_ID,
    UPLOADED_COM_ID, MATCH_TYPE, PCN_ID, PCN_URL, PCN_NO, PCN_NOTIFICATION_DATE, PCN_EFFECTIVE_DATE, PCN_LAST_TIME_BUY_DATE,
    PCN_LAST_SHIP_DATE, PCN_DESCRIPTION_OF_CHANGE, PCN_SOURCE, PCN_LC_STATE, PCN_TYPE_OF_CHANGE,PATCH_ID, BOM_PATH,NO_OF_AFFECTED_BOM_OPTIONS) 
    SELECT als.ALERT_SETTING_ID,
           als.alert_scope_id,
           albmp.feature_id,
           br.ROW_NUMBER,
           br.BOM_ID,
           albmp.uploaded_man_id,
           albmp.matched_man_id,
           br.UPLOADED_SUPPLIER,
           alpcnchanges.man_name,
           br.latest_mpn,
           CASE WHEN alpcnchanges.COMMERCIAL_PART_NUMBER IS NULL THEN alpcnchanges.NAN_MPN ELSE alpcnchanges.COMMERCIAL_PART_NUMBER END,
           br.UPLOADED_CPN,
           br.PART_CATEGORY,
           alpcnchanges.CHANGE_DATE,
           alpcnchanges.COM_ID,
           albmp.uploaded_com_id,
           albmp.match_type,
           alpcnchanges.PCN_ID,
           alpcnchanges.PCN_URL,
           alpcnchanges.PCN_NO,
           alpcnchanges.NOTIFICATION_DATE,
           alpcnchanges.EFFECTIVE_DATE,
           alpcnchanges.LAST_TIME_BUY_DATE,
           alpcnchanges.LAST_SHIP_DATE,
           alpcnchanges.DESCRIPTION_OF_CHANGE,
           alpcnchanges.PCN_SOURCE,
           alpcnchanges.LC_STATE,
           alpcnchanges.TYPE_OF_CHANGE,
		   alpcnchanges.PATCH_ID,
     GET_BOM_PATH( alpcnchanges.COM_ID, als.site_id ,br.latest_mpn, br.UPLOADED_SUPPLIER,albmp.matched_man_id),
         GET_BOM_COUNT( alpcnchanges.COM_ID, als.site_id,br.latest_mpn, br.UPLOADED_SUPPLIER,albmp.matched_man_id)
      FROM alert_setting als
           INNER JOIN alert_setting_items alsi
              ON als.ALERT_SETTING_ID = alsi.ALERT_SETTING_ID AND als.ALERT_SCOPE_ID = 0 AND als.IS_DELETED = 0
           INNER JOIN bom_result br
              ON br.BOM_ID = alsi.ITEM_ID AND br.status_flag = 0
           INNER JOIN alert_best_match_part albmp
              ON albmp.uploaded_com_id = br.com_id AND albmp.uploaded_man_id = br.man_id AND albmp.uploaded_mpn = br.NAN_MPN
           INNER JOIN alert_pcn_changes alpcnchanges
              ON albmp.feature_id = 1
    			AND albmp.matched_com_id = alpcnchanges.COM_ID
    			AND albmp.matched_man_id = alpcnchanges.MAN_ID
    			AND albmp.matched_mpn = alpcnchanges.NAN_MPN;
          

    insert into alert_all_changes(SETTING_ID, SCOPE_ID, FEATURE_ID, ROW_NUMBER, BOM_ID, UPLOADED_MAN_ID, MATCHED_MAN_ID, UPLOADED_MAN_NAME, MATCHED_MAN_NAME, UPLOADED_MPN, 
    MATCHED_MPN, UPLOADED_CPN, PART_CATEGORY, CHANGE_DATE, MATCHED_COM_ID, UPLOADED_COM_ID, MATCH_TYPE, PCN_ID, PCN_URL, 
    PCN_NO, PCN_NOTIFICATION_DATE, PCN_EFFECTIVE_DATE, PCN_LAST_TIME_BUY_DATE, PCN_LAST_SHIP_DATE, PCN_DESCRIPTION_OF_CHANGE, 
    PCN_SOURCE, PCN_LC_STATE, PCN_TYPE_OF_CHANGE,PATCH_ID, BOM_PATH,NO_OF_AFFECTED_BOM_OPTIONS) 
    SELECT als.ALERT_SETTING_ID,
           als.alert_scope_id,
           albmp.feature_id,
           br.ROW_NUMBER,
           br.BOM_ID,
           albmp.uploaded_man_id,
           albmp.matched_man_id,
           br.UPLOADED_SUPPLIER,
           alpcnchanges.man_name,
           br.latest_mpn,
           CASE WHEN alpcnchanges.COMMERCIAL_PART_NUMBER IS NULL THEN alpcnchanges.NAN_MPN ELSE alpcnchanges.COMMERCIAL_PART_NUMBER END,
           br.UPLOADED_CPN,
           br.PART_CATEGORY,
           alpcnchanges.CHANGE_DATE,
           alpcnchanges.COM_ID,
           albmp.uploaded_com_id,
           albmp.match_type,
           alpcnchanges.PCN_ID,
           alpcnchanges.PCN_URL,
           alpcnchanges.PCN_NO,
           alpcnchanges.NOTIFICATION_DATE,
           alpcnchanges.EFFECTIVE_DATE,
           alpcnchanges.LAST_TIME_BUY_DATE,
           alpcnchanges.LAST_SHIP_DATE,
           alpcnchanges.DESCRIPTION_OF_CHANGE,
           alpcnchanges.PCN_SOURCE,
           alpcnchanges.LC_STATE,
           alpcnchanges.TYPE_OF_CHANGE,
		   alpcnchanges.PATCH_ID,
       GET_BOM_PATH( alpcnchanges.COM_ID, als.site_id ,br.latest_mpn, br.UPLOADED_SUPPLIER,albmp.matched_man_id),
         GET_BOM_COUNT( alpcnchanges.COM_ID, als.site_id,br.latest_mpn, br.UPLOADED_SUPPLIER,albmp.matched_man_id)
      FROM alert_setting als
           INNER JOIN alert_setting_items alsi
    			ON als.ALERT_SETTING_ID = alsi.ALERT_SETTING_ID AND als.ALERT_SCOPE_ID = 1 AND als.IS_DELETED = 0
           INNER JOIN alert_boms_per_project bomsPerProject 
    			ON bomsPerProject.project_id = alsi.ITEM_ID
           INNER JOIN bom_result br
    			ON br.BOM_ID = bomsPerProject.BOM_ID AND br.status_flag = 0
           INNER JOIN alert_best_match_part albmp
    			ON albmp.uploaded_com_id = br.com_id AND albmp.uploaded_man_id = br.man_id AND albmp.uploaded_mpn = br.NAN_MPN
           INNER JOIN alert_pcn_changes alpcnchanges
              ON albmp.feature_id = 1 
    			AND albmp.matched_com_id = alpcnchanges.COM_ID 
    			AND albmp.matched_man_id = alpcnchanges.MAN_ID
                AND albmp.matched_mpn = alpcnchanges.NAN_MPN;      

    insert into alert_all_changes(SETTING_ID, SCOPE_ID, FEATURE_ID, ROW_NUMBER, BOM_ID, UPLOADED_MAN_ID, MATCHED_MAN_ID, 
    UPLOADED_MAN_NAME, MATCHED_MAN_NAME, UPLOADED_MPN, MATCHED_MPN, UPLOADED_CPN, PART_CATEGORY, CHANGE_DATE, MATCHED_COM_ID, 
    UPLOADED_COM_ID, MATCH_TYPE, PCN_ID, PCN_URL, PCN_NO, PCN_NOTIFICATION_DATE, PCN_EFFECTIVE_DATE, PCN_LAST_TIME_BUY_DATE, 
    PCN_LAST_SHIP_DATE, PCN_DESCRIPTION_OF_CHANGE, PCN_SOURCE, PCN_LC_STATE, PCN_TYPE_OF_CHANGE,PATCH_ID, BOM_PATH,NO_OF_AFFECTED_BOM_OPTIONS) 
    SELECT als.ALERT_SETTING_ID,
           als.alert_scope_id,
           albmp.feature_id,
    	   null,
    	   null,
           albmp.uploaded_man_id,
           albmp.matched_man_id,
           alpd.man_name,
           alpcnchanges.man_name,
    	   alpd.mpn,
           CASE WHEN alpcnchanges.COMMERCIAL_PART_NUMBER IS NULL THEN alpcnchanges.NAN_MPN ELSE alpcnchanges.COMMERCIAL_PART_NUMBER END,
           null,
           null,
           alpcnchanges.CHANGE_DATE,
           alpcnchanges.COM_ID,
           albmp.uploaded_com_id,
           albmp.match_type,
           alpcnchanges.PCN_ID,
           alpcnchanges.PCN_URL,
           alpcnchanges.PCN_NO,
           alpcnchanges.NOTIFICATION_DATE,
           alpcnchanges.EFFECTIVE_DATE,
           alpcnchanges.LAST_TIME_BUY_DATE,
           alpcnchanges.LAST_SHIP_DATE,
           alpcnchanges.DESCRIPTION_OF_CHANGE,
           alpcnchanges.PCN_SOURCE,
           alpcnchanges.LC_STATE,
           alpcnchanges.TYPE_OF_CHANGE,
		   alpcnchanges.PATCH_ID,
        GET_BOM_PATH( alpcnchanges.COM_ID, als.site_id ,br.latest_mpn, br.UPLOADED_SUPPLIER,albmp.matched_man_id),
         GET_BOM_COUNT( alpcnchanges.COM_ID, als.site_id,br.latest_mpn, br.UPLOADED_SUPPLIER,albmp.matched_man_id)
      FROM alert_setting als
           INNER JOIN alert_setting_items alsi
              ON als.ALERT_SETTING_ID = alsi.ALERT_SETTING_ID AND als.ALERT_SCOPE_ID = 3 AND als.IS_DELETED = 0
           INNER join alert_part_detail alpd
              ON alpd.com_id = alsi.ITEM_ID   
           INNER JOIN alert_best_match_part albmp
    		  ON albmp.uploaded_com_id = alsi.ITEM_ID AND albmp.uploaded_man_id = alpd.man_id AND albmp.uploaded_mpn = alpd.NAN_MPN    
           INNER JOIN alert_pcn_changes alpcnchanges
              ON albmp.feature_id = 1
                 AND albmp.matched_com_id = alpcnchanges.COM_ID
                 AND albmp.matched_man_id = alpcnchanges.MAN_ID
                 AND albmp.matched_mpn 	  = alpcnchanges.NAN_MPN;
                 
                 
                 
    insert into alert_all_changes(SETTING_ID, SCOPE_ID, FEATURE_ID, ROW_NUMBER, BOM_ID, UPLOADED_MAN_ID, MATCHED_MAN_ID, UPLOADED_MAN_NAME, 
    MATCHED_MAN_NAME, UPLOADED_MPN, MATCHED_MPN, UPLOADED_CPN, PART_CATEGORY, CHANGE_DATE, MATCHED_COM_ID, UPLOADED_COM_ID,
    MATCH_TYPE, PCN_ID, PCN_URL, PCN_NO, PCN_NOTIFICATION_DATE, PCN_EFFECTIVE_DATE, PCN_LAST_TIME_BUY_DATE, PCN_LAST_SHIP_DATE,
    PCN_DESCRIPTION_OF_CHANGE, PCN_SOURCE, PCN_LC_STATE, PCN_TYPE_OF_CHANGE,PATCH_ID, BOM_PATH,NO_OF_AFFECTED_BOM_OPTIONS) 
    SELECT als.ALERT_SETTING_ID,
           als.alert_scope_id,
           albmp.feature_id,
           acl.ROW_NUM,
           acl.acl_id,
           albmp.uploaded_man_id,
           albmp.matched_man_id,
           acl.SUPPLIER,
           alpcnchanges.man_name,
           acl.latest_mpn,
           CASE WHEN alpcnchanges.COMMERCIAL_PART_NUMBER IS NULL THEN alpcnchanges.NAN_MPN ELSE alpcnchanges.COMMERCIAL_PART_NUMBER END,
           acl.CPN,
           acl.PART_CATEGORY,
           alpcnchanges.CHANGE_DATE,
           alpcnchanges.COM_ID,
           albmp.uploaded_com_id,
           albmp.match_type,
           alpcnchanges.PCN_ID,
           alpcnchanges.PCN_URL,
           alpcnchanges.PCN_NO,
           alpcnchanges.NOTIFICATION_DATE,
           alpcnchanges.EFFECTIVE_DATE,
           alpcnchanges.LAST_TIME_BUY_DATE,
           alpcnchanges.LAST_SHIP_DATE,
           alpcnchanges.DESCRIPTION_OF_CHANGE,
           alpcnchanges.PCN_SOURCE,
           alpcnchanges.LC_STATE,
           alpcnchanges.TYPE_OF_CHANGE,
		   alpcnchanges.PATCH_ID,
     GET_BOM_PATH( alpcnchanges.COM_ID, als.site_id ,br.latest_mpn, br.UPLOADED_SUPPLIER,albmp.matched_man_id),
         GET_BOM_COUNT( alpcnchanges.COM_ID, als.site_id,br.latest_mpn, br.UPLOADED_SUPPLIER,albmp.matched_man_id)
      FROM alert_setting als
           INNER JOIN alert_setting_items alsi
              ON als.ALERT_SETTING_ID = alsi.ALERT_SETTING_ID AND als.ALERT_SCOPE_ID = 2 AND als.IS_DELETED = 0
           INNER JOIN acl_data acl
              ON acl.acl_id = alsi.ITEM_ID 
           INNER JOIN alert_best_match_part albmp
              ON albmp.uploaded_com_id = acl.com_id AND albmp.uploaded_man_id = acl.man_id AND albmp.uploaded_mpn = acl.NAN_MPN
           INNER JOIN alert_pcn_changes alpcnchanges
              ON albmp.feature_id = 1
    			AND albmp.matched_com_id = alpcnchanges.COM_ID
    			AND albmp.matched_man_id = alpcnchanges.MAN_ID
    			AND albmp.matched_mpn = alpcnchanges.NAN_MPN;
          
END;

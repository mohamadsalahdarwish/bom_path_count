use  opendatasheets;
Drop PROCEDURE IF EXISTS CREATE_BOM_PATH_LIST;
DELIMITER $$

CREATE PROCEDURE CREATE_BOM_PATH_LIST(IN  com_id_in       INTEGER(100),
                                      IN  site_id_in integer(100),
                                       uploaded_mpn_in  VARCHAR(255), uploaded_supplier_in VARCHAR(255), man_id_in integer(11),
                                      OUT bom_path_list   LONGTEXT)
   BEGIN
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE bom_id_temp INTEGER DEFAULT 0;
    DECLARE bom_path LONGTEXT DEFAULT "";
    DECLARE current_bom_name LONGTEXT DEFAULT "";
    DECLARE result LONGTEXT DEFAULT "";
    DECLARE item_path_temp LONGTEXT DEFAULT "";
    DECLARE name_temp LONGTEXT DEFAULT "";
    DECLARE com_id_temp INTEGER DEFAULT 0;

    DECLARE cur_bom_id
        CURSOR FOR
           SELECT distinct br.bom_id, br.com_id FROM bom_result br, bom b WHERE br.bom_id=b.id
            and
           Case 
        	WHEN com_id_in > 0 THEN br.com_id = com_id_in 
         	WHEN uploaded_mpn_in is not NULL AND uploaded_mpn_in != '' AND   uploaded_supplier_in is not NULL AND uploaded_supplier_in != '' THEN br.uploaded_mpn = uploaded_mpn_in AND br.uploaded_supplier = uploaded_supplier_in
         	WHEN uploaded_mpn_in is not NULL AND uploaded_mpn_in != '' AND man_id_in > 0 THEN br.uploaded_mpn = uploaded_mpn_in AND br.man_id = man_id_in
         	WHEN uploaded_mpn_in is not NULL AND uploaded_mpn_in != ''  THEN br.uploaded_mpn = uploaded_mpn_in 
         END
             
             and br.site_id = site_id_in
           and b.status_flag =0 AND  br.status_flag =0;

    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET finished = 1;

      OPEN cur_bom_id;

     getBomPath:
      LOOP
      
         FETCH cur_bom_id   INTO bom_id_temp, com_id_temp;
             IF finished = 1
         THEN
            LEAVE getBomPath;
         END IF;
         
         select item_path into item_path_temp  from bom where id = bom_id_temp;
         
         select name into name_temp  from bom where id = bom_id_temp;
         

         IF item_path_temp is NULL OR LENGTH(item_path_temp) = 0
         THEN
          set  @concatenated_name = name_temp;
          ELSE
        
          call GET_ITEM_PATH(item_path_temp,@_item_path);
          IF LENGTH(@_item_path) >0 THEN
          set   @concatenated_name = CONCAT( @_item_path, " > ", name_temp);
          ELSE
           set  @concatenated_name = name_temp;
           END IF;
         END IF;
         
     
     
        IF LENGTH(result) > 0 THEN
         SET result = CONCAT(result, " , ", @concatenated_name);
         ELSE 
         SET result =  @concatenated_name;
         END IF;
     
           
        
      END LOOP getBomPath;

      CLOSE cur_bom_id;
      set bom_path_list = result;
    
      
   END
$$

DELIMITER ;
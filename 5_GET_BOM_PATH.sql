use opendatasheets;

DROP FUNCTION IF EXISTS GET_BOM_PATH;

DELIMITER $$

CREATE FUNCTION GET_BOM_PATH(com_id_in integer(100), site_id_in integer(100), uploaded_mpn_in  VARCHAR(255), uploaded_supplier_in VARCHAR(255), man_id_in integer(11))
   RETURNS LONGTEXT
   DETERMINISTIC
   BEGIN
      DECLARE concatenated_path   LONGTEXT;
      
	IF com_id_in < 1 AND (uploaded_mpn_in is NULL OR uploaded_mpn_in = '')  AND (uploaded_supplier_in is  NULL OR uploaded_supplier_in = '')
	AND uploaded_mpn_in < 1
	THEN
	RETURN NULL;
	END IF;
      
	  CALL CREATE_BOM_PATH_LIST(com_id_in, site_id_in, uploaded_mpn_in , uploaded_supplier_in, man_id_in, @bom_path_list);
      select  @bom_path_list into concatenated_path;
	  
      
      RETURN concatenated_path;
   END
$$

DELIMITER ;
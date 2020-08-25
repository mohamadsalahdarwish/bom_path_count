DROP FUNCTION IF EXISTS GET_BOM_COUNT;

use opendatasheets;
 
DELIMITER $$
CREATE FUNCTION GET_BOM_COUNT(com_id_in integer(100), site_id_in integer(100), uploaded_mpn_in  VARCHAR(255), uploaded_supplier_in VARCHAR(255), man_id_in integer(11))
   RETURNS integer(100)
   DETERMINISTIC
   BEGIN
      DECLARE count_bom_id   integer(100);

	IF com_id_in < 1 AND (uploaded_mpn_in is NULL OR uploaded_mpn_in = '')  AND (uploaded_supplier_in is  NULL OR uploaded_supplier_in = '')
	AND uploaded_mpn_in < 1
	THEN
	RETURN 0;
	END IF;
      
	  SELECT 
	  	count(distinct br.bom_id, br.com_id)
        INTO count_bom_id
        FROM bom_result br , bom b WHERE br.bom_id=b.id and
        Case 
        	WHEN com_id_in > 0 THEN br.com_id = com_id_in 
         	WHEN uploaded_mpn_in is not NULL AND uploaded_mpn_in != '' AND   uploaded_supplier_in is not NULL AND uploaded_supplier_in != '' THEN br.uploaded_mpn = uploaded_mpn_in AND br.uploaded_supplier = uploaded_supplier_in
         	WHEN uploaded_mpn_in is not NULL AND uploaded_mpn_in != '' AND man_id_in > 0 THEN br.uploaded_mpn = uploaded_mpn_in AND br.man_id = man_id_in
         	WHEN uploaded_mpn_in is not NULL AND uploaded_mpn_in != ''  THEN br.uploaded_mpn = uploaded_mpn_in 
         END
         and br.site_id = site_id_in
           and b.status_flag =0  AND br.status_flag =0;
	   
	
      RETURN count_bom_id;
   END
$$
DELIMITER ;

USE opendatasheets;
DROP FUNCTION IF EXISTS GET_BOM_COUNT;


DELIMITER $$

CREATE FUNCTION GET_BOM_COUNT(com_id_in              INTEGER(100),
                              site_id_in             INTEGER(100),
                              uploaded_mpn_in        VARCHAR(255),
                              uploaded_supplier_in   VARCHAR(255),
                              man_id_in              INTEGER(11))
   RETURNS INTEGER(100)
   DETERMINISTIC
BEGIN
   DECLARE count_bom_id   INTEGER(100) DEFAULT 0;

   IF com_id_in > 0
   THEN
      SELECT count(DISTINCT br.bom_id, br.com_id)
        INTO count_bom_id
        FROM bom_result br, bom b
       WHERE     br.bom_id = b.id
             AND br.com_id = com_id_in
             AND br.site_id = site_id_in
             AND b.status_flag = 0
             AND br.status_flag = 0;
             
   ELSEIF     uploaded_mpn_in IS NOT NULL
          AND uploaded_mpn_in != ''
          AND uploaded_supplier_in IS NOT NULL
          AND uploaded_supplier_in != ''
   THEN
      SELECT count(DISTINCT br.bom_id, br.com_id)
        INTO count_bom_id
        FROM bom_result br, bom b
       WHERE     br.bom_id = b.id
             AND br.uploaded_mpn = uploaded_mpn_in
             AND br.uploaded_supplier = uploaded_supplier_in
             AND br.site_id = site_id_in
             AND b.status_flag = 0
             AND br.status_flag = 0;
   ELSEIF     uploaded_mpn_in IS NOT NULL
          AND uploaded_mpn_in != ''
          AND man_id_in > 0
   THEN
      SELECT count(DISTINCT br.bom_id, br.com_id)
        INTO count_bom_id
        FROM bom_result br, bom b
       WHERE     br.bom_id = b.id
             AND br.uploaded_mpn = uploaded_mpn_in
             AND br.man_id = man_id_in
             AND br.site_id = site_id_in
             AND b.status_flag = 0
             AND br.status_flag = 0;
   ELSEIF uploaded_mpn_in IS NOT NULL AND uploaded_mpn_in != ''
   THEN
      SELECT count(DISTINCT br.bom_id, br.com_id)
        INTO count_bom_id
        FROM bom_result br, bom b
       WHERE     br.bom_id = b.id
             AND br.uploaded_mpn = uploaded_mpn_in
             AND br.site_id = site_id_in
             AND b.status_flag = 0
             AND br.status_flag = 0;
   END IF;



   RETURN count_bom_id;
END
$$

DELIMITER ;



DELIMITER $$

DROP PROCEDURE IF EXISTS `GET_ITEM_PATH` $$
CREATE PROCEDURE `GET_ITEM_PATH`(IN _list LONGTEXT, out _item_path LONGTEXT)
BEGIN

DECLARE _next LONGTEXT DEFAULT NULL;
DECLARE _nextlen LONGTEXT DEFAULT NULL;
DECLARE _value LONGTEXT DEFAULT NULL;
DECLARE _temp_item_path LONGTEXT DEFAULT '';
DECLARE _temp_value LONGTEXT DEFAULT '';

iterator:
LOOP
  -- exit the loop if the list seems empty or was null;
  -- this extra caution is necessary to avoid an endless loop in the proc.
  IF LENGTH(TRIM(_list)) = 0 OR _list IS NULL THEN
    LEAVE iterator;
  END IF;

  -- capture the next value from the list
  SET _next = SUBSTRING_INDEX(_list,',',1);

  -- save the length of the captured value; we will need to remove this
  -- many characters + 1 from the beginning of the string 
  -- before the next iteration
  SET _nextlen = LENGTH(_next);

  -- trim the value of leading and trailing spaces, in case of sloppy CSV strings
  SET _value = TRIM(_next);

  -- select name by bom_id
  select name into _temp_value from bom where id = _value;

  -- CONCTENATE ITEM WITH PREVIOUS ONE
  IF LENGTH(_temp_item_path) > 0 THEN
  SET _temp_item_path =  CONCAT(_temp_item_path, " > ", _temp_value);
  ELSE
    SET _temp_item_path =   _temp_value;
END IF;
  -- rewrite the original string using the `INSERT()` string function,
  -- args are original string, start position, how many characters to remove, 
  -- and what to "insert" in their place (in this case, we "insert"
  -- an empty string, which removes _nextlen + 1 characters)
  SET _list = INSERT(_list,1,_nextlen + 1,'');
END LOOP;

SET _item_path = _temp_item_path;

END $$
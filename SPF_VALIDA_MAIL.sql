CREATE DEFINER=`sistemaspvyt`@`%` FUNCTION `SPF_VALIDA_MAIL`(pMAIL VARCHAR(254)) RETURNS int(1)
    READS SQL DATA
BEGIN
	DECLARE vpMAIL VARCHAR(254);
	DECLARE vRETORNO INT(1);
    DECLARE EXPREMATCH VARCHAR(254);
	--
	SET vpMAIL=pMAIL;
    -- Ale 17/08/2018 SET EXPREMATCH = '^[^0-9.-][a-zA-Z0-9_.-]+([.][a-zA-Z0-9_]+)*[@][a-zA-Z0-9_-]+([.][a-zA-Z0-9_]+)*[.][a-zA-Z]{2,4}$';
    SET EXPREMATCH = '[a-zA-Z0-9_.-]+([.][a-zA-Z0-9_]+)*[@][a-zA-Z0-9_-]+([.][a-zA-Z0-9_]+)*[.][a-zA-Z]{2,4}$';
	SET vRETORNO=0;	
	EL_LOOP: LOOP
		-- Esta Funcion Tiene Por Objetivo VALIDAR la Cuenta de MAIL Recibida en (pMAIL)
		-- 
        --
		-- RETORNA 	( vRETORNO = 1 ) SI OK
		--			( vRETORNO = 0 ) SI ES INACEPTABLE
		-- ======================================================================
        SELECT LTRIM(RTRIM(vpMAIL)) REGEXP LTRIM(RTRIM(EXPREMATCH)) INTO vRETORNO;
		LEAVE EL_LOOP;
	END LOOP EL_LOOP;
	RETURN vRETORNO;
END
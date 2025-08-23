CREATE DEFINER=`admin`@`localhost` PROCEDURE `SP_USERS_LOGIN`(
	IN v_email VARCHAR(50),
    IN v_password VARCHAR(12)
)
BEGIN
	-- =========== HANDLER PARA ERRORES SQL ============
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'OCURRIÓ UN ERROR SQL ROLLBACK';
	END;
    -- =========== LIMPIEZA Y ENCRIPTACIÓN =============
    SET @EMAIL  = TRIM(v_email);
    SET @PASSWORD_HASH = SHA2(TRIM(v_password), 256);
	-- =========== INICIO DE TRANSACCIÓN ===============
    START TRANSACTION;
	-- =========== VALIDACIÓN DE USUARIO ===============
    SELECT 
        U.id 
        , U.name
        , U.email
        , U.role
        , U.password_hash
        , U.last_login
        , COUNT(U.id)
        , P.avatar_url
        , UP.permission
        INTO
         @USER_ID
         , @NOMBRE_USER
         , @USER_MAIL
         , @USER_ROLE
         , @PASS_ALMACENADO
         , @ULTIMO_ACCESO
         , @EXISTE
         , @AVATAR
         , @USERPERMISOS
    FROM users U
    LEFT JOIN profiles P ON(P.user_id = U.id)
    LEFT JOIN user_permissions UP ON(UP.user_id = U.id)
    WHERE U.email = @EMAIL
       AND U.password_hash = @PASSWORD_HASH;
	COMMIT;
    -- =========== DEVOLUCIÓN DE RESULTADO ===========================
 IF @EXISTE = 1 THEN
 -- created_at
 -- last_login
 -- ============= ACTUALIZO FECHA CREACION Y ULTIMO LOGUEO ===========
 UPDATE users 
			SET created_at = NOW()
			, last_login = now()
            WHERE id = @USER_ID;
		
    SELECT  
		  @EXISTE AS existe
		, @NOMBRE_USER AS name
         , @USER_MAIL AS email
         , @USER_ROLE AS role
         , @AVATAR AS avatar_url
         , @ULTIMO_ACCESO AS last_login
		 , @USERPERMISOS AS permission;
        
ELSE 
	SET @EXISTE = NULL;
  SELECT   @EXISTE AS existe
		 , @NOMBRE_USER AS name
         , @USER_MAIL AS email
         , @USER_ROLE AS role
         , @AVATAR AS avatar_url
         , @ULTIMO_ACCESO AS last_login
		 , @USERPERMISOS AS permission;
	END IF;

    COMMIT;
END
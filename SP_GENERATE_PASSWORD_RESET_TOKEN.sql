CREATE DEFINER=`admin`@`localhost` PROCEDURE `SP_GENERATE_PASSWORD_RESET_TOKEN`(
    IN p_email VARCHAR(100)
)
BEGIN
    -- DECLARE v_user_id INT;
    DECLARE v_token VARCHAR(255);

    -- Verificar si el usuario existe
    SET @emailUser = TRIM(p_email);
    SELECT id
			, email 
            , name
            INTO @v_user_id
            , @email
            , @name
			FROM users
			WHERE email = @emailUser;

    IF @v_user_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El email no existe en el sistema';
    ELSE
        -- Generar un token (aquí simple, puedes usar UUID)
        SET v_token = UUID();

        -- Insertar el token con vencimiento (ejemplo: 1 hora)
        INSERT INTO password_reset_tokens(user_id
										, token
                                        , expiration
                                        , used
                                        ) VALUES (@v_user_id
										, v_token
                                        , DATE_ADD(NOW(), INTERVAL 1 HOUR)
                                        , @emailUser
                                        );

        -- Retornar el token (para enviarlo por correo desde la app)
        SELECT v_token AS reset_token;
    END IF;
END
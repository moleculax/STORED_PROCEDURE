CREATE DEFINER=`admin`@`localhost` PROCEDURE `SP_INSERTAR_USERS_PROFILE`(
    IN p_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_password_hash VARCHAR(64),
    IN p_roles VARCHAR(40),
    IN p_bio VARCHAR(250),
    IN p_location VARCHAR(50),
    IN p_interests VARCHAR(50),
    IN p_avatar_url VARCHAR(200),
    IN p_instagram VARCHAR(200),
    IN p_linkedin VARCHAR(200),
    IN p_facebook VARCHAR(200),
    IN p_twitter VARCHAR(200)
)
BEGIN
    DECLARE v_user_id INT;
    DECLARE v_permission VARCHAR(50);
    DECLARE v_password_sha256 VARCHAR(64);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN 
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'OCURRIÓ UN ERROR, SE DESHIZO LA TRANSACCIÓN';
    END;

    START TRANSACTION;

    -- ========== Encriptar contraseña que se insertara en users========================
    SET v_password_sha256 = SHA2(p_password_hash, 256);
	-- =================================================================================
    -- Insertar en la tabla users
    INSERT INTO users (name
						, email
                        , password_hash
                        , role
                        , created_at
                        , last_login
						) VALUES (
							UPPER(p_name)
                            , p_email
                            , v_password_sha256
                            , p_roles
                            , NOW()
                            , NOW()
						);

    -- Obtener el ID autogenerado
    SET v_user_id = LAST_INSERT_ID();

    -- Insertar en la tabla profiles
    INSERT INTO profiles (
						user_id
                        , bio
                        , location
                        , interests
                        , avatar_url
                        , instagram
                        , linkedin
                        , facebook
                        , twitter
							) VALUES (v_user_id
                            , p_bio
                            , p_location
                            , p_interests
                            , p_avatar_url
                            , p_instagram
                            , p_linkedin
                            , p_facebook
                            , p_twitter
							);

    -- Asignar permisos básicos según rol
    IF p_roles = 'admin' THEN
        SET v_permission = 'ADMIN_PANEL';
    ELSEIF p_roles = 'user' THEN  
        SET v_permission = 'EDIT_PROFILE';
    ELSE
        SET v_permission = 'VIEW_OWN_CONTENT';
    END IF;

    -- Insertar permisos
    INSERT INTO user_permissions(user_id
				, permission
				) VALUES(v_user_id
				, v_permission);

    COMMIT;
END

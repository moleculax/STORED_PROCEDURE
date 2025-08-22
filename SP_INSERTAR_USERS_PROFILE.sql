CREATE DEFINER=`admin`@`localhost` PROCEDURE `SP_INSERTAR_USERS_PROFILE`(
										IN p_name VARCHAR(100),
										IN p_email VARCHAR(100),
										IN p_password_hash VARCHAR(8),
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
	DECLARE EXIT HANDLER FOR sqlexception
    BEGIN 
	--  CAPTURA CUALQUIER ERROR SQL
		ROLLBACK;
        SET @MENSAJE = "OCURRIO UN ERROR SE DESHISO LA TRANSACCION";
        SELECT @MENSAJE;
	END;
    
    START TRANSACTION;
    -- Insertar en la tabla users
    INSERT INTO users (name
						, email
						, password_hash
						, role
						, created_at
						, last_login
						) VALUES (UPPER(p_name)
								, p_email
								, p_password_hash
								, p_roles
								, NOW()
								, NOW()
						);

    -- Obtener el ID autogenerado del users
    SET @user_id = LAST_INSERT_ID();

    -- Insertar en la tabla profiles con el ID del users
    INSERT INTO profiles (user_id
						, bio
						, location
						, interests
						, avatar_url
                        , instagram
                        , linkedin
                        , facebook
                        , twitter
						)
						VALUES (@user_id
						, p_bio
						, p_location
						, p_interests
						, p_avatar_url
						, p_instagram
                        , p_linkedin
                        , p_facebook
                        , p_twitter
                        );
        -- Ejemplos de valores roles:            
		-- 'admin', 'user', 'moderator'    
        -- Ejemplos de valores en permission:
		-- "VIEW_OWN_CONTENT"
		-- "EDIT_PROFILE"
		-- "ADMIN_PANEL"
        -- Aqui hago un artificio (No es lo correcto)
        
        SET @permission = 'VIEW_OWN_CONTENT';
        
		SET @permission = 'VIEW_OWN_CONTENT';

		IF p_roles = 'admin' THEN
			SET @permission = 'ADMIN_PANEL';
		ELSEIF p_roles = 'user' THEN  
			SET @permission = 'EDIT_PROFILE';
		ELSE
			SET @permission = 'VIEW_OWN_CONTENT';
		END IF;

        
			INSERT INTO user_permissions(user_id
										, permission
										)
                                        VALUES(@user_id
											, @permission);
                        
	COMMIT;
END
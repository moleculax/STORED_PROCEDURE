CREATE DEFINER=`admin`@`localhost` PROCEDURE `SP_RESET_PASSWORD`(
    IN p_token VARCHAR(255),
    IN p_new_password VARCHAR(255)
)
BEGIN
    DECLARE v_user_id INT;

    -- Buscar el token válido
    SELECT user_id INTO v_user_id
    FROM password_reset_tokens
    WHERE token = p_token
      AND expiration > NOW();
      

    IF v_user_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Token inválido o expirado';
    ELSE
        -- Actualizar la contraseña del usuario
        UPDATE users
        SET password_hash = p_new_password
        WHERE id = v_user_id;

        -- Marcar el token como usado
        UPDATE password_reset_tokens
        SET used = 1
        WHERE token = p_token;
    END IF;
END
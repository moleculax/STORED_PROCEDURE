CREATE DEFINER=`admin`@`localhost` PROCEDURE `SP_ENCRIPTA_PASSWORD_SHA256`(
    IN p_password_original VARCHAR(255),
    OUT p_password_encriptado VARCHAR(64)  -- SHA-256 devuelve 64 caracteres hexadecimales
)
BEGIN
    -- Encripta el password usando SHA-256
    SET p_password_encriptado = SHA2(p_password_original, 256);
END;

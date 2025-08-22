CREATE DEFINER=`admin`@`localhost` PROCEDURE `SP_ENCRIPTA_PASSWORD_SHA256`(
    IN password_original VARCHAR(255),
    OUT password_encriptado VARCHAR(255)

)
BEGIN
    -- Encripta el password usando SHA-256
    SET @password_encriptado = SHA2(password_original, 256);
    SELECT @password_encriptado AS password_SHA_256; 
END
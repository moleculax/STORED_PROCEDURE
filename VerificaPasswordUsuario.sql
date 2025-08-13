CREATE DEFINER=`root`@`localhost` PROCEDURE `VerificaPasswordUsuario`(
    IN nombre_usuario VARCHAR(100),
    IN host_usuario VARCHAR(100)
)
BEGIN
    DECLARE estado VARCHAR(20);
    SELECT 
        CASE
            WHEN authentication_string IS NULL OR authentication_string = '' THEN 'No tiene contraseña'
            ELSE 'Tiene la contraseña'
        END INTO estado
    FROM mysql.user
    WHERE User = nombre_usuario AND Host = host_usuario;
    SELECT CONCAT('El usuario "', nombre_usuario, '"@"', host_usuario, '" está: ', estado) AS Resultado;
END

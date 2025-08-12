CREATE PROCEDURE ResolverEcuacionCuadratica(
    IN a DOUBLE,
    IN b DOUBLE,
    IN c DOUBLE
)
BEGIN
    DECLARE discriminante DOUBLE;
    DECLARE x1 DOUBLE;
    DECLARE x2 DOUBLE;

    SET discriminante = b*b - 4*a*c;

    IF a = 0 THEN
        SELECT 'No es una ecuación de segundo grado (a = 0)' AS Resultado;
    ELSEIF discriminante > 0 THEN
        SET x1 = (-b + SQRT(discriminante)) / (2*a);
        SET x2 = (-b - SQRT(discriminante)) / (2*a);
        SELECT CONCAT('Dos soluciones reales: x1 = ', x1, ', x2 = ', x2) AS Resultado;
    ELSEIF discriminante = 0 THEN
        SET x1 = -b / (2*a);
        SELECT CONCAT('Una solución real doble: x = ', x1) AS Resultado;
    ELSE
        SELECT 'No tiene soluciones reales (discriminante < 0)' AS Resultado;
    END IF;
END 



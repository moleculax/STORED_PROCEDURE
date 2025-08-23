USE bd_neurocode;

select * from users;

-- call SP_ENCRIPTA_PASSWORD_SHA256('123456', @resultados);
 call SP_UPDATE_PASSWORD('moleculax@gmail.com', '888KKKK');
-- select @resultados;
SELECT COUNT(*) into @existe FROM users WHERE id = 17;
SELECT ROW_COUNT();
select @existe;

SET @emailUser = TRIM('moleculax@gmail.com  ');
SELECT @emailUser;

SELECT COUNT(*) INTO @v_existe FROM users WHERE email = @emailUser;
select @v_existe;
use lesson_4;

-- Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру,  с помощью которой можно переместить любого (одного) пользователя из таблицы users в таблицу users_old. 
-- (использование транзакции с выбором commit или rollback – обязательно).
DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);

DROP procedure IF EXISTS relocate_data;
DELIMITER //
CREATE procedure relocate_data(iduser INT, op varchar(5), out result varchar(100)) 
begin
		DECLARE `_rollback` BIT DEFAULT 0;
		DECLARE code varchar(100);
		DECLARE error_string varchar(100);
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
			BEGIN
				SET `_rollback` = 1;
				GET stacked DIAGNOSTICS CONDITION 1 code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
			END;
	start transaction;
	if op = 'arhiv' THEN 
  		INSERT INTO users_old SELECT * FROM users WHERE id = iduser;
		delete FROM users WHERE id = iduser;
	else -- return
		INSERT INTO users SELECT * FROM users_old WHERE id = iduser;
		delete FROM users_old WHERE id = iduser;
	end if;
	IF `_rollback` THEN
		SET result = concat('Error: ', code, ' Reason: ', error_string);
		ROLLBACK;
	ELSE
		SET result = 'Done';
		COMMIT;
	END IF;
END// 
DELIMITER ;

call relocate_data(2, 'arhiv', @res);
SELECT @res AS 'Result';
call relocate_data(4, 'arhiv', @res);
SELECT @res AS 'Result';

SELECT * FROM users;
SELECT * FROM users_old;
 
call relocate_data (2, 'rev', @res);
SELECT @res AS 'Result';
call relocate_data(4, 'rev', @res);
SELECT @res AS 'Result';
SELECT * FROM users;
SELECT * FROM users_old;

-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

drop function if exists hello;
DELIMITER //
create function hello()
	returns varchar(15) READS SQL DATA
	BEGIN
		DECLARE now_hour INT;
		DECLARE greetings varchar (15);
		SET now_hour = hour(now());
		SET greetings = case
              WHEN now_hour BETWEEN 6 AND 12 THEN 'Доброе утро'
              WHEN now_hour BETWEEN 13 AND 18 THEN 'Добрый день'
              WHEN now_hour BETWEEN 19 AND 24 THEN 'Добрый вечер'
              WHEN now_hour BETWEEN 0 AND 5 THEN 'Доброй ночи'
       end;
		RETURN greetings;
	END //
DELIMITER ;

-- test
SELECT hello() AS 'Привет и';


-- (по желанию)* Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, communities и messages в таблицу logs помещается время и дата создания записи, 
-- название таблицы, идентификатор первичного ключа.

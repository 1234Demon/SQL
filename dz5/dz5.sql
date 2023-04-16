use lesson_4;

-- Создайте представление, в которое попадет информация о  пользователях (имя, фамилия, город и пол), которые не старше 20 лет.
create view infousers as
select CONCAT(users.firstname, ' ', users.lastname) AS 'Пользователь',
profiles.hometown, profiles.gender
from users, profiles
where TIMESTAMPDIFF(year, profiles.birthday, now()) <= 20 and users.id = profiles.user_id;

select * from infousers;

-- Найдите кол-во,  отправленных сообщений каждым пользователем и  выведите ранжированный список пользователей, указав имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге 
-- (первое место у пользователя с максимальным количеством сообщений) . (используйте DENSE_RANK)
select distinctrow CONCAT(users.firstname, ' ', users.lastname), 
count(*) over(partition by from_user_id),
dense_rank() over(order by from_user_id)
from users, messages
where from_user_id = users.id;

-- Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at) и найдите разницу дат отправления между соседними сообщениями, получившегося списка. (используйте LEAD или LAG)
select body as Msg,
created_at as 'Send time',
TIMESTAMPDIFF(
        MINUTE,
        lag(created_at, 1, created_at) over(
            order by created_at
        ),
        created_at
    ) as 'Difference in min'
from messages;

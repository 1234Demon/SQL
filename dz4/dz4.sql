use lesson_4;

-- Подсчитать общее количество лайков, которые получили пользователи младше 12 лет.
select count(*) from profiles, media, likes
where likes.media_id = media.id and media.user_id = profiles.user_id and (YEAR(CURRENT_DATE)-YEAR(profiles.birthday))-(RIGHT(CURRENT_DATE,5)<RIGHT(profiles.birthday,5)) < 12;

-- Определить кто больше поставил лайков (всего): мужчины или женщины. 
select gender, count(gender) from profiles
join likes on profiles.user_id = likes.user_id
group by gender;

-- Вывести всех пользователей, которые не отправляли сообщения.
select users.id, CONCAT(users.firstname, ' ', users.lastname), messages.from_user_id from users 
left join messages on users.id = messages.from_user_id
where messages.from_user_id is null;

-- (по желанию)* Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех написал ему сообщений.

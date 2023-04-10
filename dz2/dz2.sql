use dz2;
create table sales(
      id int auto_increment primary key,
      order_date date not null,
      count_product int default 0
);
select * from sales;
insert into sales(order_date, count_product)
values ('2022-01-01', 156),
	('2022-01-02', 180),
    ('2022-01-03', 21),
    ('2022-01-04', 124),
    ('2022-01-05', 341);
select id as 'id заказа',
	case
		when count_product < 100 then 'Маленький заказ'
		when count_product between 100 and 300 then 'Средний заказ'
		when count_product > 300 then 'Большой заказ'
		else 'Не определено'
	end as 'Тип заказа'
from sales;
create table orders(
	id int auto_increment primary key,
    employee_id varchar(5) not null,
	amount decimal(5, 2) not null,
    order_status varchar(9) not null default 'open'
);
insert into orders(employee_id, amount, order_status)
values ('e03', 15.00, 'open'),
	('e01', 25.50, 'open'),
    ('e05', 100.70, 'closed'),
    ('e02', 22.18, 'open'),
    ('e04', 9.50, 'cancelled');
select * from orders;
select id as 'id_order',
case
            when order_status = 'open' then 'Order is in open state'
            when order_status = 'closed' then 'Order is closed'
            when order_status = 'cancelled' then 'Order is cancelled'
            else 'Not define'
      end as 'full_order_status'
from orders;
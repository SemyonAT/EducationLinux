# Задание mysql

развернуть базу из дампа и настроить репликацию
В материалах приложены ссылки на вагрант для репликации
и дамп базы bet.dmp
базу развернуть на мастере
и настроить чтобы реплицировались таблицы
| bookmaker |
| competition |
| market |
| odds |
| outcome

* Настроить GTID репликацию

варианты которые принимаются к сдаче
- рабочий вагрантафайл
- скрины или логи SHOW TABLES
* конфиги
* пример в логе изменения строки и появления строки на реплике


# Решение



# Для себя

show engines; - показать список движков для mysql
create database wordpres; создание базы для wordpress 
show databases; - показать список баз 
show processlist; показывает что делает mysql в настоящее время
show full processlist; покажет больше информации
kill 1515; - можем убить процесс который выполняется сейчас
    
use wordpres - переключение на конкретную базу для последующей работы
show tabels; -показать все таблицы базы данных 
select User, host from user; - выбираем пользовтелей из системной таблиы базы mysql
create tabel test(id int primary key auto_increment, name varchar(100)); - создаем таблицу 
select * from TaBELS where TABEL_SCHEMA='otus'; - выбор из системной таблицы описание таблицы otus

create user voip identified by 'Password123'; - создание пользователя voip с паролем
grant all privileges on voip.* to voip@'%'; дать полные права пользователю voip со всех хостов '%'


mysql -u voip -pPassword123 - зайти в консоль mysql под пользователем voip с паролем
ALTER USER USER() IDENTIFIED BY 'Rhtfpjn288<frnhbv288'; - поменять пароль внутри консоли mysql для пользователя

mysqldump --all-databases --triggers --routines --master-data --ignore-table=bet.events_on_demand -uroot -p > master.sql - снимаем дамп базы
mysql -u voip -pPassword123 voip < /home/user/master.sql - заливаем дамп

show master status; 
show slave status;

show slave status\G; - \G разворачивает табличку и мы видим колонки в строках
show variables like '%read_only%'; - показывает переменные



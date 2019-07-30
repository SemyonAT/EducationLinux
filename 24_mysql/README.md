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
Настроил GTID репликацию

Конфигурация мастера
![Конфигурация мастера ](/24_mysql/imeg/7.png)
Конфигурация слейва
![Конфигурация слейва](/24_mysql/imeg/6.png)
Show tables на местере
![Show tables на местере](/24_mysql/imeg/4.png)
Show tables на слейве
![Show tables на слейве](/24_mysql/imeg/5.png)
Вывод бинлога коммандой mysqlbinlog 
![Вывод бинлога коммандой mysqlbinlog](/24_mysql/imeg/3.png)
Демонстрация содержимого таблицы bookmaker на мастере
![Вывод бинлога коммандой mysqlbinlog](/24_mysql/imeg/1.png)
Демонстрация содержимого таблицы bookmaker на слейве
![Вывод бинлога коммандой mysqlbinlog](/24_mysql/imeg/2.png)

# Для себя

show engines; - показать список движков для mysql
create database wordpres; создание базы для wordpress 
show databases; - показать список баз 
show processlist; показывает что делает mysql в настоящее время
show full processlist; покажет больше информации
kill 1515; - можем убить процесс который выполняется сейчас

drop database bet;  - удалить базу bet
use wordpres - переключение на конкретную базу для последующей работы
show tabels; -показать все таблицы базы данных 
select User, host from user; - выбираем пользовтелей из системной таблиы базы mysql
create tabel test(id int primary key auto_increment, name varchar(100)); - создаем таблицу 
select * from TaBELS where TABEL_SCHEMA='otus'; - выбор из системной таблицы описание таблицы otus

create user voip identified by 'Password123'; - создание пользователя voip с паролем
grant all privileges on voip.* to voip@'%'; дать полные права пользователю voip со всех хостов '%'


mysql -u voip -pPassword123 - зайти в консоль mysql под пользователем voip с паролем
ALTER USER USER() IDENTIFIED BY 'password'; - поменять пароль внутри консоли mysql для пользователя

mysqldump --all-databases --triggers --routines --master-data --ignore-table=bet.events_on_demand -uroot -p > master.sql - снимаем дамп базы
mysql -u voip -pPassword123 voip < /home/user/master.sql - заливаем дамп

show master status; 
show slave status;
show slave status\G; - \G разворачивает табличку и мы видим колонки в строках
STOP SLAVE;
RESET SLAVE;
CHANGE MASTER TO MASTER_HOST = "192.168.11.150", MASTER_PORT = 3306,
MASTER_USER = "repl", MASTER_PASSWORD = "!OtusLinux2018", MASTER_AUTO_POSITION = 1;
START SLAVE;



show variables like '%read_only%'; - показывает переменные



# Задание
Простая защита от DDOS
Написать конфигурацию nginx, которая даёт доступ клиенту только с определенной cookie.
Если у клиента её нет, нужно выполнить редирект на location, в котором кука будет добавлена, после чего клиент будет обратно отправлен (редирект) на запрашиваемый ресурс.

Смысл: умные боты попадаются редко, тупые боты по редиректам с куками два раза не пойдут

Для выполнения ДЗ понадобятся
https://nginx.org/ru/docs/http/ngx_http_rewrite_module.html
https://nginx.org/ru/docs/http/ngx_http_headers_module.html

# Решение



# Для себя







## Роли
Создание структуры каталогов - ansible-galaxy init nginx
roles:
	- { role: nginx, when: ansible_system == ''Linux' }
## Модули
setup:  - получает все параметры системы, которые можем использовать как переменные
debug: var= / msg="Hello" - выводит значение переменных
shell: - выполняет команду шелл 
register: peremennay - положить все в переменную
delay: 2 - задержка в секундах
retries: 10 - повторять 10 раз
yum/apt: name=nginx state=latest -установщик
copy: src=file dest=путь назначения mode=0555 привелегии - копирование файлов
temlate: src=temlates/index.j2 dest=/etx/destination - копирует и заменяет внутри файла переменные

## Переменные:
ansible_os_family - RedHat/Debian Родительская операционная система

## Условия 
when: ansible_os_family == "RedHot"

## Циклы
### loop 
	//выведет все названия файлов
	debug: msg="Hello {{ item }} "
	loop:
		- "file1"
		- "file2"
	
	//устанавливает список программ	
	yum: name={{ item }} state=installed
	loop:
		- python
		- htop
		- nginx
		- tree
	//копирует все файлы в каталоге
	copy: src={{ item }} dest={{ destination_folder }} mode=0555
	with_fileglob: "{{ soursce_folder }}/*.*"

### loop Until
	shell: echo -n Z >> myfile.txt && cat myfile.txt //дозаписываем файл буквами Z и выводим на экран
	regiser: output //сохраняем в переменную вывод из команды кат
	delay: 2 //Ждем 2 секунды
	retries: 10 повторять 10 раз
	until: output.stdout.find("ZZZZ") == false выполняем повторение не 10 раз, а до тех пор пока в выводе переменной не найдем четыре Z
## Оформление блоков
- block: #===========Block for RedHot==========
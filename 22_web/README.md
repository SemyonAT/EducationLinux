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

nginx -V - показывает модули с которыми собран NGINX
curl -I http:\frfer.frfr - показывает заголовок запроса

curl -v --cookie "USER_TOKEN=Yes" http://127.0.0.1:5000/

server {  
	server_name geekjob.pro; 
	...
	location / {
		if ($cookie_access != "secretkey") {
			return 302 https://geekjob.ru$request_uri;
		}
	...
	}
...}






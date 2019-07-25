# Задание
Простая защита от DDOS
Написать конфигурацию nginx, которая даёт доступ клиенту только с определенной cookie.
Если у клиента её нет, нужно выполнить редирект на location, в котором кука будет добавлена, после чего клиент будет обратно отправлен (редирект) на запрашиваемый ресурс.

Смысл: умные боты попадаются редко, тупые боты по редиректам с куками два раза не пойдут

Для выполнения ДЗ понадобятся
https://nginx.org/ru/docs/http/ngx_http_rewrite_module.html
https://nginx.org/ru/docs/http/ngx_http_headers_module.html

# Решение

Решение данной задачи получилось в итоге простым и заключается в том, что, когда мы переходим по корневому пути и у нас не установлен cookie USER_TOKEN в значение YES, мы перенаправляем запрос на локейшен /img, на котором в свою очередь устанавливается Cookie и возвращается обратно в корневой локейшен.
Подскажите как можно защититься от DDOS таким способом, мы ведь сами все перенаправляем и даем cooki, может что-то я не понимаю.

        location / {
                if ($cookie_USER_TOKEN != "Yes") {
                        return  302 /img;
                }
                root        /usr/share/nginx/html;
        }
        location /img {
                add_header Set-Cookie "USER_TOKEN=Yes";
                return 302 /;
                #alias        /usr/share/nginx/test/s800.jpg;
        }


# Для себя

nginx -V - показывает модули с которыми собран NGINX
curl -I http:\frfer.frfr - показывает заголовок запроса
curl -b notrfgr -I -L  localhost - ходит по редиректам -L, -b c кукой
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






# ProfHW9
<b>Инициализация системы. systemd</b>  

---
<b>Создать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова ALERT</b>  
Создаём конфиг для сервиса:  
[Конфиг](watchlog/watchlog)  
Создаём скрипт watchlog.sh, который будет делать запись в syslog, в случае если в watchlog.log встретится слово ALERT  
[Скрипт](watchlog/watchlog.sh)  
Создаём пример watchlog.log  
[Пример лог файла](watchlog/watchlog.log)  
Создаём юнит для сервиса  
[service](watchlog/watchlog.service)  
Создаём сервис для таймера  
[timer](watchlog/watchlog.timer)  
Запускаем watchlog.timer  
```
root@ubu22serv:~# systemctl start watchlog.timer
```
Вывод syslog
```
starsh@ubu22serv:~$ tail -f /var/log/syslog
2025-08-27T22:54:04.815206+04:00 ubu22serv systemd[1]: Finished watchlog.service - My watchlog service.
2025-08-27T22:54:44.774579+04:00 ubu22serv systemd[1]: Starting watchlog.service - My watchlog service...
2025-08-27T22:54:44.792464+04:00 ubu22serv root: Ср 27 авг 2025 22:54:44 +04: Слово ALERT найдено! Starsh!
2025-08-27T22:54:44.794631+04:00 ubu22serv systemd[1]: watchlog.service: Deactivated successfully.
2025-08-27T22:54:44.796546+04:00 ubu22serv systemd[1]: Finished watchlog.service - My watchlog service.
2025-08-27T22:55:01.246722+04:00 ubu22serv CRON[2464]: (root) CMD (command -v debian-sa1 > /dev/null && debian-sa1 1 1)
2025-08-27T22:55:34.767621+04:00 ubu22serv systemd[1]: Starting watchlog.service - My watchlog service...
2025-08-27T22:55:34.787142+04:00 ubu22serv root: Ср 27 авг 2025 22:55:34 +04: Слово ALERT найдено! Starsh!
2025-08-27T22:55:34.790487+04:00 ubu22serv systemd[1]: watchlog.service: Deactivated successfully.
2025-08-27T22:55:34.790583+04:00 ubu22serv systemd[1]: Finished watchlog.service - My watchlog service.
```
---
<b>Установить spawn-fcgi и создать unit-файл (spawn-fcgi.sevice) с помощью переделки [init-скрипт](https://gist.github.com/cea2k/1318020)</b>  
Устанавливаем необходимые пакеты:  
```
apt update
apt install spawn-fcgi php php-cgi php-cli  apache2 libapache2-mod-fcgid -y
```
Создаём сервис:  
```
root@ubuntu24-empty:~# nano /etc/systemd/system/spawn-fcgi.service
```
```
[Unit]
Description = Учебный запуск сервиса spawn-fcgi
After = network.target

[Service]
Type = forking
User = www-data
Group = www-data
Environment = "server=127.0.0.1" "port=9000" "user=www-data" "group=www-data"
ExecStart = /usr/bin/spawn-fcgi -a $server -p $port -u $user -g $group -C 32 -f /usr/bin/php-cgi
KillMode = control-group
#ExecStop = killproc -p php-cgi -QUIT

[Install]
WantedBy = multi-user.target
```
Запускаем сервис spawn-fcgi.service  
```
root@ubuntu24-empty:~# systemctl daemon-reload
root@ubuntu24-empty:~# systemctl start spawn-fcgi.service
root@ubuntu24-empty:~# systemctl status spawn-fcgi.service
● spawn-fcgi.service - Учебный запуск сервиса spawn-fcgi
     Loaded: loaded (;;file://ubuntu24-empty/etc/systemd/system/spawn-fcgi.service/etc/systemd/system/spawn-fcgi.service;;; disabled; preset: enabled)
     Active: active (running) since Sun 2025-08-31 19:42:07 UTC; 4s ago
    Process: 2707 ExecStart=/usr/bin/spawn-fcgi -a $server -p $port -u $user -g $group -C 10 -f /usr/bin/php-cgi (code=exited, status=0/SUCCESS)
   Main PID: 2708 (php-cgi)
      Tasks: 11 (limit: 2268)
     Memory: 8.9M (peak: 9.3M)
        CPU: 29ms
     CGroup: /system.slice/spawn-fcgi.service
             ├─2708 /usr/bin/php-cgi
             ├─2709 /usr/bin/php-cgi
             ├─2710 /usr/bin/php-cgi
             ├─2711 /usr/bin/php-cgi
             ├─2712 /usr/bin/php-cgi
             ├─2713 /usr/bin/php-cgi
             ├─2714 /usr/bin/php-cgi
             ├─2715 /usr/bin/php-cgi
             ├─2716 /usr/bin/php-cgi
             ├─2717 /usr/bin/php-cgi
             └─2718 /usr/bin/php-cgi

авг 31 19:42:07 ubuntu24-empty systemd[1]: Starting spawn-fcgi.service - Учебный запуск сервиса spawn-fcgi...
авг 31 19:42:07 ubuntu24-empty spawn-fcgi[2707]: spawn-fcgi: child spawned successfully: PID: 2708
авг 31 19:42:07 ubuntu24-empty systemd[1]: Started spawn-fcgi.service - Учебный запуск сервиса spawn-fcgi.
```
---
<b>Доработать unit-файл Nginx (nginx.service) для запуска нескольких инстансов сервера с разными конфигурационными файлами одновременно</b>  
Устанавливаем nginx  
```
root@ubuntu24-prof4:~# apt update; apt upgrade -y; apt install nginx -y
```
Изменяем конфигурацию nginx. Файлы конфигурации:  
[/etc/nginx/nginx-first.conf](nginx/nginx-first.conf); 
[/etc/nginx/sites-available/nginx-first](nginx/nginx-first); 
[/etc/nginx/nginx-second.conf](nginx/nginx-second.conf); 
[/etc/nginx/sites-available/nginx-second](nginx/nginx-second)  
  
Создаём новый мультисервис:  
[/etc/systemd/system/nginx@.service](nginx/nginx@.service)  

Проверяем работу сервисов nginx:  
```
root@ubuntu24-prof4:/etc/nginx# systemctl daemon-reload
root@ubuntu24-prof4:/etc/nginx# systemctl start nginx@first
root@ubuntu24-prof4:/etc/nginx# systemctl start nginx@second
root@ubuntu24-prof4:/etc/nginx# systemctl status nginx@first
● nginx@first.service - A high performance web server and a reverse proxy server
     Loaded: loaded (;;file://ubuntu24-prof4/etc/systemd/system/nginx@.service/etc/systemd/system/nginx@.service;;; disabled; preset: enabled)
     Active: active (running) since Sun 2025-08-31 21:16:54 UTC; 1h 9min ago
       Docs: ;;man:nginx(8)man:nginx(8);;
    Process: 2336 ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx-first.conf -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Process: 2338 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx-first.conf -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 2339 (nginx)
      Tasks: 2 (limit: 2268)
     Memory: 1.7M (peak: 1.9M)
        CPU: 18ms
     CGroup: /system.slice/system-nginx.slice/nginx@first.service
             ├─2339 "nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx-first.conf -g daemon on; master_process on;"
             └─2340 "nginx: worker process"

авг 31 21:16:54 ubuntu24-prof4 systemd[1]: Starting nginx@first.service - A high performance web server and a reverse proxy server...
авг 31 21:16:54 ubuntu24-prof4 systemd[1]: Started nginx@first.service - A high performance web server and a reverse proxy server.
root@ubuntu24-prof4:/etc/nginx# systemctl status nginx@second.service
● nginx@second.service - A high performance web server and a reverse proxy server
     Loaded: loaded (;;file://ubuntu24-prof4/etc/systemd/system/nginx@.service/etc/systemd/system/nginx@.service;;; disabled; preset: enabled)
     Active: active (running) since Sun 2025-08-31 21:17:01 UTC; 26s ago
       Docs: ;;man:nginx(8)man:nginx(8);;
    Process: 2344 ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx-second.conf -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Process: 2345 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx-second.conf -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 2347 (nginx)
      Tasks: 2 (limit: 2268)
     Memory: 1.7M (peak: 1.9M)
        CPU: 21ms
     CGroup: /system.slice/system-nginx.slice/nginx@second.service
             ├─2347 "nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx-second.conf -g daemon on; master_process on;"
             └─2348 "nginx: worker process"

авг 31 21:17:01 ubuntu24-prof4 systemd[1]: Starting nginx@second.service - A high performance web server and a reverse proxy server...
авг 31 21:17:01 ubuntu24-prof4 systemd[1]: Started nginx@second.service - A high performance web server and a reverse proxy server.
root@ubuntu24-prof4:/etc/nginx# ss -tulpn
Netid         State          Recv-Q         Send-Q                        Local Address:Port                  Peer Address:Port         Process
udp           UNCONN         0              0                                127.0.0.54:53                         0.0.0.0:*             users:(("systemd-resolve",pid=563,fd=16))
udp           UNCONN         0              0                             127.0.0.53%lo:53                         0.0.0.0:*             users:(("systemd-resolve",pid=563,fd=14))
udp           UNCONN         0              0                      192.168.0.116%enp0s8:68                         0.0.0.0:*             users:(("systemd-network",pid=558,fd=26))
udp           UNCONN         0              0                          10.0.2.15%enp0s3:68                         0.0.0.0:*             users:(("systemd-network",pid=558,fd=23))
tcp           LISTEN         0              4096                             127.0.0.54:53                         0.0.0.0:*             users:(("systemd-resolve",pid=563,fd=17))
tcp           LISTEN         0              511                                 0.0.0.0:8081                       0.0.0.0:*             users:(("nginx",pid=2348,fd=5),("nginx",pid=2347,fd=5))
tcp           LISTEN         0              511                                 0.0.0.0:8080                       0.0.0.0:*             users:(("nginx",pid=2340,fd=5),("nginx",pid=2339,fd=5))
tcp           LISTEN         0              4096                                0.0.0.0:22                         0.0.0.0:*             users:(("sshd",pid=917,fd=3),("systemd",pid=1,fd=147))
tcp           LISTEN         0              4096                          127.0.0.53%lo:53                         0.0.0.0:*             users:(("systemd-resolve",pid=563,fd=15))
tcp           LISTEN         0              4096                                   [::]:22                            [::]:*             users:(("sshd",pid=917,fd=4),("systemd",pid=1,fd=150))
root@ubuntu24-prof4:/etc/nginx# ps afx | grep nginx
   2373 pts/1    S+     0:00  |                       \_ grep --color=auto nginx
   1925 pts/3    S+     0:00                          \_ nano nginx.conf
   2339 ?        Ss     0:00 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx-first.conf -g daemon on; master_process on;
   2340 ?        S      0:00  \_ nginx: worker process
   2347 ?        Ss     0:00 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx-second.conf -g daemon on; master_process on;
   2348 ?        S      0:00  \_ nginx: worker process
```

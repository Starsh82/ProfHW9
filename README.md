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

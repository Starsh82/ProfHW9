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

# Мониторинг с помощью Prometheus
---
## Задача

Настроить сбор метрик с помощью Prometheus на примере мониторинга CMS. Задействовать максимальное количество экспортеров для мониторинга состояния компонентов системы. Настроить доступ к экспортерам по одному порту с использованием SSL и авторизации.

## Решение
Для решения задачи использован способ установки компонентов мониторинга через unit-файлы systemd. В целях обучения использован не самый безопасный, но простой способ указания данных для авторизации (креды указаны в конфиге в явном виде).

### Использованные элементы
| Элемент | Назначение |
| ------ | ------ |
| [Prometheus](https://github.com/prometheus/prometheus/releases/download/v2.53.4/prometheus-2.53.4.linux-amd64.tar.gz) | сервер мониторинга |
| [Node exporter](https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz) | экспортер метрик ВМ |
| [Blackbox exporter](https://github.com/prometheus/blackbox_exporter/releases/download/v0.26.0/blackbox_exporter-0.26.0.linux-amd64.tar.gz) | экспортер для проверок по HTTP (в рамках данной задачи) |
| [MySQL Exporter](https://github.com/prometheus/mysqld_exporter/releases/download/v0.17.2/mysqld_exporter-0.17.2.linux-amd64.tar.gz) | экспортер метрик БД |
| [PHP-FPM exporter](https://github.com/bakins/php-fpm-exporter/releases/download/v0.6.1/php-fpm-exporter.linux.amd64) | экспортер метрик php-fpm |
| [Nginx exporter](https://github.com/nginx/nginx-prometheus-exporter/releases/download/v1.4.1/nginx-prometheus-exporter_1.4.1_linux_amd64.tar.gz) | экспорте метрик nginx |
| [Wordpress](http://wordpress.org/latest.tar.gz) | CMS |
| [PromPress](https://downloads.wordpress.org/plugin/prompress.1.2.2.zip) | плагин для сбора метрик Wordpress |
| Redis | СУБД для работы PromPress |
| LEMP | стек для развертывания Wordpress |

##### 1. Установка Prometheus
Prometheus установлен на отдельной машине, в конфиг добавлена джоба для сбора данных с самого Prometheus. Конфигурационный файл с настройками приложен.

![prometheus.yml](images/prom1.jpg)
![prometheus.yml](images/prom2.jpg)

##### 2. Установка Wordpress
Установлена последняя версия Wordpress, также установлен плагин для сбора метрик для Prometheus.

##### 3. Установка экспортеров
Установлены указанные в таблице выше экспортеры.

###### Node exporter
![Node exporter](GAP1/images/node.jpg)

###### MySQL exporter
![MySQL exporter](GAP1/images/mysql.jpg)

###### Blackbox exporter
![Blackbox exporter](GAP1/images/blackbox.jpg)

###### Blackbox probe
![Blackbox probe](GAP1/images/probe.jpg)

###### PromPress plugin
![PromPress plugin](GAP1/images/prompress.jpg)

###### Nginx exporter
![Nginx exporter](GAP1/images/nginx.jpg)

###### PHP-FPM exporter
![PHP-FPM exporter](GAP1/images/php-fpm.jpg)

##### 4. Настройка прокси
Nginx проксирует запросы к страницам с метриками на IP:443. Конфигурационный файл с настройками прокси с использованием SSL и авторизации приложен.

##### 5. Ограничение доступа к порту 443 с помощью iptables
Директивы iptables, где 192.168.56.10 - адрес Prometheus, 192.168.56.11 - адрес CMS:
```sh
iptables -A INPUT -p tcp -s 192.168.56.10 --dport 443 -d 192.168.56.11 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j DROP
```

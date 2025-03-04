# Домашнее задание к занятию «ELK» - Ильхом Ядгаров

Здравствуйте дорогоие наставники. С этой домашкой я намучался так как ни с какой другой. Сначало были проблемы с logstash, потом с filebeat, устанавливал на разные VM всё равно не получалось.
Пересмотрел запись урока. В итоге установил через docker-compose, вроде всё заработало. Если с теоритической стороной всё вроде как понятно, то с практической стороной было очень сложно!!!

### Задание 1. Elasticsearch 

Установите и запустите Elasticsearch, после чего поменяйте параметр cluster_name на случайный. 

*Приведите скриншот команды 'curl -X GET 'localhost:9200/_cluster/health?pretty', сделанной на сервере с установленным Elasticsearch. Где будет виден нестандартный cluster_name*.

![alt md10-dz3-img1.JPG](/img/md10-dz3-img1.JPG)

---

### Задание 2. Kibana

Установите и запустите Kibana.

*Приведите скриншот интерфейса Kibana на странице http://<ip вашего сервера>:5601/app/dev_tools#/console, где будет выполнен запрос GET /_cluster/health?pretty*.

![alt md10-dz3-img2.JPG](/img/md10-dz3-img2.JPG)

---

### Задание 3. Logstash

Установите и запустите Logstash и Nginx. С помощью Logstash отправьте access-лог Nginx в Elasticsearch. 

*Приведите скриншот интерфейса Kibana, на котором видны логи Nginx.*

![alt md10-dz3-img3.JPG](/img/md10-dz3-img3.JPG)

---

### Задание 4. Filebeat. 

Установите и запустите Filebeat. Переключите поставку логов Nginx с Logstash на Filebeat. 

*Приведите скриншот интерфейса Kibana, на котором видны логи Nginx, которые были отправлены через Filebeat.*

![alt md10-dz3-img4.JPG](/img/md10-dz3-img4.JPG)

---


## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.


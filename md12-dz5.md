# Домашнее задание к занятию «Индексы» - Ильхом Ядгаров



### Задание 1

Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.

**ОТВЕТ:**
```
select  TABLE_SCHEMA as 'Имя Базы Данных',  
    sum(DATA_LENGTH + INDEX_LENGTH) as 'Полный размер БД (БД+индексы)', 
    sum(INDEX_LENGTH) as 'Размер всех индексов в БД', 
    round(sum(INDEX_LENGTH) / sum(DATA_LENGTH + INDEX_LENGTH) * 100, 0) as '% индексов к размеру БД'
from information_schema.tables
where TABLE_SCHEMA = 'sakila'
group by TABLE_SCHEMA;
```
![alt md12-dz5-img1.JPG](/img/md12-zd5-img1.JPG)
### Задание 2

Выполните explain analyze следующего запроса:
```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```
- перечислите узкие места;
- оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.

**ОТВЕТ:**
Запускаем оператор **explain analyze**

```
explain analyze
select distinct concat(c.last_name, ' ', c.first_name),
       sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and
      p.payment_date = r.rental_date and
      r.customer_id = c.customer_id and
      i.inventory_id = r.inventory_id;
```
Скриншот результата  
![alt md12-dz5-img2.JPG](/img/md12-zd5-img2.JPG)

Корректируем код для оптимизации выполнения запроса:  
Создаём индекс **idx_payment_date**:
```
CREATE INDEX idx_payment_date ON payment (payment_date);

explain analyze
select distinct concat(c.last_name, ' ', c.first_name) as 'Клиент', 
       sum(p.amount) as 'Сумма платежей'
       -- c.customer_id, f.title, p.amount 
from payment p inner join 
     rental r on p.rental_id = r.rental_id 
     inner join customer c on r.customer_id = c.customer_id
     inner join inventory i on r.inventory_id = i.inventory_id
where payment_date >= '2005-07-30' and payment_date < DATE_ADD('2005-07-30', INTERVAL 1 DAY)
group by concat(c.last_name, ' ', c.first_name);
```
Скриншот с использование индекса **idx_payment_date**.
![alt md12-dz5-img3.JPG](/img/md12-zd5-img3.JPG)

```
-> Index range scan on p using idx_payment_date over ('2005-07-30 00:00:00' <= payment_date < '2005-07-31 00:00:00'), with index condition: ((p.payment_date >= TIMESTAMP'2005-07-30 00:00:00') and (p.payment_date < <cache>(('2005-07-30' + interval 1 day))))  (cost=286 rows=634) (actual time=0.0207..1.09 rows=634 loops=1)
```


## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

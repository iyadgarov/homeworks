# Домашнее задание к занятию «SQL. Часть 2» - Ильхом Ядгаров

Задание можно выполнить как в любом IDE, так и в командной строке.

### Задание 1

Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей, и выведите в результат следующую информацию: 
- фамилия и имя сотрудника из этого магазина;
- город нахождения магазина;
- количество пользователей, закреплённых в этом магазине.

```
SELECT CONCAT_WS(" ", s2.first_name, s2.last_name) as staff_name, c2.city, COUNT(c.customer_id) as customer_count
FROM customer c
JOIN store s ON c.store_id = s.store_id
JOIN staff s2 ON s.manager_staff_id = s2.staff_id
JOIN address a ON s.address_id = a.address_id
JOIN city c2 ON a.city_id = c2.city_id
GROUP BY c.store_id
HAVING customer_count> 300;
```  
![alt md12-dz4-img1.JPG](/img/md12-dz4-img1.JPG)

### Задание 2

Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.
```
SELECT COUNT(film_id) as amount
FROM film WHERE length >(SELECT AVG(length) FROM film);
```
![alt md12-dz4-img2.JPG](/img/md12-dz4-img2.JPG)

### Задание 3

Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц.

```
SELECT date_format (p.payment_date , '%M.%Y') as payment_month, SUM(amount) as payment_sum,  COUNT(r.rental_id) as rental_count
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
GROUP BY payment_month
ORDER BY payment_sum DESC
LIMIT 1
```  
![alt md12-dz4-img3.JPG](/img/md12-dz4-img3.JPG)

## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

### Задание 4*

Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку «Премия». Если количество продаж превышает 8000, то значение в колонке будет «Да», иначе должно быть значение «Нет».

```
SELECT CONCAT(s.last_name, ' ', s.first_name) AS 'Продавец' , COUNT(r.rental_id) as 'количество продаж',
CASE
  WHEN COUNT(r.rental_id) > 8000 THEN 'Да'
  ELSE 'Нет'
END AS 'Премировать'
FROM rental r 
INNER JOIN staff s ON s.staff_id =  r.staff_id  
GROUP BY r.staff_id;
```
![alt md12-dz4-img4.JPG](/img/md12-dz4-img4.JPG)

### Задание 5*

Найдите фильмы, которые ни разу не брали в аренду.
```
SELECT DISTINCT f2.title as 'Наименование фильма'
FROM rental r
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON i.film_id = f.film_id
RIGHT JOIN film f2 ON f2.film_id = f.film_id
WHERE f.film_id is null
```
![alt md12-dz4-img5.JPG](/img/md12-dz4-img5.JPG)

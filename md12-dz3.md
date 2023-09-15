# Домашнее задание к занятию «SQL. Часть 1» - Ильхом Ядгаров

---

Задание можно выполнить как в любом IDE, так и в командной строке.

### Задание 1

Получите уникальные названия районов из таблицы с адресами, которые начинаются на “K” и заканчиваются на “a” и не содержат пробелов.
```
select distinct *  
from address
where district like 'K%a' and district not like '% %';
```
![alt md12-dz3-img1.JPG](/img/md12-dz3-img1.JPG)

### Задание 2

Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись в промежуток с 15 июня 2005 года по 18 июня 2005 года **включительно** и стоимость которых превышает 10.00.
Я вижу два варианта решения данного задания.


**Первый вариант (как нам объяснили на уроке) с использованием оператора CAST**

```
select payment_id, customer_id, rental_id, amount, CAST(payment_date as DATE)
from payment
where amount > 10 and payment_date > '2005-06-15' and payment_date < '2005-06-19'
order by payment_date; 
```
![alt md12-dz3-img2.JPG](/img/md12-dz3-img2.JPG)

**Второй вариант проще, но не менее эфективен .**

```
select * from payment p 
where amount > 10 and payment_date >= '2005-06-15 00:00:01' and payment_date <= '2005-06-18 23:59:59'
order by payment_date; 
```
![alt md12-dz3-img2v2.JPG](/img/md12-dz3-img2v2.JPG)

**Третий вариант, решение с помошью опреатора BETWEEN.**

```
select * from payment p 
where amount > 10 and payment_date between '2005-06-15' and '2005-06-19'
order by payment_date; 
```

![alt md12-dz3-img2v3.JPG](/img/md12-dz3-img2v3.JPG)

### Задание 3

Получите последние пять аренд фильмов.
```
select *
from rental r 
order by rental_date desc
limit 5;
```
![alt md12-dz3-img3.JPG](/img/md12-dz3-img3.JPG)

### Задание 4

Одним запросом получите активных покупателей, имена которых Kelly или Willie. 

Сформируйте вывод в результат таким образом:
- все буквы в фамилии и имени из верхнего регистра переведите в нижний регистр,
- замените буквы 'll' в именах на 'pp'.

```
select lower(replace (first_name, 'L', 'p')) Имя, lower(last_name) Фамилия 
from customer c 
where first_name like 'Kelly' or first_name like 'Willie';
```

  ![alt md12-dz3-img4.JPG](/img/md12-dz3-img4.JPG)

## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

### Задание 5*

Выведите Email каждого покупателя, разделив значение Email на две отдельных колонки: в первой колонке должно быть значение, указанное до @, во второй — значение, указанное после @.

```
select email, 
substring_index(email , '@', 1) as Name,
substring_index(email , '@', -1) as Домен
from customer;
```
![alt md12-dz3-img5.JPG](/img/md12-dz3-img5.JPG)


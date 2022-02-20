# Решение домашнего задания к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

Ответ.  
[screenshot 01](https://i.imgur.com/nm4SU81.png)  
![screenshot 01](https://i.imgur.com/nm4SU81.png)  

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

Ответ.  
[screenshot 02](https://i.imgur.com/PBEdUtk.png)  
![screenshot 02](https://i.imgur.com/PBEdUtk.png)  

[screenshot 03](https://i.imgur.com/NVX7oro.png)  
![screenshot 03](https://i.imgur.com/NVX7oro.png)  

[screenshot 04](https://i.imgur.com/yp30L9v.png)  
![screenshot 04](https://i.imgur.com/yp30L9v.png)  

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

Ответ.  
```SQL
INSERT INTO orders (name, price) VALUES ('Шоколад', 10), ('Принтер', 3000), ('Книга', 500), ('Монитор', 7000), ('Гитара', 4000);
INSERT INTO clients (surname, country) VALUES ('Иванов Иван Иванович', 'USA'), ('Петров Петр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'), ('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia');
```
[screenshot 05](https://i.imgur.com/H4Dp0kV.png)  
![screenshot 05](https://i.imgur.com/H4Dp0kV.png)  

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

Ответ.  
```SQL
UPDATE clients SET "order" = (SELECT id FROM orders WHERE name = 'Книга') WHERE surname = 'Иванов Иван Иванович';
UPDATE clients SET "order" = (SELECT id FROM orders WHERE name = 'Монитор') WHERE surname = 'Петров Петр Петрович';
UPDATE clients SET "order" = (SELECT id FROM orders WHERE name = 'Гитара') WHERE surname = 'Иоганн Себастьян Бах';
``` 
[screenshot 06](https://i.imgur.com/coIA3xt.png)  
![screenshot 06](https://i.imgur.com/coIA3xt.png)  

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

Ответ.  

"Plan-reading is an art that requires some experience to master, ..."  

[screenshot 07](https://i.imgur.com/3Gt1IYE.png)  
![screenshot 07](https://i.imgur.com/3Gt1IYE.png)  

cost=0.00 - приблизительная стоимость запуска. Это время (в произвольных единицах, определяемых параметрами планировщика), которое проходит, прежде чем начнётся этап вывода данных.  
18.10 - приблизительная общая стоимость.  
rows=806 - ожидаемое число строк, которое должен вывести этот узел плана запроса.  
width=72 - ожидаемый средний размер строк в байтах, выводимых этим узлом плана запроса.  
Filter: ("order" IS NOT NULL) - условие WHERE применено как "фильтр" к узлу плана Seq Scan.  

actual time=0.015..0.017 - время выполнения в миллисекундах.  
rows=3 - фактическое число строк.  
loops=1 - сколько всего раз выполнялся этот узел плана запроса, где фактическое время и число строк вычисляется как среднее по всем итерациям.  
Rows Removed by Filter: 2 - число строк, удалённых условием фильтра.  
Planning Time: 0.069 ms - время, затраченное на построение плана запроса из разобранного запроса и его оптимизацию.  
Execution Time: 0.036 ms - время, от запуска до остановки исполнителя запроса, а также время выполнения всех сработавших триггеров, но исключает время разбора, перезаписи и планирования запроса.  

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

Ответ.  
```bash
pg_dump -h localhost -p 5432 -U postgres -Fc test_db > ./backup/test.dump
pg_restore -h localhost -p 5432 -U postgres --create --dbname postgres ./backup/test.dump
```

---


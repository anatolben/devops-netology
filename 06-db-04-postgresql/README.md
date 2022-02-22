# Решение домашнего задания к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

Ответ:  
```psql
General
  \q                     quit psql

Informational
  \d[S+]                 list tables, views, and sequences
  \l[+]   [PATTERN]      list databases
  \d[S+]  NAME           describe table, view, sequence, or index

Connection
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
```

## Задача 2

Используя `psql` создайте БД `pg_restore -h localhost -p 5432 -U postgres --create --dbname postgres ./backup/test.dump`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

Ответ:  
Столбец с наибольшим средним значением размера элементов в байтах - 'title'.  
[screenshot 01](https://i.imgur.com/Xd8isrd.png)  
![screenshot 01](https://i.imgur.com/Xd8isrd.png)  

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Ответ:  
```SQL
-- start a transaction
BEGIN;

-- Name: orders_part; Type: TABLE; Schema: public; Owner: postgres
CREATE TABLE orders_part (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
) PARTITION BY RANGE (price);

ALTER TABLE orders_part OWNER TO postgres;

-- create partition low
-- Name: orders_part_low; Type: TABLE; Schema: public; Owner: postgres
CREATE TABLE orders_part_low PARTITION OF orders_part
    FOR VALUES FROM (0) TO (500);

ALTER TABLE orders_part_low OWNER TO postgres;

-- create partition hight
-- Name: orders_part_hight; Type: TABLE; Schema: public; Owner: postgres
CREATE TABLE orders_part_hight PARTITION OF orders_part
    FOR VALUES FROM (500) TO (MAXVALUE);

ALTER TABLE orders_part_low OWNER TO postgres;

-- move data
INSERT INTO orders_part SELECT * FROM orders;
DROP table orders;
ALTER table orders_part rename to orders;

-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
CREATE SEQUENCE orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE orders_id_seq OWNER TO postgres;

-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
ALTER SEQUENCE orders_id_seq OWNED BY orders.id;

-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);

-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
ALTER TABLE orders ADD CONSTRAINT orders_pkey PRIMARY KEY (id, price);

-- commit the change
COMMIT;
```
Да. Необходимо стараться сегментировать таблицы на этапе проектирования и создания.  

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

Ответ.  
```SQL
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) UNIQUE NOT NULL,
    price integer DEFAULT 0
);
```

---

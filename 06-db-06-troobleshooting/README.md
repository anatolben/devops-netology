# Решение домашнего задания к занятию "6.6. Troubleshooting"

## Задача 1

Перед выполнением задания ознакомьтесь с документацией по [администрированию MongoDB](https://docs.mongodb.com/manual/administration/).

Пользователь (разработчик) написал в канал поддержки, что у него уже 3 минуты происходит CRUD операция в MongoDB и её 
нужно прервать. 

Вы как инженер поддержки решили произвести данную операцию:
- напишите список операций, которые вы будете производить для остановки запроса пользователя
- предложите вариант решения проблемы с долгими (зависающими) запросами в MongoDB

**Ответ:**  

1) Определить текущий идентификатор операции: db.currentOp()  
2) Завершить операцию db.killOp()  

Во-первых, установить ограничение времени выполнения операции, используя метод maxTimeMS().  
Во-вторых, исходя из конкретного вида (CRUD) операции, определить, что является причиной длительного выполнения.  
После чего, устранить эту причину. Возможными направлениями могут быть: при медленной записи, проверить какой режим гарантии durability использует операция;  
при медленном чтении, рассмотреть возможность чтения с реплик;  
при медленном удалении, рассмотреть удаление не отдельных документов, а коллекций, либо подготовку документов для удаления в отдельную коллекцию, которая затем будет удалена.  

## Задача 2

Перед выполнением задания познакомьтесь с документацией по [Redis latency troobleshooting](https://redis.io/topics/latency).

Вы запустили инстанс Redis для использования совместно с сервисом, который использует механизм TTL. 
Причем отношение количества записанных key-value значений к количеству истёкших значений есть величина постоянная и
увеличивается пропорционально количеству реплик сервиса. 

При масштабировании сервиса до N реплик вы увидели, что:
- сначала рост отношения записанных значений к истекшим
- Redis блокирует операции записи

Как вы думаете, в чем может быть проблема?

**Ответ:**  

Предположительно, используется активный метод удаления истекших ключей. Он запускается каждые 100 миллисекунд и удаляет не более 200 ключей в секунду. Но если общее количество истекших ключей за одну секунду превышает 25% от всех ключей у которых установлен срок действия, то Redis будет заблокирован, пока количество истекших ключей не станет меньше 25%.  
 
## Задача 3

Перед выполнением задания познакомьтесь с документацией по [Common Mysql errors](https://dev.mysql.com/doc/refman/8.0/en/common-errors.html).

Вы подняли базу данных MySQL для использования в гис-системе. При росте количества записей, в таблицах базы,
пользователи начали жаловаться на ошибки вида:
```python
InterfaceError: (InterfaceError) 2013: Lost connection to MySQL server during query u'SELECT..... '
```

Как вы думаете, почему это начало происходить и как локализовать проблему?

Какие пути решения данной проблемы вы можете предложить?

**Ответ:**  

Предположительно, если проблема возникла при увеличении количества записей, то возможно выполняемый запрос содержит большое количество данных, тогда необходимо увеличить net_read_timeout.  

Однако данная ошибка может иметь различные причины, и являться следствием других неисправностей.  
Поэтому, следует.  
Проверить error.log на наличие других ошибок. Проверить General Query Log. Проверить стабильность сетевого соединения.  
Если есть ошибки, определить запрос, вызвавший ошибку, протестировать выполнение запроса через mysql cli, проанализировать запрос, и возможно изменить его.  
Если в запросе присутствуют BLOB значения, и возникает дополнительно ошибка ER_NET_PACKET_TOO_LARGE, то возможно необходимо увеличить значение max_allowed_packet.
Если в логах присутствуют другие ошибки, то вероятнее всего они являются причиной, а указанная ошибка следствием. Так, например, это могут быть ошибки вызванные физической неисправностью сервера и устройств хранения данных, неисправностью файловой системы и файлов MySQL. Также стоит убедиться в том, что серверу MySQL хватает ресурсов, например, достаточно ли RAM для установленного значения max_connections.

## Задача 4

Перед выполнением задания ознакомтесь со статьей [Common PostgreSQL errors](https://www.percona.com/blog/2020/06/05/10-common-postgresql-errors/) из блога Percona.

Вы решили перевести гис-систему из задачи 3 на PostgreSQL, так как прочитали в документации, что эта СУБД работает с 
большим объемом данных лучше, чем MySQL.

После запуска пользователи начали жаловаться, что СУБД время от времени становится недоступной. В dmesg вы видите, что:

`postmaster invoked oom-killer`

Как вы думаете, что происходит?

Как бы вы решили данную проблему?

**Ответ:**  

Это происходит из-за нехватки виртуальной памяти.  

Для решения проблемы необходимо убедиться в правильности настроек операционной системы для PostgreSQL согласно документации https://www.postgresql.org/docs/14/kernel-resources.html.  
Проверить и настроить swap.  
При выполнении вышестоящих настроек, также сделать настройку ядра отключив перераспределение памяти vm.overcommit_memory=2.  

---
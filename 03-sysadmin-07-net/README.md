# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

[screenshot #1](https://i.imgur.com/NnzVbQ6.png)  
![screenshot #1](https://i.imgur.com/NnzVbQ6.png)  

[screenshot #2](https://i.imgur.com/LzhhGYn.png)  
![screenshot #2](https://i.imgur.com/LzhhGYn.png)  

[screenshot #3](https://i.imgur.com/KoAuTJ7.png)  
![screenshot #3](https://i.imgur.com/KoAuTJ7.png)  

[screenshot #4](https://i.imgur.com/72gVt6y.png)  
![screenshot #4](https://i.imgur.com/72gVt6y.png)  

[screenshot #5](https://i.imgur.com/K7rfOyV.png)  
![screenshot #5](https://i.imgur.com/K7rfOyV.png)  

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?

Link Layer Discovery Protocol (LLDP) - протокол канального уровня.  

[screenshot #6](https://i.imgur.com/mw3Gpn7.png)  
![screenshot #6](https://i.imgur.com/mw3Gpn7.png)  

[screenshot #7](https://i.imgur.com/ObFK6Kq.png)  
![screenshot #7](https://i.imgur.com/ObFK6Kq.png)  

3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.

Технология VLAN (Virtual Local Area Network), позволяет создавать виртуальные сети с топологией независимой от физических устройств.  

[screenshot #8](https://i.imgur.com/kl9np1r.png)  
![screenshot #8](https://i.imgur.com/kl9np1r.png)  

```commandline
root@netology2:~# modprobe 8021q
root@netology2:~# lsmod | grep 8021q
8021q                  32768  0
garp                   16384  1 8021q
mrp                    20480  1 8021q
root@netology2:~# ip link add link eth1 name eth1.5 type vlan id 5
root@netology2:~# ip addr add 10.0.0.1/24 dev eth1.5
```
[screenshot #9](https://i.imgur.com/VJez7hU.png)  
![screenshot #9](https://i.imgur.com/VJez7hU.png)  

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

####Типы агрегации Linux:  

balance-rr (mode 0) - По умолчанию. Пакеты в этом режиме идут по порядку от первого до последнего интерфейса. Если интерфейс выходит из строя, пакеты отправляются на остальные оставшиеся.  

active-backup (mode 1) - Один интерфейс активен, остальные ожидают. Если на активном интерфейсе проблема, переключение на ожидающий.  

balance-xor (mode 2) - Пакеты распределяется по типу входящего и исходящего трафика по формуле (source MAC XOR destination MAC) modulo NIC slave count.  

broadcast (mode 3) - Передача идет во все интерфейсы, обеспечивая отказоустойчивость. Рекомендуется только для MULTICAST трафика.  

802.3ad (mode 4) - Динамическое объединение одинаковых портов. Режим может увеличить пропускную способность на вход и выход. Для режима необходима поддержка и настройка коммутатора.  

balance-tlb (mode 5) - Режим адаптивной балансировки. Входящие получает активный интерфейс, исходящие распределяются в зависимости от загрузки каждого интерфейса.  

balance-alb (mode 6) - Усовершенствованный алгоритм балансировки чем balance-alb. Балансировка исходящего и входящего трафика.  

####Опции балансировки нагрузки.

*miimon* - частота мониторинга связности с помощью статуса Media Independent Interface (MII). По умолчанию 0 - мониторинг отключён. Рекомендуемое значение 100 мс.  

*arp_interval* - частота мониторинга связности с помощью ARP запросов и ответов. По умолчанию 0 - ARP мониторинг отключен.  

*arp_ip_target* - IP-адрес ARP мониторинга (для значения *arp_interval* не равного 0). Если с данного адреса нет ARP ответов, значит этот канал не работает.  

*downdelay* - задержка в миллисекундах с момента обнаружения потери связи до момента когда данный канал перестанет быть активным. Задержка для фильтрации кратковременных сбоев. По умолчанию значение 0 - без задержки.

*updelay* - аналогично *downdelay*, но задержка по включению. По умолчанию значение 0 - без задержки.

*max_bonds* - количество bond-интерфейсов, которые будут созданы при загрузке одного модуля. По умолчанию - 1.  

*primary* - определяет подчинённый интерфейс (eth0, eth1 и т.д.), который будет основным в связке. Этот интерфейс всегда будет активен, когда возможно. Опция доступна только для режима *active-backup*.  

*primary_reselect* - определяет условия выбора активного подчинённого интерфейса:  
*always* или 0 - первичный подчинённый всегда становится активным когда возможно;  
*better* или 1 - интерфейс становится активным когда скорость и duplex-режим больше, чем скорость и дуплексный режим текущего активного;  
*failure* или 2 - интерфейс становится активным только когда текущий активный становится недоступным.  
*primary_reselect* не учитывается если нет активных подчинённых интерфейсов, либо при первоначальном создании связанных интерфейсов.

[screenshot #10](https://i.imgur.com/k39aO8q.png)  
![screenshot #10](https://i.imgur.com/k39aO8q.png)  

[screenshot #11](https://i.imgur.com/bMHkPIp.png)  
![screenshot #11](https://i.imgur.com/bMHkPIp.png)  

[screenshot #12](https://i.imgur.com/wZVvf3j.png)  
![screenshot #12](https://i.imgur.com/wZVvf3j.png)  

5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

[screenshot #13](https://i.imgur.com/m7bV3Vn.png)  
![screenshot #13](https://i.imgur.com/m7bV3Vn.png)  

[screenshot #14](https://i.imgur.com/m7bV3Vn.png)  
![screenshot #14](https://i.imgur.com/m7bV3Vn.png)  
В подсети с маской /29 - восемь IP адресов.  
Из подсети с маской /24 можно получить 32-е подсети с маской /29.    
Например 10.10.10.0/29, 10.10.10.8/29, 10.10.10.16/29.

6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

[screenshot #15](https://i.imgur.com/xwaWw5B.png)  
![screenshot #15](https://i.imgur.com/xwaWw5B.png)  
Подсеть 100.64.0.0/10 для использования в сетях сервис-провайдера.  
Например 100.64.0.0/26 до 64 хостов.  

7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

Проверка ARP таблицы:  
[screenshot #16](https://i.imgur.com/5nyuZnv.png)  
![screenshot #16](https://i.imgur.com/5nyuZnv.png)  

[screenshot #17](https://i.imgur.com/FLr0zgU.png)  
![screenshot #17](https://i.imgur.com/FLr0zgU.png)  

Очистка всей ARP таблицы:  
```commandline
C:\> Remove-NetNeighbor
C:\> netsh interface ip delete arpcache
C:\> arp -d *
```
```commandline
root@vagrant:~# ip neigh flush dev eth0
```

Удаление IP из ARP таблицы:
```commandline
C:\> Remove-NetNeighbor 10.0.0.3
C:\> netsh interface ip delete arpcache  10.0.0.3
C:\> arp -d 10.0.0.3
```
```commandline
root@vagrant:~# ip neigh del 10.0.2.2 dev eth0
root@vagrant:~# arp -d 10.0.2.2
```

 ---

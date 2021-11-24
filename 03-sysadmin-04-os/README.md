# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

[screenshot #1](https://i.imgur.com/sbzD4Yw.png)  
![screenshot #1](https://i.imgur.com/sbzD4Yw.png)  

[screenshot #2](https://i.imgur.com/GKeDULI.png)  
![screenshot #2](https://i.imgur.com/GKeDULI.png)  

[screenshot #3](https://i.imgur.com/i9t83ox.png)  
![screenshot #3](https://i.imgur.com/i9t83ox.png)  

2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

[screenshot #4](https://i.imgur.com/gPc5VyX.png)  
![screenshot #4](https://i.imgur.com/gPc5VyX.png)  

Базовые метрики для:  
CPU  
```
node_cpu_seconds_total{cpu="0",mode="idle"} 83.87
node_cpu_seconds_total{cpu="0",mode="iowait"} 20.12
node_cpu_seconds_total{cpu="0",mode="irq"} 0
node_cpu_seconds_total{cpu="0",mode="nice"} 0
node_cpu_seconds_total{cpu="0",mode="softirq"} 1.12
node_cpu_seconds_total{cpu="0",mode="steal"} 0
node_cpu_seconds_total{cpu="0",mode="system"} 2.15
node_cpu_seconds_total{cpu="0",mode="user"} 1.74

node_load1 0.84
node_load15 0.2
node_load5 0.52
```

RAM  
```
node_memory_MemAvailable_bytes 1.748332544e+09
node_memory_MemFree_bytes 1.390538752e+09
node_memory_MemTotal_bytes 2.0836352e+09
node_memory_Mlocked_bytes 1.8907136e+07
node_memory_SwapCached_bytes 0
node_memory_SwapFree_bytes 1.027600384e+09
node_memory_SwapTotal_bytes 1.027600384e+09
```

disk & FS  
```
node_disk_read_bytes_total{device="dm-0"} 4.73601024e+08
node_disk_read_bytes_total{device="dm-1"} 3.342336e+06
node_disk_read_bytes_total{device="sda"} 4.87433216e+08
node_disk_read_time_seconds_total{device="dm-0"} 359.584
node_disk_read_time_seconds_total{device="dm-1"} 0.484
node_disk_read_time_seconds_total{device="sda"} 154.217

node_disk_write_time_seconds_total{device="dm-0"} 10.236
node_disk_write_time_seconds_total{device="dm-1"} 0
node_disk_write_time_seconds_total{device="sda"} 8.064
node_disk_written_bytes_total{device="dm-0"} 2.2233088e+07
node_disk_written_bytes_total{device="dm-1"} 0
node_disk_written_bytes_total{device="sda"} 2.1988352e+07

node_filesystem_free_bytes{device="/dev/mapper/vgvagrant-root",fstype="ext4",mountpoint="/"} 6.360844288e+10
node_filesystem_free_bytes{device="/dev/sda1",fstype="vfat",mountpoint="/boot/efi"} 5.35801856e+08
node_filesystem_free_bytes{device="tmpfs",fstype="tmpfs",mountpoint="/run"} 2.07671296e+08
node_filesystem_free_bytes{device="tmpfs",fstype="tmpfs",mountpoint="/run/lock"} 5.24288e+06
node_filesystem_free_bytes{device="tmpfs",fstype="tmpfs",mountpoint="/run/user/1000"} 2.0836352e+08
node_filesystem_free_bytes{device="vagrant",fstype="vboxsf",mountpoint="/vagrant"} 5.994334208e+10

node_filesystem_size_bytes{device="/dev/mapper/vgvagrant-root",fstype="ext4",mountpoint="/"} 6.5827115008e+10
node_filesystem_size_bytes{device="/dev/sda1",fstype="vfat",mountpoint="/boot/efi"} 5.35805952e+08
node_filesystem_size_bytes{device="tmpfs",fstype="tmpfs",mountpoint="/run"} 2.0836352e+08
node_filesystem_size_bytes{device="tmpfs",fstype="tmpfs",mountpoint="/run/lock"} 5.24288e+06
node_filesystem_size_bytes{device="tmpfs",fstype="tmpfs",mountpoint="/run/user/1000"} 2.0836352e+08
node_filesystem_size_bytes{device="vagrant",fstype="vboxsf",mountpoint="/vagrant"} 1.57624635392e+11
```

network    
```
-node_netstat_Ip6_InOctets 861701
-:node_netstat_Ip6_OutOctets 864085
--node_netstat_IpExt_InOctets 306833
:node_netstat_IpExt_OutOctets 235019
```

3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

[screenshot #5](https://i.imgur.com/ylWZdMs.png)  
![screenshot #5](https://i.imgur.com/ylWZdMs.png)  

[screenshot #6](https://i.imgur.com/n40Eo3L.png)  
![screenshot #6](https://i.imgur.com/n40Eo3L.png)  

4.Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?

Можно  
[screenshot #7 "виртуалка"](https://i.imgur.com/ff26rkp.png)  
![screenshot #7 "виртуалка"](https://i.imgur.com/ff26rkp.png)  

[screenshot #8 хост](https://i.imgur.com/07mRKXf.png)  
![screenshot #8 хост](https://i.imgur.com/07mRKXf.png)  

5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?

[screenshot #9](https://i.imgur.com/NtYCTIL.png)  
![screenshot #9](https://i.imgur.com/NtYCTIL.png)  

Это ограничение количества открытых файловых дескрипторов.  

[screenshot #10](https://i.imgur.com/xpS9ODd.png)  
![screenshot #10](https://i.imgur.com/xpS9ODd.png)  

[screenshot #11](https://i.imgur.com/w2ngvmQ.png)  
![screenshot #11](https://i.imgur.com/w2ngvmQ.png)  

[screenshot #12](https://i.imgur.com/IyIl5Wg.png)  
![screenshot #12](https://i.imgur.com/IyIl5Wg.png)  

Не позволит достичь 1048576 лимит `open files` = 1024.  

[screenshot #13](https://i.imgur.com/dNlWFAH.png)  
![screenshot #13](https://i.imgur.com/dNlWFAH.png)  

6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.

[screenshot #15](https://i.imgur.com/C6qRliC.png)  
![screenshot #15](https://i.imgur.com/C6qRliC.png)  

[screenshot #14](https://i.imgur.com/Oxljoov.png)  
![screenshot #14](https://i.imgur.com/Oxljoov.png)  

7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

`:(){ :|:& };:` - это команда функции с наименованием `:`, запускающая сама себя дважды.  
```
:()      # name function 
{
   :|:&  # body function
};       # завершение первой команды
:        # вызов функции
```
Сработал контроллер номера процесса.  
[screenshot #15](https://i.imgur.com/52O3322.png)  
![screenshot #15](https://i.imgur.com/52O3322.png)  
Контроллер номера процесса останавливает выполнение новых задач fork, clone свыше установленного предела.    
Лимит количества процессов для сессии пользователя  
```
$ ulimit -u
7732
```
Переопределить лимит можно в файле `/etc/security/limits.conf`  
[screenshot #16](https://i.imgur.com/CORO3Fx.png)  
![screenshot #16](https://i.imgur.com/CORO3Fx.png) 

 ---

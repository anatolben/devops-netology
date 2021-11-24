# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

[pic #1](https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Sparse_file_%28en%29.svg/1200px-Sparse_file_%28en%29.svg.png)  
![pic #1](https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Sparse_file_%28en%29.svg/1200px-Sparse_file_%28en%29.svg.png)  

2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Не могут. Потому, что жёсткие ссылки это записи в файловой таблице, указывающие на один и тот же inode файла. Поэтому они имеют те же права и владельца, что и сам файл.  

3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

[screenshot #1](https://i.imgur.com/VN7gPpq.png)  
![screenshot #1](https://i.imgur.com/VN7gPpq.png)  

4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

[screenshot #2](https://i.imgur.com/CnQfvew.png)  
![screenshot #2](https://i.imgur.com/CnQfvew.png)  

[screenshot #3](https://i.imgur.com/i71QcK8.png)  
![screenshot #3](https://i.imgur.com/i71QcK8.png)  

5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

[screenshot #4](https://i.imgur.com/o6i4O0v.png)  
![screenshot #4](https://i.imgur.com/o6i4O0v.png)  

[screenshot #5](https://i.imgur.com/kg2QeFN.png)  
![screenshot #5](https://i.imgur.com/kg2QeFN.png)  

6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

[screenshot #6](https://i.imgur.com/h60he81.png)  
![screenshot #6](https://i.imgur.com/h60he81.png)  

7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

[screenshot #7](https://i.imgur.com/d0gCF7u.png)  
![screenshot #7](https://i.imgur.com/d0gCF7u.png)  

8. Создайте 2 независимых PV на получившихся md-устройствах.

[screenshot #8](https://i.imgur.com/PHMRiZn.png)  
![screenshot #8](https://i.imgur.com/PHMRiZn.png)  

[screenshot #9](https://i.imgur.com/ESOSAG9.png)  
![screenshot #9](https://i.imgur.com/ESOSAG9.png)  

9. Создайте общую volume-group на этих двух PV.

[screenshot #10](https://i.imgur.com/TkwS7rI.png)  
![screenshot #10](https://i.imgur.com/TkwS7rI.png)  

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

[screenshot #11](https://i.imgur.com/O0toDB0.png)  
![screenshot #11](https://i.imgur.com/O0toDB0.png) 

[screenshot #12](https://i.imgur.com/9WOO5sC.png)  
![screenshot #12](https://i.imgur.com/9WOO5sC.png) 

11. Создайте `mkfs.ext4` ФС на получившемся LV.

[screenshot #13](https://i.imgur.com/nDTr8I1.png)  
![screenshot #13](https://i.imgur.com/nDTr8I1.png) 

12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

[screenshot #14](https://i.imgur.com/s0jc0RM.png)  
![screenshot #14](https://i.imgur.com/s0jc0RM.png) 

13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

[screenshot #15](https://i.imgur.com/HTyHcQ4.png)  
![screenshot #15](https://i.imgur.com/HTyHcQ4.png) 

14. Прикрепите вывод `lsblk`.

[screenshot #16](https://i.imgur.com/hcBaggk.png)  
![screenshot #16](https://i.imgur.com/hcBaggk.png)  

15. Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
[screenshot #17](https://i.imgur.com/HDCOSJm.png)  
![screenshot #17](https://i.imgur.com/HDCOSJm.png)  

16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

[screenshot #18](https://i.imgur.com/hnrX8P8.png)  
![screenshot #18](https://i.imgur.com/hnrX8P8.png)  

17. Сделайте `--fail` на устройство в вашем RAID1 md.

[screenshot #19](https://i.imgur.com/MJpx8Ds.png)  
![screenshot #19](https://i.imgur.com/MJpx8Ds.png)  

[screenshot #20](https://i.imgur.com/oeCtfgp.png)  
![screenshot #20](https://i.imgur.com/oeCtfgp.png)  

18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

[screenshot #21](https://i.imgur.com/VYRoOFn.png)  
![screenshot #21](https://i.imgur.com/VYRoOFn.png)  

19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
[screenshot #22](https://i.imgur.com/oHzHrC4.png)  
![screenshot #22](https://i.imgur.com/oHzHrC4.png)  

20. Погасите тестовый хост, `vagrant destroy`.

[screenshot #23](https://i.imgur.com/oHzHrC4.png)  
![screenshot #23](https://i.imgur.com/knQf6Qf.png)  
 
 ---
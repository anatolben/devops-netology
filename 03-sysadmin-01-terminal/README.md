# Решение домашнего задание к занятию "3.1. Работа в терминале, лекция 1"

1. Установите средство виртуализации [Oracle VirtualBox](https://www.virtualbox.org/).

1. Установите средство автоматизации [Hashicorp Vagrant](https://www.vagrantup.com/).

[screenshot #1](https://i.imgur.com/zGiCKDT.png)
![screenshot #1](https://i.imgur.com/zGiCKDT.png)

1. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал. Можно предложить:

	* iTerm2 в Mac OS X
	* Windows Terminal в Windows
	* выбрать цветовую схему, размер окна, шрифтов и т.д.
	* почитать о кастомизации PS1/применить при желании.

	Несколько популярных проблем:
	* Добавьте Vagrant в правила исключения перехватывающих трафик для анализа антивирусов, таких как Kaspersky, если у вас возникают связанные с SSL/TLS ошибки,
	* MobaXterm может конфликтовать с Vagrant в Windows,
	* Vagrant плохо работает с директориями с кириллицей (может быть вашей домашней директорией), тогда можно либо изменить [VAGRANT_HOME](https://www.vagrantup.com/docs/other/environmental-variables#vagrant_home), либо создать в системе профиль пользователя с английским именем,
	* VirtualBox конфликтует с Windows Hyper-V и его необходимо [отключить](https://www.vagrantup.com/docs/installation#windows-virtualbox-and-hyper-v),
	* [WSL2](https://docs.microsoft.com/ru-ru/windows/wsl/wsl2-faq#does-wsl-2-use-hyper-v-will-it-be-available-on-windows-10-home) использует Hyper-V, поэтому с ним VirtualBox также несовместим,
	* аппаратная виртуализация (Intel VT-x, AMD-V) должна быть активна в BIOS,
	* в Linux при установке [VirtualBox](https://www.virtualbox.org/wiki/Linux_Downloads) может дополнительно потребоваться пакет `linux-headers-generic` (debian-based) / `kernel-devel` (rhel-based).

[screenshot #2](https://i.imgur.com/F67FxQz.png)
![screenshot #2](https://i.imgur.com/F67FxQz.png)

1. С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant:

    * Создайте директорию, в которой будут храниться конфигурационные файлы Vagrant. В ней выполните `vagrant init`. Замените содержимое Vagrantfile по умолчанию следующим:

        ```bash
        Vagrant.configure("2") do |config|
            config.vm.box = "bento/ubuntu-20.04"
        end
        ```

    * Выполнение в этой директории `vagrant up` установит провайдер VirtualBox для Vagrant, скачает необходимый образ и запустит виртуальную машину.

    * `vagrant suspend` выключит виртуальную машину с сохранением ее состояния (т.е., при следующем `vagrant up` будут запущены все процессы внутри, которые работали на момент вызова suspend), `vagrant halt` выключит виртуальную машину штатным образом.

[screenshot #3](https://i.imgur.com/BVvse9n.png)
![screenshot #3](https://i.imgur.com/BVvse9n.png)

1. Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?

[screenshot #4](https://i.imgur.com/hjjOavA.png)
![screenshot #4](https://i.imgur.com/hjjOavA.png)
[screenshot #5](https://i.imgur.com/wUIAXp1.png)
![screenshot #5](https://i.imgur.com/wUIAXp1.png)
RamSize 1024 MB, Logical CPUs 2, VRamSize 4 MB, vHDD 64 GB  

1. Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: [документация](https://www.vagrantup.com/docs/providers/virtualbox/configuration.html). Как добавить оперативной памяти или ресурсов процессора виртуальной машине?

[screenshot #6](https://i.imgur.com/4jGXuPD.png)
![screenshot #6](https://i.imgur.com/4jGXuPD.png)

1. Команда `vagrant ssh` из директории, в которой содержится Vagrantfile, позволит вам оказаться внутри виртуальной машины без каких-либо дополнительных настроек. Попрактикуйтесь в выполнении обсуждаемых команд в терминале Ubuntu.

[screenshot #7](https://i.imgur.com/LBNhjCq.png)
![screenshot #7](https://i.imgur.com/LBNhjCq.png)

2. Ознакомиться с разделами `man bash`, почитать о настройках самого bash:
    * какой переменной можно задать длину журнала `history`, и на какой строчке manual это описывается?
    * что делает директива `ignoreboth` в bash?

[screenshot #8](https://i.imgur.com/WgWR7LY.png)
![screenshot #8](https://i.imgur.com/WgWR7LY.png)
Переменной `HISTSIZE`, на строке 696.  

В переменной bash `HISTCONTROL` значение `ignoreboth` является сокращением, и заменяет два значения `ignorespace` и `ignoredups`.  
Служит для исключения из истории команд строк начинающихся с пробела и соответствующих предыдущей записи.  

4. В каких сценариях использования применимы скобки `{}` и на какой строчке `man bash` это описано?

[screenshot #9](https://i.imgur.com/Q5N18ve.png)
![screenshot #9](https://i.imgur.com/Q5N18ve.png)
`{ }` - зарезервированные символы(слова) bash. Строка 147.  

[screenshot #10](https://i.imgur.com/j1H7CHa.png)
![screenshot #10](https://i.imgur.com/j1H7CHa.png)
Фигурные скобки применяются в составных командах для исполнения в текущей среде bash. Строка 211.  

[screenshot #11](https://i.imgur.com/JGpWwFx.png)
![screenshot #11](https://i.imgur.com/JGpWwFx.png)
Фигурные скобки применяются для сокращений при перечислении аргументов команд, содержат внутри текстовый список. Строка 869.  

6. С учётом ответа на предыдущий вопрос, как создать однократным вызовом `touch` 100000 файлов? Получится ли аналогичным образом создать 300000? Если нет, то почему?

Создать 100000 файлов `touch {00000..99999}`  
Строка аргумента в команде создания 300000 файлов `touch {000000..299999}` содержит 2 100 000 символов `echo {000000..299999} | wc -m`.  
Но в ядре Linux существует ограничение на общий размер аргументов командной строки, определяемое значением `ARG_MAX`.  
`getconf ARG_MAX` вернёт значение по умолчанию 2 097 152, что меньше требуемого размера аргумента для создания 300000 файлов.  
Поэтому выполнение команды `touch {000000..299999}` приведет к ошибке `Argument list too long`  
Константа `ARG_MAX` устанавливается автоматически начиная с ядра Linux v 2.6.23, и равна 1/4 от мягкого (soft) размера стека.  
Мягкий размер стека по умолчанию 8192 kbytes `ulimit -aS`.  
8192 kbytes / 4 = 2 097 152 bytes  

8. В man bash поищите по `/\[\[`. Что делает конструкция `[[ -d /tmp ]]`

`[[ -d /tmp ]]` проверяет условие существования директории, если директория существует возвращает истина.  

10. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:

     ```bash
     bash is /tmp/new_path_directory/bash
     bash is /usr/local/bin/bash
     bash is /bin/bash
     ```

     (прочие строки могут отличаться содержимым и порядком)
     В качестве ответа приведите команды, которые позволили вам добиться указанного вывода или соответствующие скриншоты.

`{ mkdir -p /tmp/new_path_directory/; cp $(type -ap bash | tail -n 1) /tmp/new_path_directory/bash; PATH=/tmp/new_path_directory:$PATH; type -a bash; }`  

11. Чем отличается планирование команд с помощью `batch` и `at`?

`batch` не имеет агрументов, принимает команды из стандартного ввода, запускает на выполнение в зависимости от нагрузки системы.  
`at` имеет различные параметры запуска, может принять команды из файла, запускает на выполнение в заданное время.  

12. Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.

[screenshot #12](https://i.imgur.com/50UsQ0B.png)
![screenshot #12](https://i.imgur.com/50UsQ0B.png) 

 ---
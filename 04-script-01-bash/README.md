# Решение домашнего задания к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательная задача 1

Есть скрипт:
```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```

Какие значения переменным c,d,e будут присвоены? Почему?

| Переменная | Значение | Обоснование                                                                                                                          |
|------------|----------|--------------------------------------------------------------------------------------------------------------------------------------|
| `c`        | a+b      | Потому что запись 'a+b' после знака '=' это строка.                                                                                  |
| `d`        | 1+2      | Потому, что '$a' вернет значение этой переменной - '1', далее следует строка '+', за ней '$b' вернет значение этой переменной - '2'. |
| `e`        | 3        | Это результат арифметического действия сложения между значениями переменных '$a' и '$b'.                                             |


## Обязательная задача 2
На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным (после чего скрипт должен завершиться). В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
```bash
while ((1==1)
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date >> curl.log
	fi
done
```

### Cкрипт решение:
```bash
#!/usr/bin/env bash

while ((1==1))
do
	curl https://localhost:4757 
	if !(($? > 0))
	then
		date >> curl.log
	else
		break
	fi
done
```

## Обязательная задача 3
Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### Скрипт решение:
```bash
$ cat ./open_port.sh
#!/usr/bin/env bash

# Launching a script with the parameter file name that contains a list of IP.
# Format this file is: 'IP0,IP1,...IPn'
#

# set environments
port="80"
log_file="./open_port.log"
cnt=5
nc_key="-vzw3"


# functions
nc_call(){ # keys ip port log
   [[ -z $2 || -z $3  || -z $4 ]] && printf "nc empty param...\n" && exit 3
    nc $1 $2 $3 >> $4 2>&1
}


# body
date > $file_log
[[ -z $1 ]] && printf "empty param file name\n" && exit 2
IFS=","
array_str=( $(cat $1) )
for ip_addr in ${array_str[@]}
do
   cnt_c=$cnt
   while (($cnt_c > 0))
   do
      nc_call $nc_key $ip_addr $port $log_file
      let "cnt_c -= 1"
   done
done
```
```bash
printf "192.168.0.1,173.194.222.113,87.250.250.242" > list_ip.txt
./open_port.sh list_ip.txt
```
```bash
$ cat ./open_port.log
Пн 13 дек 2021 18:28:47 +04
nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 87.250.250.242 80 port [tcp/http] succeeded!
Connection to 87.250.250.242 80 port [tcp/http] succeeded!
Connection to 87.250.250.242 80 port [tcp/http] succeeded!
Connection to 87.250.250.242 80 port [tcp/http] succeeded!
Connection to 87.250.250.242 80 port [tcp/http] succeeded!
```

## Обязательная задача 4
Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

### Скрипт решение:
```bash
$ cat ./open_port.sh
#!/usr/bin/env bash

# Launching a script with the parameter file name that contains a list of IP.
# Format this file is: 'IP0,IP1,...IPn'
#

# set environments
#array_str=("192.168.0.1" "173.194.222.113" "87.250.250.242")
port="80"
file_log="./open_port.log"
file_err="./error"
cnt=5
nc_key="-vzw3"


# functions
nc_call(){ # keys ip port log
   [[ -z $2 || -z $3  || -z $4 ]] && printf "nc empty param...\n" && exit 3
    nc $1 $2 $3 >> $4 2>&1
}


# body
date > $file_log
[[ -z $1 ]] && printf "empty param file name\n" && exit 2
IFS=","
array_str=( $(cat $1) )
while [ 1 = 1 ]; do
   for ip_addr in ${array_str[@]}; do
      cnt_c=$cnt
      while (($cnt_c > 0)); do
         nc_call $nc_key $ip_addr $port $file_log
         r_code=$?
         [[ $r_code -eq 1 ]] && break && printf "$ip_addr\n" > $file_err
         let "cnt_c -= 1"
      done
      [[ $r_code -eq 1 ]] && break
   done
   [[ $r_code -eq 1 ]] && break
done
```
```bash
printf "173.194.222.113,192.168.0.1,87.250.250.242" > list_ip.txt
./open_port.sh list_ip.txt
```
```bash
$ cat ./open_port.log
Вт 14 дек 2021 13:38:01 +04
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
$ cat ./error 
192.168.0.1
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Мы хотим, чтобы у нас были красивые сообщения для коммитов в репозиторий. Для этого нужно написать локальный хук для git, который будет проверять, что сообщение в коммите содержит код текущего задания в квадратных скобках и количество символов в сообщении не превышает 30. Пример сообщения: \[04-script-01-bash\] сломал хук.

### Cкрипт решение:
```bash
$ cat ./commit-msg
#!/usr/bin/env bash

((${#1}<=30)) || {
    printf "ERROR: Commit message contains more than 30 characters.\n" >&2
    exit 1
}

[[ "$1" =~ ^\[[0-9]+-[a-zA-Z]+-[0-9]+-[a-zA-Z]+\].*$ ]] || {
    printf "ERROR: Commit message does not match the format. Must start with '[numbers-letters-numbers-letters]'.\n" >&2
    exit 1
}
```
___
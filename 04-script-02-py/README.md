# Решение домашнего задания к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос                                         | Ответ                                                                  |
|------------------------------------------------|------------------------------------------------------------------------|
| Какое значение будет присвоено переменной `c`? | никакое, TypeError: unsupported operand type(s) for +: 'int' and 'str' |
| Как получить для переменной `c` значение 12?   | c = str(a) + b                                                         |
| Как получить для переменной `c` значение 3?    | c = a + int(b)                                                         |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command))).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Скрипт решение:
```python
#!/usr/bin/env python3

import os

find_text = "modified"
path_text = os.path.abspath(os.path.expanduser("~/netology/sysadm-homeworks"))
bash_command = ["cd " + path_text, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find(find_text) != -1:
        prepare_result = result.replace('\t' + find_text + ':      ', '')
        print(path_text + '/' + prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```bash
$ ./script.py
/home/snark/netology/sysadm-homeworks/03-sysadmin-09-security/README.md
/home/snark/netology/sysadm-homeworks/04-script-01-bash/README.md
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Скрипт решение:
```python
#!/usr/bin/env python3

# The script is launched with one parameter - the path to the local git repository.
# Example: $./script.py "~/netology/sysadm-homeworks"
#

import os, sys

var_1 = sys.argv[1]
modified_text = ('изменено', 'modified')
not_git_text = ('не найден git', 'not a git')
home_norm = os.path.expanduser(var_1)
if not var_1 or os.path.isdir(home_norm) != 1:
    print(var_1 + ": this parameter is empty or the specified directory does not exist.")
    sys.exit()
path_text = os.path.abspath(home_norm)
bash_command = ["cd " + path_text, "git status 2>&1"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    for find_text in not_git_text:
        if result.find(find_text) != -1:
            print(path_text + ": this directory is not a git repository.")
            is_change = True
    for find_text in modified_text:
        if result.find(find_text) != -1:
            prepare_result = result.replace('\t' + find_text + ':      ','')
            print(path_text + "/" + prepare_result)
            is_change = True
if is_change != 1:
    print(path_text + ": there are no changes in this git repository.")
```

### Вывод скрипта при запуске при тестировании:
```bash
$ ./script.py ".1234"
.1234: this parameter is empty or the specified directory does not exist.
$ ./script.py "~/netology/sysadm-homeworks"
/home/snark/netology/sysadm-homeworks/03-sysadmin-09-security/README.md
/home/snark/netology/sysadm-homeworks/04-script-01-bash/README.md
$ ./script.py "~/netology/"
/home/snark/netology: this directory is not a git repository.
$ ./script.py "./"
/home/snark/PycharmProjects/netology.devops/04-script-02-py: there are no changes in this git repository.
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Скрипт решение:
```python
#!/usr/bin/env python3

# This script checks the services specified in 'urls' (format urls: ('abc.com', ..., 'def.xyz.co'))
# Validation succeeded if HTTP status code 200 was received.
# And the IP address of the service has not changed since the last check.
#

import os, requests, socket, json
from requests.exceptions import ConnectTimeout
from requests.exceptions import ConnectionError
from contextlib import suppress

urls = ('drive.google.com', 'mail.google.com', 'google.com')
last_dict = {}
prev_dict = {}
file_json = "services_ip.json"
prefix = "http://"
request_timeout = 3
if os.path.isfile(file_json):
    with open(file_json) as json_file:
        data = json.load(json_file)
        prev_dict = data['Last'][0]
for url in urls:
    rt = 0
    with suppress(ConnectTimeout):
        with suppress(ConnectionError):
            r = requests.get(prefix+url, verify=True, timeout=request_timeout)
            rt = r.status_code
    if rt == 200:
        ip = socket.gethostbyname(url)
        ip_prev = ip
        print(url+' - '+ip)
        ip_prev = prev_dict.get(url)
        if ip != ip_prev and ip_prev:
            print('[ERROR] '+url+' IP mismatch: '+str(ip_prev)+' '+ip)
    else:
        print('[ERROR] '+prefix+url+' return status code: '+str(rt))
        ip = "error"
    last_dict[url] = ip
json_dict = {'Last': [last_dict], 'Previous': [prev_dict]}
with open(file_json, "w") as outfile:
    json.dump(json_dict, outfile, indent=4, sort_keys=False)
```

### Вывод скрипта при запуске при тестировании:
```bash
$ ./script.py
drive.google.com - 64.233.164.194
mail.google.com - 64.233.164.17
google.com - 64.233.165.101
$ ./script.py
drive.google.com - 108.177.14.194
[ERROR] drive.google.com IP mismatch: 64.233.164.194 108.177.14.194
mail.google.com - 74.125.205.19
[ERROR] mail.google.com IP mismatch: 64.233.164.17 74.125.205.19
google.com - 64.233.162.102
[ERROR] google.com IP mismatch: 64.233.165.101 64.233.162.102
$ cat services_ip.json 
{
    "Last": [
        {
            "drive.google.com": "108.177.14.194",
            "mail.google.com": "74.125.205.19",
            "google.com": "64.233.162.102"
        }
    ],
    "Previous": [
        {
            "drive.google.com": "64.233.164.194",
            "mail.google.com": "64.233.164.17",
            "google.com": "64.233.165.101"
        }
    ]
```
---
# Решение домашнего задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

```json
{
    "info":"Sample JSON output from our service\t",
    "elements":[
        {
            "name":"first",
            "type":"server",
            "ip":"71.78.71.75"
        },
        {
            "name":"second",
            "type":"proxy",
            "ip":"71.78.22.43"
        }
    ]
}
```

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Скрипт решение:
```python
#!/usr/bin/env python3

# This script checks the services specified in 'urls' (format urls: ('abc.com', ..., 'def.xyz.co'))
# Validation succeeded if HTTP status code 200 was received.
# And the IP address of the service has not changed since the last check.
#

import os, requests, socket, json, yaml
from requests.exceptions import ConnectTimeout
from requests.exceptions import ConnectionError
from contextlib import suppress

urls = ('drive.google.com', 'mail.google.com', 'google.com')
last_dict = {}
prev_dict = {}
serv_list = []
file_json = "services_ip.json"
serv_json = "services.json"
serv_yaml = "services.yml"
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
        url_dict = {url: ip}
        serv_list.append(url_dict)
    else:
        print('[ERROR] '+prefix+url+' return status code: '+str(rt))
        ip = "error"
    last_dict[url] = ip
json_dict = {'Last': [last_dict], 'Previous': [prev_dict]}
with open(file_json, "w") as outjson:
    json.dump(json_dict, outjson, indent=4, sort_keys=False)
with open(serv_json, "w") as urloutjson:
    urloutjson.write(json.dumps(serv_list))
with open(serv_yaml, "w") as urloutyaml:
    yaml.dump(serv_list, urloutyaml)
```

### Вывод скрипта при запуске при тестировании:
```bash
$ ./script.py
drive.google.com - 108.177.14.194
mail.google.com - 74.125.205.18
[ERROR] mail.google.com IP mismatch: 74.125.205.17 74.125.205.18
google.com - 64.233.162.100
[ERROR] google.com IP mismatch: 64.233.162.101 64.233.162.100
```

### json-файл (services.json), который записал скрипт:
```json
[{"drive.google.com": "108.177.14.194"}, {"mail.google.com": "74.125.205.18"}, {"google.com": "64.233.162.100"}]
```

### yml-файл (services.yml), который записал скрипт:
```yaml
- drive.google.com: 108.177.14.194
- mail.google.com: 74.125.205.18
- google.com: 64.233.162.100
```

---

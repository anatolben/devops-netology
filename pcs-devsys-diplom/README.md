# Курсовая работа по итогам модуля "DevOps и системное администрирование"

## Задание

1. Создайте виртуальную машину Linux.
2. Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.
3. Установите hashicorp vault ([инструкция по ссылке](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started#install-vault)).
4. Cоздайте центр сертификации по инструкции ([ссылка](https://learn.hashicorp.com/tutorials/vault/pki-engine?in=vault/secrets-management)) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).
5. Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.
6. Установите nginx.
7. По инструкции ([ссылка](https://nginx.org/en/docs/http/configuring_https_servers.html)) настройте nginx на https, используя ранее подготовленный сертификат:
  - можно использовать стандартную стартовую страницу nginx для демонстрации работы сервера;
  - можно использовать и другой html файл, сделанный вами;
8. Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.
9. Создайте скрипт, который будет генерировать новый сертификат в vault:
  - генерируем новый сертификат так, чтобы не переписывать конфиг nginx;
  - перезапускаем nginx для применения нового сертификата.
10. Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.

## Результат

Результатом курсовой работы должны быть снимки экрана или текст:

- Процесс установки и настройки ufw

[uwf 1](https://i.imgur.com/1VGLmSc.png)  
![uwf 1](https://i.imgur.com/1VGLmSc.png)  

[uwf 2](https://i.imgur.com/RhqmnAK.png)  
![uwf 2](https://i.imgur.com/RhqmnAK.png)  


[vault 1](https://i.imgur.com/qZXlftH.png)  
![vault 1](https://i.imgur.com/qZXlftH.png)  

[vault 2](https://i.imgur.com/kaupJxc.png)  
![vault 2](https://i.imgur.com/kaupJxc.png)  

[vault 3](https://i.imgur.com/bQ9BuCG.png)  
![vault 3](https://i.imgur.com/bQ9BuCG.png)  

[vault 4](https://i.imgur.com/SMyqWCd.png)  
![vault 4](https://i.imgur.com/SMyqWCd.png)  

[vault 5](https://i.imgur.com/CBTrUFz.png)  
![vault 5](https://i.imgur.com/CBTrUFz.png)  

[vault 6](https://i.imgur.com/Frewlyq.png)  
![vault 6](https://i.imgur.com/Frewlyq.png)  

- Процесс установки и выпуска сертификата с помощью hashicorp vault

[vault 7](https://i.imgur.com/J3Fn6R2.png)  
![vault 7](https://i.imgur.com/J3Fn6R2.png)  

[vault 8](https://i.imgur.com/fC7Z1lz.png)  
![vault 8](https://i.imgur.com/fC7Z1lz.png)  

- Процесс установки и настройки сервера nginx
```bash
root@vagrant:~# cat /etc/apt/sources.list.d/nginx.list
deb https://nginx.org/packages/ubuntu/ focal nginx
deb-src https://nginx.org/packages/ubuntu/ focal nginx
root@vagrant:~# apt-get update
Hit:1 https://apt.releases.hashicorp.com focal InRelease                           
Hit:2 http://us.archive.ubuntu.com/ubuntu focal InRelease                          
Get:3 http://us.archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]
Get:4 https://nginx.org/packages/ubuntu focal InRelease [3,584 B]           
Hit:5 http://us.archive.ubuntu.com/ubuntu focal-backports InRelease
Err:4 https://nginx.org/packages/ubuntu focal InRelease
  The following signatures couldn't be verified because the public key is not available: NO_PUBKEY ABF5BD827BD9BF62
Get:6 http://us.archive.ubuntu.com/ubuntu focal-security InRelease [114 kB]
Get:7 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [1,440 kB]
Get:8 http://us.archive.ubuntu.com/ubuntu focal-updates/main Translation-en [288 kB]
Get:9 http://us.archive.ubuntu.com/ubuntu focal-updates/restricted amd64 Packages [657 kB]
Get:10 http://us.archive.ubuntu.com/ubuntu focal-updates/restricted Translation-en [93.8 kB]
Get:11 http://us.archive.ubuntu.com/ubuntu focal-updates/universe amd64 Packages [885 kB]
Get:12 http://us.archive.ubuntu.com/ubuntu focal-updates/universe Translation-en [193 kB]
Get:13 http://us.archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 Packages [24.8 kB]
Get:14 http://us.archive.ubuntu.com/ubuntu focal-security/main amd64 Packages [1,106 kB]
Get:15 http://us.archive.ubuntu.com/ubuntu focal-security/main Translation-en [201 kB]
Get:16 http://us.archive.ubuntu.com/ubuntu focal-security/restricted amd64 Packages [606 kB]
Get:17 http://us.archive.ubuntu.com/ubuntu focal-security/restricted Translation-en [86.3 kB]
Get:18 http://us.archive.ubuntu.com/ubuntu focal-security/universe amd64 Packages [668 kB]
Get:19 http://us.archive.ubuntu.com/ubuntu focal-security/multiverse amd64 Packages [21.8 kB]
Reading package lists... Done        
W: GPG error: https://nginx.org/packages/ubuntu focal InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY ABF5BD827BD9BF62
E: The repository 'https://nginx.org/packages/ubuntu focal InRelease' is not signed.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
root@vagrant:~# apt-get install nginx
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  fontconfig-config fonts-dejavu-core libfontconfig1 libgd3 libjbig0 libjpeg-turbo8 libjpeg8 libnginx-mod-http-image-filter
  libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream libtiff5 libwebp6 libx11-6 libx11-data libxau6 libxcb1 libxdmcp6
  libxpm4 nginx-common nginx-core
Suggested packages:
  libgd-tools fcgiwrap nginx-doc ssl-cert
The following NEW packages will be installed:
  fontconfig-config fonts-dejavu-core libfontconfig1 libgd3 libjbig0 libjpeg-turbo8 libjpeg8 libnginx-mod-http-image-filter
  libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream libtiff5 libwebp6 libx11-6 libx11-data libxau6 libxcb1 libxdmcp6
  libxpm4 nginx nginx-common nginx-core
0 upgraded, 22 newly installed, 0 to remove and 10 not upgraded.
Need to get 3,183 kB of archives.
After this operation, 11.1 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://us.archive.ubuntu.com/ubuntu focal/main amd64 libxau6 amd64 1:1.0.9-0ubuntu1 [7,488 B]
Get:2 http://us.archive.ubuntu.com/ubuntu focal/main amd64 libxdmcp6 amd64 1:1.1.3-0ubuntu1 [10.6 kB]
Get:3 http://us.archive.ubuntu.com/ubuntu focal/main amd64 libxcb1 amd64 1.14-2 [44.7 kB]
Get:4 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 libx11-data all 2:1.6.9-2ubuntu1.2 [113 kB]
Get:5 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 libx11-6 amd64 2:1.6.9-2ubuntu1.2 [575 kB]
Get:6 http://us.archive.ubuntu.com/ubuntu focal/main amd64 fonts-dejavu-core all 2.37-1 [1,041 kB]
Get:7 http://us.archive.ubuntu.com/ubuntu focal/main amd64 fontconfig-config all 2.13.1-2ubuntu3 [28.8 kB]
Get:8 http://us.archive.ubuntu.com/ubuntu focal/main amd64 libfontconfig1 amd64 2.13.1-2ubuntu3 [114 kB]
Get:9 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 libjpeg-turbo8 amd64 2.0.3-0ubuntu1.20.04.1 [117 kB]
Get:10 http://us.archive.ubuntu.com/ubuntu focal/main amd64 libjpeg8 amd64 8c-2ubuntu8 [2,194 B]
Get:11 http://us.archive.ubuntu.com/ubuntu focal/main amd64 libjbig0 amd64 2.1-3.1build1 [26.7 kB]
Get:12 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 libwebp6 amd64 0.6.1-2ubuntu0.20.04.1 [185 kB]
Get:13 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 libtiff5 amd64 4.1.0+git191117-2ubuntu0.20.04.2 [162 kB]
Get:14 http://us.archive.ubuntu.com/ubuntu focal/main amd64 libxpm4 amd64 1:3.5.12-1 [34.0 kB]
Get:15 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 libgd3 amd64 2.2.5-5.2ubuntu2.1 [118 kB]
Get:16 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 nginx-common all 1.18.0-0ubuntu1.2 [37.5 kB]
Get:17 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 libnginx-mod-http-image-filter amd64 1.18.0-0ubuntu1.2 [14.4 kB]
Get:18 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 libnginx-mod-http-xslt-filter amd64 1.18.0-0ubuntu1.2 [12.7 kB]
Get:19 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 libnginx-mod-mail amd64 1.18.0-0ubuntu1.2 [42.5 kB]
Get:20 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 libnginx-mod-stream amd64 1.18.0-0ubuntu1.2 [67.3 kB]
Get:21 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 nginx-core amd64 1.18.0-0ubuntu1.2 [425 kB]
Get:22 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 nginx all 1.18.0-0ubuntu1.2 [3,620 B]
Fetched 3,183 kB in 2s (1,398 kB/s)
Preconfiguring packages ...
Selecting previously unselected package libxau6:amd64.
(Reading database ... 41060 files and directories currently installed.)
Preparing to unpack .../00-libxau6_1%3a1.0.9-0ubuntu1_amd64.deb ...
Unpacking libxau6:amd64 (1:1.0.9-0ubuntu1) ...
Selecting previously unselected package libxdmcp6:amd64.
Preparing to unpack .../01-libxdmcp6_1%3a1.1.3-0ubuntu1_amd64.deb ...
Unpacking libxdmcp6:amd64 (1:1.1.3-0ubuntu1) ...
Selecting previously unselected package libxcb1:amd64.
Preparing to unpack .../02-libxcb1_1.14-2_amd64.deb ...
Unpacking libxcb1:amd64 (1.14-2) ...
Selecting previously unselected package libx11-data.
Preparing to unpack .../03-libx11-data_2%3a1.6.9-2ubuntu1.2_all.deb ...
Unpacking libx11-data (2:1.6.9-2ubuntu1.2) ...
Selecting previously unselected package libx11-6:amd64.
Preparing to unpack .../04-libx11-6_2%3a1.6.9-2ubuntu1.2_amd64.deb ...
Unpacking libx11-6:amd64 (2:1.6.9-2ubuntu1.2) ...
Selecting previously unselected package fonts-dejavu-core.
Preparing to unpack .../05-fonts-dejavu-core_2.37-1_all.deb ...
Unpacking fonts-dejavu-core (2.37-1) ...
Selecting previously unselected package fontconfig-config.
Preparing to unpack .../06-fontconfig-config_2.13.1-2ubuntu3_all.deb ...
Unpacking fontconfig-config (2.13.1-2ubuntu3) ...
Selecting previously unselected package libfontconfig1:amd64.
Preparing to unpack .../07-libfontconfig1_2.13.1-2ubuntu3_amd64.deb ...
Unpacking libfontconfig1:amd64 (2.13.1-2ubuntu3) ...
Selecting previously unselected package libjpeg-turbo8:amd64.
Preparing to unpack .../08-libjpeg-turbo8_2.0.3-0ubuntu1.20.04.1_amd64.deb ...
Unpacking libjpeg-turbo8:amd64 (2.0.3-0ubuntu1.20.04.1) ...
Selecting previously unselected package libjpeg8:amd64.
Preparing to unpack .../09-libjpeg8_8c-2ubuntu8_amd64.deb ...
Unpacking libjpeg8:amd64 (8c-2ubuntu8) ...
Selecting previously unselected package libjbig0:amd64.
Preparing to unpack .../10-libjbig0_2.1-3.1build1_amd64.deb ...
Unpacking libjbig0:amd64 (2.1-3.1build1) ...
Selecting previously unselected package libwebp6:amd64.
Preparing to unpack .../11-libwebp6_0.6.1-2ubuntu0.20.04.1_amd64.deb ...
Unpacking libwebp6:amd64 (0.6.1-2ubuntu0.20.04.1) ...
Selecting previously unselected package libtiff5:amd64.
Preparing to unpack .../12-libtiff5_4.1.0+git191117-2ubuntu0.20.04.2_amd64.deb ...
Unpacking libtiff5:amd64 (4.1.0+git191117-2ubuntu0.20.04.2) ...
Selecting previously unselected package libxpm4:amd64.
Preparing to unpack .../13-libxpm4_1%3a3.5.12-1_amd64.deb ...
Unpacking libxpm4:amd64 (1:3.5.12-1) ...
Selecting previously unselected package libgd3:amd64.
Preparing to unpack .../14-libgd3_2.2.5-5.2ubuntu2.1_amd64.deb ...
Unpacking libgd3:amd64 (2.2.5-5.2ubuntu2.1) ...
Selecting previously unselected package nginx-common.
Preparing to unpack .../15-nginx-common_1.18.0-0ubuntu1.2_all.deb ...
Unpacking nginx-common (1.18.0-0ubuntu1.2) ...
Selecting previously unselected package libnginx-mod-http-image-filter.
Preparing to unpack .../16-libnginx-mod-http-image-filter_1.18.0-0ubuntu1.2_amd64.deb ...
Unpacking libnginx-mod-http-image-filter (1.18.0-0ubuntu1.2) ...
Selecting previously unselected package libnginx-mod-http-xslt-filter.
Preparing to unpack .../17-libnginx-mod-http-xslt-filter_1.18.0-0ubuntu1.2_amd64.deb ...
Unpacking libnginx-mod-http-xslt-filter (1.18.0-0ubuntu1.2) ...
Selecting previously unselected package libnginx-mod-mail.
Preparing to unpack .../18-libnginx-mod-mail_1.18.0-0ubuntu1.2_amd64.deb ...
Unpacking libnginx-mod-mail (1.18.0-0ubuntu1.2) ...
Selecting previously unselected package libnginx-mod-stream.
Preparing to unpack .../19-libnginx-mod-stream_1.18.0-0ubuntu1.2_amd64.deb ...
Unpacking libnginx-mod-stream (1.18.0-0ubuntu1.2) ...
Selecting previously unselected package nginx-core.
Preparing to unpack .../20-nginx-core_1.18.0-0ubuntu1.2_amd64.deb ...
Unpacking nginx-core (1.18.0-0ubuntu1.2) ...
Selecting previously unselected package nginx.
Preparing to unpack .../21-nginx_1.18.0-0ubuntu1.2_all.deb ...
Unpacking nginx (1.18.0-0ubuntu1.2) ...
Setting up libxau6:amd64 (1:1.0.9-0ubuntu1) ...
Setting up libxdmcp6:amd64 (1:1.1.3-0ubuntu1) ...
Setting up libxcb1:amd64 (1.14-2) ...
Setting up nginx-common (1.18.0-0ubuntu1.2) ...
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /lib/systemd/system/nginx.service.
Setting up libjbig0:amd64 (2.1-3.1build1) ...
Setting up libnginx-mod-http-xslt-filter (1.18.0-0ubuntu1.2) ...
Setting up libx11-data (2:1.6.9-2ubuntu1.2) ...
Setting up libwebp6:amd64 (0.6.1-2ubuntu0.20.04.1) ...
Setting up fonts-dejavu-core (2.37-1) ...
Setting up libjpeg-turbo8:amd64 (2.0.3-0ubuntu1.20.04.1) ...
Setting up libx11-6:amd64 (2:1.6.9-2ubuntu1.2) ...
Setting up libjpeg8:amd64 (8c-2ubuntu8) ...
Setting up libnginx-mod-mail (1.18.0-0ubuntu1.2) ...
Setting up libxpm4:amd64 (1:3.5.12-1) ...
Setting up fontconfig-config (2.13.1-2ubuntu3) ...
Setting up libnginx-mod-stream (1.18.0-0ubuntu1.2) ...
Setting up libtiff5:amd64 (4.1.0+git191117-2ubuntu0.20.04.2) ...
Setting up libfontconfig1:amd64 (2.13.1-2ubuntu3) ...
Setting up libgd3:amd64 (2.2.5-5.2ubuntu2.1) ...
Setting up libnginx-mod-http-image-filter (1.18.0-0ubuntu1.2) ...
Setting up nginx-core (1.18.0-0ubuntu1.2) ...
Setting up nginx (1.18.0-0ubuntu1.2) ...
Processing triggers for ufw (0.36-6ubuntu1) ...
Processing triggers for systemd (245.4-4ubuntu3.13) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for libc-bin (2.31-0ubuntu9.2) ...
root@vagrant:~# whereis nginx
nginx: /usr/sbin/nginx /usr/lib/nginx /etc/nginx /usr/share/nginx /usr/share/man/man8/nginx.8.gz
root@vagrant:~# nginx -v
nginx version: nginx/1.18.0 (Ubuntu)
root@vagrant:~# systemctl enable nginx
Synchronizing state of nginx.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable nginx
root@vagrant:~# systemctl start nginx
root@vagrant:~# systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2022-01-05 15:35:36 UTC; 3min 21s ago
       Docs: man:nginx(8)
   Main PID: 2499 (nginx)
      Tasks: 3 (limit: 1071)
     Memory: 5.7M
     CGroup: /system.slice/nginx.service
             ├─2499 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
             ├─2500 nginx: worker process
             └─2501 nginx: worker process

Jan 05 15:35:36 vagrant systemd[1]: Starting A high performance web server and a reverse proxy server...
Jan 05 15:35:36 vagrant systemd[1]: Started A high performance web server and a reverse proxy server.
```
[nginx 1](https://i.imgur.com/q7Ce6Jb.png)  
![nginx 1](https://i.imgur.com/q7Ce6Jb.png)  

- Страница сервера nginx в браузере хоста не содержит предупреждений 

[nginx 2](https://i.imgur.com/LlktRky.png)  
![nginx 2](https://i.imgur.com/LlktRky.png)  

[nginx 3](https://i.imgur.com/T3kpmVd.png)  
![nginx 3](https://i.imgur.com/T3kpmVd.png)  

[nginx 3](https://i.imgur.com/3e9GwCK.png)  
![nginx 3](https://i.imgur.com/3e9GwCK.png)  

- Скрипт генерации нового сертификата работает (сертификат сервера ngnix должен быть "зеленым")

```python
#!/usr/bin/env python3

# This script creates a new certificate for common name 'vlt_CN'
#

import os, json, subprocess


ca_chain = []
file_json = "certs.json"
ssl_path = "/etc/nginx/ssl/"
file_ca_chain = "my.pem"
file_private_key = "my.key"
file_dhparam = "my_dhparam.pem"
vlt_role = "pki_int/issue/test-dot-test"
vlt_CN = "netology.test.test"
vlt_ca_ttl = "744h"
vlt_addr = "http://vault:8200"
vlt_tkn = "s.lhW9EXh5gwZSAtZP5EKPcTnr"

if os.path.isfile(ssl_path + file_ca_chain):
    vlt_ca_info = subprocess.run(['openssl', 'x509', '-noout', '-in', ssl_path + file_ca_chain, '-text'],
                                 stdout=subprocess.PIPE,
                                 encoding='utf-8')
    if vlt_ca_info.returncode == 0:
        old_cert_sn = vlt_ca_info.stdout.splitlines()[4].replace(' ', '').replace(':', '-')

subprocess.run(['vault', 'login', '-address=' + vlt_addr, vlt_tkn])

vlt_ca_create = subprocess.run(['vault', 'write', '-format=json', '-address=' + vlt_addr, vlt_role, 'common_name=' + vlt_CN, 'ttl=' + vlt_ca_ttl],
                               stdout=subprocess.PIPE,
                               encoding='utf-8')

if vlt_ca_create.returncode == 0:
    data = json.loads(vlt_ca_create.stdout)
    ca_chain = data['data']['ca_chain']
    certificate = data['data']['certificate']
    issuing_ca = data['data']['issuing_ca']
    private_key = data['data']['private_key']
    serial_number = data['data']['serial_number']

    with open(ssl_path + file_ca_chain, "w") as chain:
         chain.write(certificate + '\n' + issuing_ca)
    with open(ssl_path + file_private_key, "w") as key:
         key.write(private_key)

dhparam = subprocess.run(['openssl', 'dhparam', '-out', ssl_path + file_dhparam, '2048'],
                         stdout=subprocess.DEVNULL,
                         stderr=subprocess.DEVNULL)

if dhparam.returncode != 0:
    print('ERROR: File ' + file_dhparam + ' not created!')

if vlt_ca_info.returncode == 0:
    vlt_revoke_cert = subprocess.run(['vault', 'write', '-address=' + vlt_addr, 'pki_int/revoke', 'serial_number=' + old_cert_sn])

vlt_revoked_certs = subprocess.run(['vault', 'write', '-address=' + vlt_addr, 'pki_int/tidy', 'tidy_cert_store=true', 'tidy_revoked_certs=true', 'safety_buffer=1'])

nginx_check = subprocess.run(['/usr/sbin/nginx', '-t'])

if nginx_check.returncode == 0:
    subprocess.run(['/usr/bin/systemctl', 'reload', 'nginx'])
```

- Crontab работает (выберите число и время так, чтобы показать что crontab запускается и делает что надо)

[screenshot 1](https://i.imgur.com/4rBFOZX.png)  
![screenshot 1](https://i.imgur.com/4rBFOZX.png)  

[screenshot 2](https://i.imgur.com/VMWdwR1.png)  
![screenshot 2](https://i.imgur.com/VMWdwR1.png)  

[screenshot 3](https://i.imgur.com/6pmVdxB.png)  
![screenshot 3](https://i.imgur.com/6pmVdxB.png)  

---
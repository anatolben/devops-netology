# Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"

1. Работа c HTTP через телнет.
- Подключитесь утилитой телнет к сайту stackoverflow.com
`telnet stackoverflow.com 80`
- отправьте HTTP запрос
```bash
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
- В ответе укажите полученный HTTP код, что он означает?

```
HTTP/1.1 301 Moved Permanently
cache-control: no-cache, no-store, must-revalidate
location: https://stackoverflow.com/questions
x-request-guid: cac7db5a-aea3-46aa-9e96-be7ac954a3bd
feature-policy: microphone 'none'; speaker 'none'
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
Accept-Ranges: bytes
Date: Sun, 28 Nov 2021 13:15:48 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-fra19182-FRA
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1638105348.090865,VS0,VE92
Vary: Fastly-SSL
X-DNS-Prefetch-Control: off
Set-Cookie: prov=10f07b59-0841-afca-b95c-8fc69a23cd23; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly

Connection closed by foreign host.
```
```
HTTP/1.1 301 Moved Permanently
```
**код http 301 - запрашиваемый ресурс перемещен постоянно в новое местоположение.**  
```
cache-control: no-cache, no-store, must-revalidate
```
**заголовок сache-сontrol содержит инструкции кеширования для запросов и для ответов:**  
**no-cache - необходимо отправить запрос на сервер для валидации ресурса перед использованием закешированных данных;**  
**no-store - кеш не должен хранить никакую информацию о запросе и ответе;**  
**must-revalidate - кеш должен проверить статус устаревших ресурсов перед их использованием (просроченные ресурсы не использовать).**  
```
location: https://stackoverflow.com/questions
```
**адрес нового местоположения https://stackoverflow.com/questions**  

Так отрабатывается редирект с http на https.  

2. Повторите задание 1 в браузере, используя консоль разработчика F12.
- откройте вкладку `Network`
- отправьте запрос http://stackoverflow.com
- найдите первый ответ HTTP сервера, откройте вкладку `Headers`
- укажите в ответе полученный HTTP код.
- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
- приложите скриншот консоли браузера в ответ.

[screenshot #1](https://i.imgur.com/gUAeoF6.png)  
![screenshot #1](https://i.imgur.com/gUAeoF6.png)  

[screenshot #2](https://i.imgur.com/DS62CPF.png)  
![screenshot #2](https://i.imgur.com/DS62CPF.png)  

[screenshot #3](https://i.imgur.com/RTc0xXM.png)  
![screenshot #3](https://i.imgur.com/RTc0xXM.png)  

3. Какой IP адрес у вас в интернете?

[screenshot #4](https://i.imgur.com/BrGcUds.png)  
![screenshot #4](https://i.imgur.com/BrGcUds.png)  

4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`

[screenshot #5](https://i.imgur.com/OEWsthP.png)  
![screenshot #5](https://i.imgur.com/OEWsthP.png)  

[screenshot #6](https://i.imgur.com/2vrla6H.png)  
![screenshot #6](https://i.imgur.com/2vrla6H.png)  
Rostelecom, AS12389

5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`

[screenshot #7](https://i.imgur.com/A6zdCQm.png)  
![screenshot #7](https://i.imgur.com/A6zdCQm.png)  

6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?

[screenshot #8](https://i.imgur.com/aFIBEh1.png)  
![screenshot #8](https://i.imgur.com/aFIBEh1.png)  
На участке #10.  

7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`

[screenshot #9](https://i.imgur.com/QKs7B0d.png)  
![screenshot #9](https://i.imgur.com/QKs7B0d.png)  

8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`

[screenshot #10](https://i.imgur.com/zTNJ9QO.png)  
![screenshot #10](https://i.imgur.com/zTNJ9QO.png)  

---

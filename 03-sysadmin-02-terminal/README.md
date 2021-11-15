# Решение домашнего задания к занятию "3.2. Работа в терминале, лекция 2"

1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.

[screenshot #1](https://i.imgur.com/8YxinmB.png)  
![screenshot #1](https://i.imgur.com/8YxinmB.png)  
`cd` - команда bash  

[screenshot #2](https://i.imgur.com/OgnMpx4.png)  
![screenshot #2](https://i.imgur.com/OgnMpx4.png)  
`cd` - описание  

[screenshot #3](https://i.imgur.com/lVQceZ6.png)  
![screenshot #3](https://i.imgur.com/lVQceZ6.png)  
раздел в котором находится описание команды `cd`    
Вывод. Тип команды `cd` - встроенная команда оболочки.  

2. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`? `man grep` поможет в ответе на этот вопрос. Ознакомьтесь с [документом](http://www.smallo.ruhr.de/award.html) о других подобных некорректных вариантах использования pipe.

[screenshot #4](https://i.imgur.com/PUUYXa5.png)  
![screenshot #4](https://i.imgur.com/PUUYXa5.png)  
`grep -с <some_string> <some_file>`  

[screenshot #5](https://i.imgur.com/KYQ9kod.png)  
![screenshot #5](https://i.imgur.com/KYQ9kod.png) 

3. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?

[screenshot #6](https://i.imgur.com/0AjMqzI.png)  
![screenshot #6](https://i.imgur.com/0AjMqzI.png)  

[screenshot #7](https://i.imgur.com/ULcCtYw.png)  
![screenshot #7](https://i.imgur.com/ULcCtYw.png)  

[screenshot #8](https://i.imgur.com/4GVw54J.png)  
![screenshot #8](https://i.imgur.com/4GVw54J.png)  

PID `1` зарезервирован под процесс инициализации `systemd`.  

4. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?  

[screenshot #9](https://i.imgur.com/KRGZyhE.png)  
![screenshot #9](https://i.imgur.com/KRGZyhE.png)  
`ls -lah 1>/dev/pts/1`  

6. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.  

[screenshot #10](https://i.imgur.com/sr7Qfww.png)  
![screenshot #10](https://i.imgur.com/sr7Qfww.png)  
`echo -e "foo\nbar\nzoom" | grep bar 1> grep.txt; ls -lah; cat grep.txt`  

7. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?

[screenshot #11](https://i.imgur.com/A0mZFnE.png)  
![screenshot #11](https://i.imgur.com/A0mZFnE.png)  
Получится только в эмулятор TTY, соответствующий текущему активному сеансу PTY `echo "Hello world" 1>/dev/tty`.  
Данные выведутся в активном PTY.  

8. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?

[screenshot #12](https://i.imgur.com/sS1VZRk.png)  
![screenshot #12](https://i.imgur.com/sS1VZRk.png)  
`bash 5>&1` создаст дочерний от текущего процесс bash, откроет в нём файловый дескриптор `5`, поток из которого будет выводиться в stdout.  

[screenshot #13](https://i.imgur.com/xIvSFOy.png)  
![screenshot #13](https://i.imgur.com/xIvSFOy.png)  
`echo netology > /proc/$$/fd/5` stdout команды echo будет перенаправлен в файловый дескриптор bash `5`, а оттуда в stdout bash.  

9. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от `|` на stdin команды справа.
Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.

[screenshot #14](https://i.imgur.com/OOALsZk.png)  
![screenshot #14](https://i.imgur.com/OOALsZk.png)  
Да, получится.  

11. Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?

[screenshot #15](https://i.imgur.com/oO8LfFq.png)  
![screenshot #15](https://i.imgur.com/oO8LfFq.png)  

[screenshot #16](https://i.imgur.com/WZJWxvi.png)  
![screenshot #16](https://i.imgur.com/WZJWxvi.png)  

Команда выведет список переменных окружения, с которыми был запущен процесс bash, в котором находимся.  

[screenshot #17](https://i.imgur.com/cGFCK5m.png)  
![screenshot #17](https://i.imgur.com/cGFCK5m.png)  

[screenshot #18](https://i.imgur.com/2FPhuNn.png)  
![screenshot #18](https://i.imgur.com/2FPhuNn.png)  

[screenshot #19](https://i.imgur.com/CeVl1jn.png)  
![screenshot #19](https://i.imgur.com/CeVl1jn.png)  
`ps eww -p $$ | tr '\000' '\n'`  

12. Используя `man`, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.

[screenshot #20](https://i.imgur.com/6NwLm5h.png)  
![screenshot #20](https://i.imgur.com/6NwLm5h.png)  

[screenshot #21](https://i.imgur.com/S8CX76F.png)  
![screenshot #21](https://i.imgur.com/S8CX76F.png)  
Полная командная строка запуска процесса, если процесс не зомби.  

[screenshot #22](https://i.imgur.com/PCxAwqN.png)  
![screenshot #22](https://i.imgur.com/PCxAwqN.png)  

[screenshot #23](https://i.imgur.com/s6UuQep.png)  
![screenshot #23](https://i.imgur.com/s6UuQep.png)  
Символическая ссылка на сохранённый в памяти исполняемый файл, который запущен процессом `<PID>`.  
В Linux версии 2.0 и младше символическая ссылка на исполняемый файл, который запущен процессом `<PID>`.  

14. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.

[screenshot #24](https://i.imgur.com/9ZOfKj4.png)  
![screenshot #24](https://i.imgur.com/9ZOfKj4.png)  
Версия SSE4.2  

15. При открытии нового окна терминала и `vagrant ssh` создается новая сессия и выделяется pty. Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2. Однако:

     ```bash
     vagrant@netology1:~$ ssh localhost 'tty'
     not a tty
     ```

     Почитайте, почему так происходит, и как изменить поведение.

Происходит потому, что по умолчанию, при выполнении по `ssh` команд не выделяется PTY.  
Чтобы в данном случае принудительно выделялся PTY необходимо применять ключ `ssh -t`.  
[screenshot #25](https://i.imgur.com/w8qm9sY.png)  
![screenshot #25](https://i.imgur.com/w8qm9sY.png)  

[screenshot #26](https://i.imgur.com/38YpCVX.png)  
![screenshot #26](https://i.imgur.com/38YpCVX.png)  

16. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`. Например, так можно перенести в `screen` процесс, который вы запустили по ошибке в обычной SSH-сессии.

[screenshot #27](https://i.imgur.com/AdmDjW2.png)  
![screenshot #27](https://i.imgur.com/AdmDjW2.png)  

[screenshot #28](https://i.imgur.com/UgQSg6T.png)  
![screenshot #28](https://i.imgur.com/UgQSg6T.png)  

[screenshot #29](https://i.imgur.com/kjqwqa0.png)  
![screenshot #29](https://i.imgur.com/kjqwqa0.png)  

[screenshot #30](https://i.imgur.com/qjr6CpX.png)  
![screenshot #30](https://i.imgur.com/qjr6CpX.png)  

[screenshot #31](https://i.imgur.com/62GL7QF.png)  
![screenshot #31](https://i.imgur.com/62GL7QF.png)  

[screenshot #32](https://i.imgur.com/UUBEX4s.png)  
![screenshot #32](https://i.imgur.com/UUBEX4s.png)  

[screenshot #33](https://i.imgur.com/VvZSC4g.png)  
![screenshot #33](https://i.imgur.com/VvZSC4g.png)  

[screenshot #34](https://i.imgur.com/vawMSid.png)  
![screenshot #34](https://i.imgur.com/vawMSid.png)  

[screenshot #35](https://i.imgur.com/n7E5k6K.png)  
![screenshot #35](https://i.imgur.com/n7E5k6K.png)  

[screenshot #36](https://i.imgur.com/JfDrBnc.png)  
![screenshot #36](https://i.imgur.com/JfDrBnc.png)  

17. `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без `sudo` под вашим пользователем. Для решения данной проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.

Команда `tee` принимает поток из stdin перенаправляет в stdout, и параллельно в один или несколько файлов.  
Команда `sudo`, применяемая для повышения прав другой команды на её действие, не повышает права stdout этой команды (в том числе и `tee`). Из-за этого `sudo echo` не сможет вывести в файл, принадлежащий root через перенаправление stdout в файл.  
Однако, через `sudo tee` можно сделать запись в файл с повышенными правами (но не через перенаправление stdout). Потому, что запись в файл для `tee` это её действие, а не вывод в stdout.  
`tee` примет содержимое stdin, и используя повышенные права выведет в файл, а stdout `sudo tee` этого тоже не смог бы сделать.  
[screenshot #37](https://i.imgur.com/WHRatNP.png)  
![screenshot #37](https://i.imgur.com/WHRatNP.png)  

 ---

# Memory (73 points)

> Flag is: FwordCTF{computername_user_password}

Я решился приступить к этому заданию только потому, что увидел, что его решили очень много человек. Как выяснилось
после завершения CTF, это оказалась целая цепочка из 5ти заданий. Увы, я справился только с первым.

В данном задании нам даётся архив с одним файлом. Судя по его объёму (2+ Гб) и содержанию (и по названию задания, 
конечно), я предположил, что это дамп памяти Windows машины. Из описания очевидно, что мы должны найти 3 переменные — имя 
компьютера, имя пользователя и его пароль. Первым делом я попытался найти информацию через простую комбинацию 
`strings` и `grep`. После попыток использования разного регистра приходим к первому ответу:

![](https://i.imgur.com/0kzLJcI.png)

По аналогии находим имя пользователя:

![](https://i.imgur.com/51dw7Zk.png)

А вот с паролем, очевидно, так не выйдет. Пароли хранятся в зашифрованном виде, поэтому простым `grep`'ом не обойтись.
Идей не было, поэтому пошёл гуглить. По запросу "windows memory dump get user password" довольно быстро натыкаемся на статью по 
[volatility](https://www.andreafortuna.org/2017/11/15/how-to-retrieve-users-passwords-from-a-windows-memory-dump-using-volatility/).
Я не вижу смысла полностью повторять информацию с сайта, там всё довольно подробно и с картинками. Но ключевые моменты 
всё же обозначу:
1. Находим профиль. Как я понял, программа выдаёт несколько, можно проверить каждый, если что. Однако я первым выбрал 
Win7SP1x64 и он сработал.
2. Выводим структуру данных реестра (Registry Hive). Этот шаг нужен для определения оффсетов. Кстати, тут же можно
увидеть и имя пользователя (совпало с тем, что мы нашли).
3. Достаём хеши по оффсетам SYSTEM и SAM. Искомое значение: `a9fdfa038c4b75ebc76dc855dd74f0da`
4. Взламываем хеш. Я вопользовался [CrackStation](https://crackstation.net/):

![](https://i.imgur.com/R39iGmO.png)

Собственно, мы нашли все необходимые переменные. Файл с хешами, если что, прикладываю.
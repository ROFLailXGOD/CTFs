# Simple_SQL (129 points, 378 solves)

> Try to find username and password
>
> [Link](http://simplesql.darkarmy.xyz/)

Сайт выглядит очень пустым, там только одна надпись: `Welcome Players To My Safe House`.
Название задания явно намекает на SQL-инъекцию, но не очень понятно, как ею воспользоваться, ибо нет
никаких форм для вставки текста. Я, если честно, увидел описание соседнего задания - [So_Simple](../So_Simple).
Там была следующая подсказка:
```
Try id as parameter
```

И я решил попробовать эту технику и тут. В итоге я ввёл [http://simplesql.darkarmy.xyz/?id=1](http://simplesql.darkarmy.xyz/?id=1)
и получил новое сообщение на сайте:

![](https://i.imgur.com/1otwcow.png)

Я продолжил перебирать различные `id` и значение [9](http://simplesql.darkarmy.xyz/?id=9) привело к флагу:

![](https://i.imgur.com/FNGqTV5.png)

Даже без инъекций обошлись.
# rot-i (100 points, 447 solves)

> ROT13 is boring!

В приложениях лежит [challenge.txt](./challenge.txt) со следующим содержанием:
```
Ypw'zj zwufpp hwu txadjkcq dtbtyu kqkwxrbvu! Mbz cjzg kv IAJBO{ndldie_al_aqk_jjrnsxee}. Xzi utj gnn olkd qgq ftk 
ykaqe uei mbz ocrt qi ynlu, etrm mff'n wij bf wlny mjcj :).
```

Название вроде намекает на шифр из семейства ROT (самым популярным является ROT13) также известный как
[шифр Цезаря](https://ru.wikipedia.org/wiki/%D0%A8%D0%B8%D1%84%D1%80_%D0%A6%D0%B5%D0%B7%D0%B0%D1%80%D1%8F). Суть
заключается в обычном сдвиге всех символов на заданное число (например, для ROT13 `A` сдвигается на 13 позиций и 
превращается в `N`). Думать тут не надо, т.к. проверка всех сдвигов не занимает много времени (например, 
[тут](https://rot13.com/)). К сожалению, ни один из них не делает текст читаемым. Однако легко заметить, что в нём есть 
`IAJBO{...}`. Это, скорее всего, часть флага `DUCTF{...}`. Более того, я сразу предположил, что фраза перед этим (`Mbz 
cjzg kv`) - это `The flag is`. Почему? Не знаю. Возможно, это опыт, да и фраза эта встречается нередко.

Однако это не отвечает на вопрос, что делать. Вспомнив, что это лёгкое задание за 100 очков, я сразу начал перебирать
лёгкие шифры. Когда-то давно я читал "Книгу шифров" за авторством Саймона Сингха. Точной последовательности глав я не 
помню, но где-то недалеко от шифра Цезаря был описан [шифр Виженера](https://ru.wikipedia.org/wiki/%D0%A8%D0%B8%D1%84%D1%80_%D0%92%D0%B8%D0%B6%D0%B5%D0%BD%D0%B5%D1%80%D0%B0).
По сути это тот же шифр Цезаря, но вместо сдвига на одно и то же количество символов, используется ключ. Ключ 
записывается под текстом (пишется ровно столько раз, чтобы совпасть с длиной текста) и каждый его символ показывает, на
какое количество нужно произвести сдвиг. На странице в википедии есть пример, советую его разобрать.

Для удобства шифрования и дешифрования используется специальная таблица (квадрат Виженера):
![](https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Vigen%C3%A8re_square.svg/1024px-Vigen%C3%A8re_square.svg.png)

Для шифрования смотрится пересечение строки (шифруемый символ из текста) и столбца (символ из ключа). Дешифрование,
соответственно, происходит в обратную сторону. Давайте сразу на примере. Мы знаем, что `IAJBO` - это на самом
деле `DUCTF`: 
```
Шифр: Ypw'zj zwufpp hwu txadjkcq dtbtyu kqkwxrbvu! Mbz cjzg kv IAJBO{ndldie_al_aqk_jjrnsxee}. Xzi utj gnn olkd qgq ftk 
                                                               ^^^^^^
Исходный текст:                                                DUCTF{ 
ykaqe uei mbz ocrt qi ynlu, etrm mff'n wij bf wlny mjcj :).
```
Берём шифруемый символ (`D`) и в строке с ним находим зашифрованный (`I`). После этого смотрим на колонку 
и получаем `F` (пересечение `D` и `F` даёт нам `I`). Аналогично поступаем с остальными символами, и наш ключ для этой
части принимает следующий вид: `FGHIJ`. Ох, ничего не напоминает? Да это же часть алфавита! Попробуем поставить его с
начала строки:
```
Шифр: Ypw'zj zwufpp hwu txadjkcq dtbtyu kqkwxrbvu! Mbz cjzg kv IAJBO{ndldie_al_aqk_jjrnsxee}. Xzi utj gnn olkd qgq ftk 
Ключ: ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGH

Шифр: ykaqe uei mbz ocrt qi ynlu, etrm mff'n wij bf wlny mjcj :).
Ключ: IJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNO
```

О, смотрите-ка, совпало с нашим предположением! Ну, теперь остаётся лишь расшифровать флаг:
`DUCTF{crypto_is_fun_kjqlptzy}`

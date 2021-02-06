# WEIRD ENCRYPTION (377 points)

> I made this weird encryption I hope you can crack it.

В прикреплённом архиве находим 2 файла: [enc.py](./enc.py) и [Encrypted](./Encrypted). Что же, посмотрим, что в них.

##### Encrypted

```
eawethkthcrthcrthonutiuckirthoniskisuucthththcrthanthisucthirisbruceaeathanisutheneabrkeaeathisenbrctheneacisirkonbristhwebranbrkkonbrisbranthypbrbrkonkirbrciskkoneatibrbrbrbrtheakonbrisbrckoneauisubrbreacthenkoneaypbrbrisyputi
```

##### enc.py

```python
prefix = 'Hello. Your flag is DarkCTF{'
suffix = '}.'
main_string = 'c an u br ea k th is we ir d en cr yp ti on'.split()

clear_text = prefix + flag + suffix
enc_text = ""
for letter in clear_text:
    c1 = ord(letter) / 16
    c2 = ord(letter) % 16
    enc_text += main_string[c1]
    enc_text += main_string[c2]

print(enc_text)
```

Так, флаг заключается в `prefix` и `suffix`, после этого идёт цикл по всем символам. У символа берётся его ASCII 
значение, находятся целая часть и остаток от деления на 16. Эти числа используются как индексы листа `main_string`, в
котором хранятся 16 элементов. Соответственно, на каждый символ исходной строки в выходную попадают 2 элемента из
`main_string`. К счастью, эти элементы не имеют пересечений, поэтому восстановление исходного сообщения просто состоит в
выполнении шагов в обратной последовательности. Таким образом алгоритм таков:
1. Идём по выходной строке
2. Берём первые 2 символа
3. Если они есть в `main_string`, то переходим к шагу 4, иначе — к 5 
4. Высчитываем исходный символ и удаляем 2 рассмотренных символа из выходной строки. Возвращаемся к шагу 1
5. Берём первый символ, он обязан быть в `main_string`, т.к. пересечений нет
6. Высчитываем исходный символ и удаляем рассмотренный символ из выходной строки
7. Возвращаемся к шагу 1

На сам код можно посмотреть в файле [weird_encryption.py](./weird_encryption.py). Результат выполнения:

```
Hello. Your flag is DarkCTF{0k@y_7h15_71m3_Y0u_N33d_70_Br3@k_M3}.
```
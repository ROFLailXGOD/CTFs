# Pyjail ATricks (80 points, 106 solves)

> Run the secret function you must! Hrrmmm. A flag maybe you will get.

После подключения к серверу мы видим следующее сообщение:

```python
The flag is stored super secure in the function ALLES !
>>> a =
```

И у нас есть возможность ввода. Что же, очевидная попытка ввести `ALLES()' привела к сообщению:

```
name 'alles' is not defined
```

Ага, значит наш ввод приводится к нижнему регистру через `lower()`. Не проблема, вводим `eval('alles()'.upper())` и
получаем:

```
u
Denied
```

Т.е. какие-то символы запрещены. Я перебрал большинство символов и выяснил, что разрешены вот эти:

```
123790ertiopasdglcvn"'()+.[]_
```

Где же взять остальные? Немного изучения подобных челленджей из прошлых соревнований, я смог прийти к вот такому трюку:

```python
>>> a = 1
>>> a = print(a.__doc__)
int([x]) -> integer
int(x, base=10) -> integer

Convert a number or string to an integer, or return 0 if no arguments
are given.  If x is a number, return x.__int__().  For floating point
numbers, this truncates towards zero.

If x is not a number or if base is given, then x must be a string,
bytes, or bytearray instance representing an integer literal in the
given base.  The literal can be preceded by '+' or '-' and be surrounded
by whitespace.  The base defaults to 10.  Valid bases are 0 and 2-36.
Base 0 means to interpret the base from the string as an integer literal.
>>> int('0b100', base=0)
4
```

Тут есть очень много запрещённых символов, а значит мы можем их использовать вот так:

```
b - eval("a.__doc__[27]")
u - eval("a.__doc__[111]")
m - eval("a.__doc__[112]")
y - eval("a.__doc__[312]")
, - eval("a.__doc__[299]")
= - eval("a.__doc__[31]")
x - eval("a.__doc__[133]")
h - eval("a.__doc__[270]")
```

Напомню, что мы также можем получать запрещённые *индексы* через сложение, например, `x` можно получить
через `a.__doc__[2+3]`.

Возвращаемся к функции. Следующая строка приводит к вызову `ALLES()` (по какой-то причине `per` тоже было запрещено):

```python
>>> a = 1
>>> a = eval(eval('"alles()".'+eval("a.__doc__[111]")+'pp'+'er()'))
No flag for you!
```

Эх, похоже, нужно вызывать функцию с какими-то аргументами. Тут я ушёл не в ту степь и начал искать способы передачи
параметров (и нашёл), но это не помогло. Тогда я продолжил изучать подобные задания и возможности python и пришёл к
следующей конструкции:

```python
>>> a = 1
>>> a = print(eval(eval('"alles".'+eval("a.__doc__[111]")+'pp'+'er()')+'.__code__.co_code'))
b'|\x00r\x0et\x00d\x01|\x00\x83\x02S\x00d\x02S\x00d\x00S\x00'
>>> a = 1
>>> a = print(eval(eval('"alles".'+eval("a.__doc__[111]")+'pp'+'er()')+'.__code__.co_na'+eval("a.__doc__[112]")+'es'))
('string_xor',)
>>> a = 1
>>> a = print(eval(eval('"alles".'+eval("a.__doc__[111]")+'pp'+'er()')+'.__code__.co_consts'))
(None, 'p\x7f\x7frbH\x00DR\x07CRUlJ\x07DlRe\x02N', 'No flag for you!')
```

Давайте разберёмся, что это такое и что это нам дало. `co_code` даёт нам скомпилированный байткод. Я долго пытался
декомпилировать его и наткнулся на чудесную [статью](https://towardsdatascience.com/understanding-python-bytecode-e7edaae8734d).
При помощи неё я смог получить следующий код:

```
LOAD_FAST 0
POP_JUMP_IF_FALSE 14
LOAD_GLOBAL 0 (string_xor)
LOAD_CONST 1 (b'p\x7f\x7frbH\x00DR\x07CRUlJ\x07DlRe\x02N')
LOAD_CONST 0 (None)
CALL_FUNCTION 2
RETURN_VALUE 0
LOAD_CONST 2
RETURN_VALUE 0
LOAD_CONST 0
RETURN_VALUE 0
```

Далее я начал изучать каждую инструкцию при помощи [документации](https://docs.python.org/3/library/dis.html). Например:

```
LOAD_GLOBAL(namei)
    Loads the global named co_names[namei] onto the stack.
```

Отсюда и необходимость в `co_names`, которые мы нашли после `co_code`. Аналогично поступили с `LOAD_CONST` и выяснили,
что нам нужны `co_consts`. Описание `CALL_FUNCTION 2` даёт ясно понять, что происхолит вызов функции с аргументами
`string_xor(None, 'p\x7f\x7frbH\x00DR\x07CRUlJ\x07DlRe\x02N')`. Несложно предположить, что `None`, скорее всего, 
заменяется на наш параметр `key`, который мы должны передать в `ALLES()`. Но делать это, конечно, не надо, ибо мы понимаем,
что происходит - наша строка XOR'ится с той непонятной из `co_const` (назовём её `А`). Однако мы знаем, как должен выглядеть флаг - 
ALLES{...}. XOR обладает ассоциативностью и самообратимостью, т.е. мы можем восстановить часть ключа, зная часть флага:

```
A ^ key = flag
A ^ flag = key
```

Воспользуемся python:

```python
>>> from Crypto.Util.strxor import strxor
>>> flag = b'ALLES{'
>>> A = b'p\x7f\x7frbH\x00DR\x07CRUlJ\x07DlRe\x02N'
>>> strxor(flag, A[:len(flag)])
b'133713'
```

Так-так-так, похоже ключ - это просто повторяющаяся последовательность `1337`. Проверяем:

```python
>>> key = 10 * b'1337'
>>> strxor(A, key[:len(A)])
b'ALLES{3sc4ped_y0u_aR3}'
```

Бинго!

*Примечание:* как я потом уже выяснил, декомплировать байткод можно было автоматически через модуль dis.
Похоже, я немного ошибся в ручной декомпиляции, но на логику эту не повлияло.
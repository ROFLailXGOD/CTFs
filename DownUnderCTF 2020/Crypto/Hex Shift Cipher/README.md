# Hex Shift Cipher (445 points, 44 solves)

> People say shift ciphers aren't secure. I'm here to prove them wrong!

В приложениях находим [hex-shift-cipher.py](./hex-shift-cipher.py).

Мой подход к подобным заданиям заключается в постепенном понимании происходящего:
```python
from random import shuffle
from secret import secret_msg

ALPHABET = '0123456789abcdef'

class Cipher:
    def __init__(self, key):
        self.key = key
        self.n = len(self.key)
        self.s = 7

    def add(self, num1, num2):
        res = 0
        for i in range(4):
            res += (((num1 & 1) + (num2 & 1)) % 2) << i
            num1 >>= 1
            num2 >>= 1
        return res

    def encrypt(self, msg):
        key = self.key
        s = self.s
        ciphertext = ''
        for m_i in msg:
            c_i = key[self.add(key.index(m_i), s)]
            ciphertext += c_i
            s = key.index(m_i)
        return ciphertext

plaintext = b'The secret message is:'.hex() + secret_msg.hex()

key = list(ALPHABET)
shuffle(key)

cipher = Cipher(key)
ciphertext = cipher.encrypt(plaintext)
print(ciphertext)

# output:
# 85677bc8302bb20f3be728f99be0002ee88bc8fdc045b80e1dd22bc8fcc0034dd809e8f77023fbc83cd02ec8fbb11cc02cdbb62837677bc8f2277eeaaaabb1188bc998087bef3bcf40683cd02eef48f44aaee805b8045453a546815639e6592c173e4994e044a9084ea4000049e1e7e9873fc90ab9e1d4437fc9836aa80423cc2198882a
```

Никакого `secret_msg` у нас, конечно, нет, но видим, что он добавляется к концу известной строки:
```python
plaintext = b'The secret message is:'.hex() + secret_msg.hex()
```
Также замечаем, что есть некий ключ, состоящий из шестнадцатеричных цифр. Но есть проблема — они перемешаны:
```python
ALPHABET = '0123456789abcdef'

key = list(ALPHABET)
shuffle(key)
```

Далее происходит шифрование. Сразу стоит обратить внимание на то, что символы шифруются по отдельности.
Это значительно упрощает задачу. Основная соль в этих строках:
```python
ciphertext = ''
for m_i in msg:
    c_i = key[self.add(key.index(m_i), s)]
    ciphertext += c_i
    s = key.index(m_i)
return ciphertext
```

Давайте разбираться. Берётся символ из `msg` (это по сути `plaintext`). Находится его индекс в
ключе:
```python
key.index(m_i)
```

Это число, а также некое s (изначально равно 7) передаются в функцию `add()`. Внутри этой функции не
происходит ничего интересного — она состоит из набора логических операций *только* над этими числами. Честно говоря,
нам из-за этого даже неинтересно, как она работает. Просто понимаем, что она возвращает какое-то число 
(назовём его `res`). Далее мы вновь возвращаемся к ключу и берём из него символ с индексом `res`. Это число и попадает в
`ciphertext`. Числу `s` присваивается первоначальный индекс. Давайте перепишем этот блок, чтобы стало проще:
```python
input_index_in key = key.index(m_i)
res = self.add(input_index_in key, s)
c_i = key[res]
s = input_index_in key
```

*Важное наблюдение*: добавление нового символа в конец входной последовательности приводит лишь к
добавлению новых символов к выходной. Т.е.:
```python
>>> b'The secret'.hex()
'54686520736563726574'
>>> b'The secret message is:'.hex()
'54686520736563726574206d6573736167652069733a'
```
На этом свойстве основывается моё решение!

В этот момент я задумался. У нас есть начало входной последовательности и полный вывод. Символов в ключе всего 16, 
причём у каждого своя позиция. Более того, все функции, которые используются для преобразований, у нас есть.
Почему бы не найти ключ рекурсивно? Будем брать по одному символу из входной и выходной последовательностей
и подбирать такие позиции в ключе, чтобы `преобразование(входной символ) = выходной символ`. Начинаем
составлять алгоритм:
```python
# 1
def bruteforce(key: str, inp: str, out: str, s: int, pos: int):
    # 8
    if inp in key:
        res = add(key.index(inp), s)
        if out in key and key.index(out) != res:
            return
        if out not in key and key[res] != 'X':
            return
        cur_key = key[:res] + out + key[res+1:]
        bruteforce(cur_key, plain[pos+1], cipher[pos+1], cur_key.index(inp), pos+1)

    for i in range(16):
        # 2
        if key[i] != 'X':
            continue

        # 3
        cur_key = key[:i] + inp + key[i+1:]
        res = add(i, s)

        # 4
        if out in cur_key and cur_key.index(out) != res:
            continue
        
        # 5
        if out not in cur_key and cur_key[res] != 'X':
            continue
        # 6
        cur_key = cur_key[:res] + out + cur_key[res+1:]
        
        # 7
        if 'X' not in cur_key:
            print(cur_key)
            return
        bruteforce(cur_key, plain[pos+1], cipher[pos+1], i, pos+1)
```

Для удобства я пометил логические части цифрами по мере их добавления. Начальный ключ считаем за `XXXXXXXXXXXXXXXX`.
1. Входные параметры: 
    * key — текущий ключ 
    * inp — символ из входной последовательности 
    * out - символ из выходной последовательности
    * s - число, используемое в расчётах
    * pos - номер текущего символа в последовательностях 
2. Идём по всем свободным позициям ключа
3. Подставляем входной символ на свободное место и считаем `res`
4. Если выходной символ уже в ключе, а его позиция отличается от индекса `res`, который мы только что
получили, то что-то пошло не так. Значит `inp` не может быть на этом месте, пробуем следующее
5. Если же выходного символа нет, но полученный индекс уже занят другим числом, то что-то пошло не так. Значит `inp` не 
может быть на этом месте, пробуем следующее
6. Во всех остальных случаях считаем, что всё хорошо, и ставим `out` на полученное место.
7. Если мы расставили все 16 символов, то ключ найден. Иначе переходим к следующей паре символов и
повторяем процесс. Не забываем поменять `s` на индекс `i`
8. Если вдруг наш входной символ уже в ключе, то нам не надо искать для него место. Мы используем текущее и
проверяем, что всё хорошо (аналогично 4 и 5)

Данная функция начала выплёвывать кучу ключей, я просто взял первый - `456b7e812c3af90d`. Первый этап пройден, дальше 
проще.

Зная ключ и выходную последовательность, нетрудно восстановить исходную. Как? Я вновь решил перебором подбирать
символы и проверять, что результат входит в выходную последовательность.
```python
def guess_char(flag: str):
    while len(flag) != len(out):
        for i in range(32, 176):
            cur_flag = flag + chr(i).encode('utf_8').hex()

            ciphertext = ''
            s = 7
            for m_i in cur_flag:
                c_i = key[add(key.index(m_i), s)]
                ciphertext += c_i
                s = key.index(m_i)

            if ciphertext in out:
                guess_char(cur_flag)
    print(bytes.fromhex(flag))
    exit(0)
```
Тут вроде всё понятно - проходим по всем печатаемым символам и подбираем тот, который совпадёт с выходным сообщением.
Полный скрипт можно посмотреть в файле [solve.py](./solve.py). Результат:
```
b"The secret message is: Nice job! I hope you enjoyed the challenge. Here's your flag: DUCTF{d1d_y0u_Us3_gu3ss1nG_0r_l1n34r_4lg3bRA??}"
```

Не думаю, что получилось самое эффективное решение, но этого никто и не требовал. Главное, что оно работает.

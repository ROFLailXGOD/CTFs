# Extra Cool Block Chaining (422 points, 52 solves)

> Everyone knows ECB is broken because it lacks diffusion. That's why I've come up with my own variant that uses IVs 
> and chaining and all that cool stuff! It solves all the problems ECB had... I think
>
> nc chal.duc.tf 30201

В приложениях находим [server.py](./server.py). Давайте сразу взглянем на него:
```python
#!/usr/bin/env python3
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad
from Crypto.Util.strxor import strxor
from os import urandom

flag = open('./flag.txt', 'rb').read().strip()
KEY = urandom(16)
IV = urandom(16)

def encrypt(msg, key, iv):
    msg = pad(msg, 16)
    blocks = [msg[i:i+16] for i in range(0, len(msg), 16)]
    out = b''
    for i, block in enumerate(blocks):
        cipher = AES.new(key, AES.MODE_ECB)
        enc = cipher.encrypt(block)
        if i > 0:
            enc = strxor(enc, out[-16:])
        out += enc
    return strxor(out, iv*(i+1))

def decrypt(ct, key, iv):
    blocks = [ct[i:i+16] for i in range(0, len(ct), 16)]
    out = b''
    for i, block in enumerate(blocks):
        dec = strxor(block, iv)
        if i > 0:
            dec = strxor(dec, ct[(i-1)*16:i*16])
        cipher = AES.new(key, AES.MODE_ECB)
        dec = cipher.decrypt(dec)
        out += dec
    return out

flag_enc = encrypt(flag, KEY, IV).hex()

print('Welcome! You get 1 block of encryption and 1 block of decryption.')
print('Here is the ciphertext for some message you might like to read:', flag_enc)

try:
    pt = bytes.fromhex(input('Enter plaintext to encrypt (hex): '))
    pt = pt[:16] # only allow one block of encryption
    enc = encrypt(pt, KEY, IV)
    print(enc.hex())
except:
    print('Invalid plaintext! :(')
    exit()

try:
    ct = bytes.fromhex(input('Enter ciphertext to decrypt (hex): '))
    ct = ct[:16] # only allow one block of decryption
    dec = decrypt(ct, KEY, IV)
    print(dec.hex())
except:
    print('Invalid ciphertext! :(')
    exit()

print('Goodbye! :)')
```

Вроде общий принцип работы понятен. При старте программы нас встречает приветственное сообщение и выводится
зашифрованный флаг. Затем нам даётся возможность зашифровать 1 блок (16 байт). Далее наоборот -
можно расшифровать 1 блок. И на этом всё заканчивается. Ввод и вывод проводится в hex. Предлагаю попробовать
ввести что-нибудь (напомню, что 1 байт - это 2 шестнадцатеричных символа, поэтому общая длина блока равна 32):

![](https://i.imgur.com/HE2np7E.png)

На первый взгляд всё работает хорошо - мы получили наш исходный блок. Однако странно, что мы получили 2 закодированных
блока. Почему это странно? Да потому что при AES шифровании в режиме [ECB](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Electronic_codebook_(ECB))
длина блоков не меняется... Более того этот режим очень ненадёжный, т.к. одинаковые блоки шифруются в
одинаковые шифротексты. Но вроде как автор обещал добавить IV и сдвиги... Надо разбираться в алгоритме шифрования:
```python
KEY = urandom(16)
IV = urandom(16)

def encrypt(msg, key, iv):
    msg = pad(msg, 16)
    blocks = [msg[i:i+16] for i in range(0, len(msg), 16)]
    out = b''
    for i, block in enumerate(blocks):
        cipher = AES.new(key, AES.MODE_ECB)
        enc = cipher.encrypt(block)
        if i > 0:
            enc = strxor(enc, out[-16:])
        out += enc
    return strxor(out, iv*(i+1))
```

Так, входные данные чем-то дополняются (паддятся) до числа, кратного 16, и разбиваются на блоки по 16 байт. Затем
происходит цикл по всем блокам. В цикле инициализируется шифр. Ключ, к сожалению, берётся случайный.
Блок шифруется через AES ECB. Если это первый блок, то он заносится в выходную строку. Если же блок не первый, то
он XOR'ится с предыдущим, а затем так же добавляется к выводу. Когда все блоки зашифрованы, выходная строка ещё раз 
XOR'ится, теперь уже со случайным числом `IV`. Причём длина числа `IV` равна 16 байт, поэтому приходится его повторять,
пока длина не совпадёт с длиной исходной строки. Затем эта строка выводится. Подведём итог:
1. Входная последовательность `plaintext` дополняется чем-то до длины, кратной 16
2. Затем она разбивается на блоки `b0, b1, ..., bi-1` по 16 байт
3. Каждый блок шифруется: `b0 -> e0`, `b1 -> e1`, ..., `bi-1 -> ei-1`
4. Все блоки, кроме первого, XOR'ятся с предыдущим. В итоге каждый блок выглядит так:
    * `e'0` = `e0`
    * `e'1` = `e1 XOR e'0` = `e1 XOR e0`
    * `e'2` = `e2 XOR e'1` = `e2 XOR e1 XOR e0`
    * ...
5. Каждый блок дополнительно XOR'ится с `IV`:
    * `out0` = `e'0 XOR IV` = `e0 XOR IV`
    * `out1` = `e'1 XOR IV` = `e1 XOR e'0 XOR IV` = `e1 XOR e0 XOR IV`
    * `out2` = `e'2 XOR IV` = `e2 XOR e'1 XOR IV` = `e2 XOR e1 XOR e0 XOR IV`
    * ... 

Дешифрование происходит в обратном порядке (XOR с `IV`, затем дешифрование через AES ECB), тут вроде всё просто. На 
данном этапе мы понимаем, что получить первую часть флага очень просто: берём первые 16 байт из вывода в приветственном 
сообщении (эквивалентно `out0`) и отдаём их программе, когда нам предложат расшифровать блок. Остаётся проблема - для 
расшифровки остальных частей нам нужно знать `IV`. Почему? Ну попробуем расшифровать `out1`. Мы можем сделать XOR с
`out0`, чтобы избавиться от `e0`:
```
out1 XOR out0 = (e1 XOR e0 XOR IV) XOR (e0 XOR IV) = e1 XOR (e0 XOR e0) XOR (IV XOR IV) = e1
```
Аналогично мы можем получить все `e2`, `e3`, ..., `ei-1`, но проблема в том, что перед дешифрованием они XOR'ятся с `IV`.
Т.е. нам надо передавать `e1 XOR IV`, `e2 XOR IV` и т.д., чтобы расшифровать эти блоки корректно. Но где взять `IV`?
Я застрял на этом этапе на несколько часов. Но в какой-то момент я понял, что мы так и не воспользовались
возможностью *зашифровать* блок, а также вспомнил, что там происходили какие-то чудеса с увеличением длины. Я решил 
посмотреть в консоли, что происходит:
```python
>>> from Crypto.Util.Padding import pad
>>> pad(16*b'A')
b'AAAAAAAAAAAAAAAA\x10\x10\x10\x10\x10\x10\x10\x10\x10\x10\x10\x10\x10\x10\x10\x10'
```
Эм... Длина становится 32, ибо добавляются 16 `\x10` байтов. А почему? Взглянем на исходник:
```python
def pad(data_to_pad, block_size, style='pkcs7'):
    padding_len = block_size-len(data_to_pad)%block_size  # 16 - 16 % 16 = 16 - 0 = 16
    ...
```

А, так вот в чём дело. Ну ладно, разве нам это что-то даёт? Да! Помните главную проблему ECB? Одинаковые блоки на
входе гарантируют одинаковые блоки на выходе. А у нас происходит XOR двух блоков. Получается, если мы отправим 16 `\x10`
байтов, то получим 2 блока одинаковых блока, которые XOR'ятся друг с другом (что даёт 0), затем с `IV` и результат 
возвращается нам:
```
e0 = e1
e1 XOR e0 XOR IV = e1 XOR e1 XOR IV = IV
```
Так вот как мы можем вытащить IV! После этого алгоритм становится очевидным:
1. Из приветствия забираем зашифрованный флаг и делим его на блоки
2. Расшифровываем первый блок флага, просто отправив его обратно. Шифрование и `IV` нас сейчас не интересует
3. Открываем новое соединение и посылаем 16*`\x10`
4. Нам возвращаются 2 блока. Второй - это `IV`
5. Берём второй блок флага и XOR'им его с `IV`, результат отправляем на дешифрование
6. Повторяем те же действия для остальных блоков

Реализацию можно увидеть в файле [ecb_chaining.py](./ecb_chaining.py).

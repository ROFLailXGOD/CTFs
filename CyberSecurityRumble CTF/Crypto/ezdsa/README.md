# ezsda (268 points, 34 solves)

> This task has two parts to it, the first part is the signer. You can send a message to the server and it will sign it
> and send it back. The second part is the verifier. The verifier will take the message and the signature of the
> message and verify they match.*

*Примечание:* оригинальное описание может отличаться от приведённого — на момент написания страница уже недоступна

К заданию прилагаются 2 файла — [signer.py](./signer.py) и [verifier.py](./verifier.py). Взглянем на
интересные части.

verifier.py:

```python
def valid_signature(msg, sig):
    try:
        vk.verify(sig, msg)
        return True
    except ecdsa.BadSignatureError:
        return False


class TCPHandler(socketserver.StreamRequestHandler):

    def handle(self):
        data = self.rfile.readline().strip()
        user, signature = data.split(b",")
        sig = bytes.fromhex(signature.decode())
        try:
            if valid_signature(user, sig):
                if user == b"admin":
                    self.wfile.write(b"Hello admin! Here is your flag: " + FLAG)
...
```

Отсюда можно выяснить несколько важных фактов. Во-первых, мы передаём имя пользователя и подпись. Подпись должна быть
валидной, алгоритм шифрования — ECDSA. Имя пользователя должно быть `admin`. А где же взять эту подпись?

signer.py:

```python
key = open("secp256k1-key.pem").read()
sk = ecdsa.SigningKey.from_pem(key)
...

def sign(data):
    if data == b"admin":
        raise ValueError("Not Permitted!")
    signature = sk.sign(data, entropy=sony_rand)
    return signature


class TCPHandler(socketserver.StreamRequestHandler):

    def handle(self):
        data = self.rfile.readline().strip()
        try:
            signature = sign(data).hex()
            self.wfile.write(b"Your token: " + data + b"," + signature.encode())
        except ValueError as ex:
            self.wfile.write(b"Invalid string submitted: " + str(ex).encode())
```

Ага, т.е. это делается через signer'а. Вот только есть одна проблема — мы не можем передать имя `admin`. Как же быть?

С этого вопроса началось моё знакомство с ECDSA. Я не буду здесь приводить принципы работы этого механизма, т.к. в
интернете уже существует множество статей. Я лично ознакомился с вот [этой](https://andrea.corbellini.name/2015/05/17/elliptic-curve-cryptography-a-gentle-introduction/)
серией, но и на русском [есть](https://habr.com/ru/post/335906/).

Перейду сразу к проблеме — нельзя переиспользовать nonce (переменная `k` в алгоритме). Если разобраться с алгоритмом 
шифрования, то проблем в нахождении ключа не будет. Я вообще просто дополнительно просмотрел вот [это](https://www.youtube.com/watch?v=-UcCMjQab4w)
видео. В нём решалось подобное CTF задание, но есть пара отличий и нюансов. Начнём с отличия — в нашем случае
используется кривая `secp256k1` (это заметно по signer'у). Нюансом же является то, что согласно [этому](https://bitcoin.stackexchange.com/questions/35848/recovering-private-key-when-someone-uses-the-same-k-twice-in-ecdsa-signatures/35850#35850)
посту при расчёте `k` нужно проверять 4-ре ситуации (менять знаки у `s1` и `s2`). Однако в данном случае нам повезло, и
сработал первый кандидат.

После этого мы вручную можем найти подпись для `admin` и передать её на сервер. В ответ получаем флаг:

```

```
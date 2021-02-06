# Hashfun (100 points, 267 solves)

> I guess there is no way to recover the flag.

К заданию прилагается файл [generate.py](./generate.py). Взглянем на него:

```python
from secret import FLAG

def hashfun(msg):
    digest = []
    for i in range(len(msg) - 4):
        digest.append(ord(msg[i]) ^ ord(msg[i + 4]))
    return digest

print(hashfun(FLAG))
# [10, 30, 31, 62, 27, 9, 4, 0, 1, 1, 4, 4, 7, 13, 8, 12, 21, 28, 12, 6, 60]
```

Что же, типичное задание на XOR. Первые 4-ре символа флага — это `CSR{`. Этой информации достаточно, чтобы найти все
оставшиеся:

```python
encoded = [10, 30, 31, 62, 27, 9, 4, 0, 1, 1, 4, 4, 7, 13, 8, 12, 21, 28, 12, 6, 60]
flag = 'CSR{'

for i in range(len(encoded)):
    flag += chr(encoded[i] ^ ord(flag[i]))

print(flag)
```

Как это работает? Изначально мы имеем: `flag[0] XOR flag[4] = 10`. `flag[0]` нам известен, поэтому: `flag[4] = flag[0]
XOR 10`. Аналогично для всех остальных символов.
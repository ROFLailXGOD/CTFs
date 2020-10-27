# haxXor (281 points, 195 solves)

> you either know it or not take this and get your flag
>
> 5552415c2b3525105a4657071b3e0b5f494b034515

Задание из криптографии, и нам даётся всего лишь небольшая строка. На хеш это не похоже из-за длины. Что же
это такое? Ну, на самом деле название задания подсказывает, что нужно делать. Предполагаем, что
флаг начинается с `darkCTF{`, XOR'им это с данной строкой и получаем:
```python
>>> from Crypto.Util.strxor import strxor

>>> inp = '5552415c2b3525105a4657071b3e0b5f494b034515'
>>> inp = bytes.fromhex(inp)
>>> ctf = b'darkCTF{'
>>> strxor(ctf, inp[:len(ctf)])
b'1337hack'
```

Предполагаем, что эта последовательность просто повторяется. Действительно:
```python
>>> key = b'1337hack'*10
>>> strxor(inp, key[:len(inp)])
b'darkCTF{kud0s_h4xx0r}'
```
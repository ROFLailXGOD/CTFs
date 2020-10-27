# Pipe Rhyme (249 points, 195 solves)

> So special

К заданию приложен файл [pipeRhymeChall(2).txt](./pipeRhymeChall(2).txt). Посмотрим на него:
```
Chall:- Pipe Rhyme

Chall Desc:- Wow you are so special.

N=0x3b7c97ceb5f01f8d2095578d561cad0f22bf0e9c94eb35a9c41028247a201a6db95f
e=0x10001
ct=0x1B5358AD42B79E0471A9A8C84F5F8B947BA9CB996FA37B044F81E400F883A309B886

```

А, ну тут RSA шифр. Причём `N` выглядит подозрительно маленьким. Попробуем его факторизовать через 
[factor.db](http://factordb.com/index.php?query=1763350599372172240188600248087473321738860115540927328389207609428163138985769311):
```
1763350599...11<82> = 31415926535897932384626433832795028841<38> · 56129192858827520816193436882886842322337671<44>
```
Отлично! Дальше просто следуем алгоритму (можно взглянуть в [pipe_rhyme.py](./pipe_rhyme.py)). Запуск выдаёт:
`b'darkCTF{4v0iD_us1ngg_p1_pr1mes}'`
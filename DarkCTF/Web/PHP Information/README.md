# PHP information (198 points)

>    Let's test your php knowledge.
>
>    Flag Format: DarkCTF{}
>
>    http://php.darkarmy.xyz:7001

Переходим по ссылке и смотрим на код страницы:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Corona Web</title>
</head>
<body>
    

    <style>
        body{
            background-color: whitesmoke
        }
    </style>
<?php

include "flag.php";

echo show_source("index.php");


if (!empty($_SERVER['QUERY_STRING'])) {
    $query = $_SERVER['QUERY_STRING'];
    $res = parse_str($query);
    if (!empty($res['darkctf'])){
        $darkctf = $res['darkctf'];
    }
}

if ($darkctf === "2020"){
    echo "<h1 style='color: chartreuse;'>Flag : $flag</h1></br>";
}

if ($_SERVER["HTTP_USER_AGENT"] === base64_decode("MjAyMF90aGVfYmVzdF95ZWFyX2Nvcm9uYQ==")){
    echo "<h1 style='color: chartreuse;'>Flag : $flag_1</h1></br>";
}


if (!empty($_SERVER['QUERY_STRING'])) {
    $query = $_SERVER['QUERY_STRING'];
    $res = parse_str($query);
    if (!empty($res['ctf2020'])){
        $ctf2020 = $res['ctf2020'];
    }
    if ($ctf2020 === base64_encode("ZGFya2N0Zi0yMDIwLXdlYg==")){
        echo "<h1 style='color: chartreuse;'>Flag : $flag_2</h1></br>";
                
        }
    }



    if (isset($_GET['karma']) and isset($_GET['2020'])) {
        if ($_GET['karma'] != $_GET['2020'])
        if (md5($_GET['karma']) == md5($_GET['2020']))
            echo "<h1 style='color: chartreuse;'>Flag : $flag_3</h1></br>";
        else
            echo "<h1 style='color: chartreuse;'>Wrong</h1></br>";
    }



?>
</body>
</html>
```

Окей, похоже флаг надо получать по кусочкам, причём необязательно удовлетворять все условия сразу. Пойдём по порядку.

### Часть 1

```php
if (!empty($_SERVER['QUERY_STRING'])) {
    $query = $_SERVER['QUERY_STRING'];
    $res = parse_str($query);
    if (!empty($res['darkctf'])){
        $darkctf = $res['darkctf'];
    }
}

if ($darkctf === "2020"){
    echo "<h1 style='color: chartreuse;'>Flag : $flag</h1></br>";
}
```

Первым делом надо понять что такое `$_SERVER['QUERY_STRING']`. Вот эта [статья](http://www.softtime.ru/article/index.php?id_article=69)
оказалась неплохим источником информации. Выясняется, что в этот элемент вносятся параметры. В нашем случае `darkctf`
должен быть равен `2020`. Это достигается так:
```
http://php.darkarmy.xyz:7001/?darkctf=2020
```
Переходим по ссылке и получаем: `Flag : DarkCTF{`. Эх, начало мы и так знаем...

### Часть 2

```php
if ($_SERVER["HTTP_USER_AGENT"] === base64_decode("MjAyMF90aGVfYmVzdF95ZWFyX2Nvcm9uYQ==")){
    echo "<h1 style='color: chartreuse;'>Flag : $flag_1</h1></br>";
}
```

С агентом мы уже встречались в задании [Source](../Source). Значение должно быть равно декодированной строке:

```shell script
$ echo "MjAyMF90aGVfYmVzdF95ZWFyX2Nvcm9uYQ==" | base64 -d           
2020_the_best_year_corona
```

Опять же, я заменил через Burp. Перезагружаем страницу и получаем: `Flag : very_`.

### Часть 3

```php
if (!empty($_SERVER['QUERY_STRING'])) {
    $query = $_SERVER['QUERY_STRING'];
    $res = parse_str($query);
    if (!empty($res['ctf2020'])){
        $ctf2020 = $res['ctf2020'];
    }
    if ($ctf2020 === base64_encode("ZGFya2N0Zi0yMDIwLXdlYg==")){
        echo "<h1 style='color: chartreuse;'>Flag : $flag_2</h1></br>";
                
        }
    }
```

Вновь переменная, вновь base64... Подождите! В этот раз это значение нужно **закодировать**. Небольшая
проверка на внимательность от авторов.

```shell script
$ echo "ZGFya2N0Zi0yMDIwLXdlYg==" | base64                          
WkdGeWEyTjBaaTB5TURJd0xYZGxZZz09Cg==
```

Переходим по 

```
http://php.darkarmy.xyz:7001/?darkctf=2020&ctf2020=WkdGeWEyTjBaaTB5TURJd0xYZGxZZz09
```

и забираем третью часть флага: `Flag : nice`.

### Часть 4

```php
if (isset($_GET['karma']) and isset($_GET['2020'])) {
        if ($_GET['karma'] != $_GET['2020'])
        if (md5($_GET['karma']) == md5($_GET['2020']))
            echo "<h1 style='color: chartreuse;'>Flag : $flag_3</h1></br>";
        else
            echo "<h1 style='color: chartreuse;'>Wrong</h1></br>";
    }
```

А вот тут я застрял надолго. Мы должны передать 2 различных параметра `karma` и `2020`, но их md5 хеши
должны совпасть! Я знаю, что md5 коллизии были найдены давно и в сети есть куча примеров, но в основном там
используются байтовые строки, т.е. содержащие непечатаемые символы. В общем, я очень долго пытался что-то придумать, но 
всё безуспешно. Однако в какой-то момент на дискорд-сервере автор задания опубликовал хинт:

```
Hint : Magic Hash :smile:
```

Что же, пора отправиться в очередное путешествие по гуглу. В какой-то момент я забрёл [сюда](http://russiansecurity.expert/2015/06/14/magic-hash-again/).
Выясняется, что т.к. используется оператор `Равно` (`==`) вместо `Тождественно равно` (`===`), то значения перед
сравнением приводятся к одному типу. И если так совпадёт, что хеш будет выглядеть как число, то и тип преобразуется из 
строки в число. Более того, если число получится в виде `[цифры]e[цифры]`, то произойдёт вычисление. А это значит, что:

```
0e[цифры] = 0
```

Т.е. всё, что нам нужно, — это 2 различные строки, хеш которых будет в виде 
`0e[цифры]`. Но как же нам найти такие строки? А всё уже сделано за нас! В [этом](https://github.com/spaze/hashes/blob/master) 
репозитории собраны подобные магические хеши для различных алгоритмов, в том числе и для md5. Выбираем любые:

```
http://php.darkarmy.xyz:7001/?2020=aabg7XSs&karma=QNKCDZO
```

переходим по ссылке и получаем последнюю часть флага: `Flag : _web_challenge_dark_ctf}`! Осталось лишь собрать их 
воедино:

```
DarkCTF{very_nice_web_challenge_dark_ctf}
```
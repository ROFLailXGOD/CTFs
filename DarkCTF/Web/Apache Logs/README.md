# Apache Logs (113 points, 431 solves)

> Our servers were compromised!! Can you figure out which technique they used by looking at Apache access logs.
>
> flag format: DarkCTF{}

В приложениях лежит архив, в котором лежит ещё один архив, в котором лежит файл [logs.ctf](./logs.ctf). Я так и не 
понял, зачем такая вложенность, поэтому архивы я тянуть в репу не буду.

Честно говоря, я не знаю много названий техник web-атак, поэтому я сразу предположил, что будет
что-то типа SQL-инъекции. И действительно, есть подозрительные строки, одна из которых выглядит так:
```
192.168.32.1 - - [29/Sep/2015:03:37:34 -0400] "GET /mutillidae/index.php?page=user-info.php&username=%27+union+all+select+1%2CString.fromCharCode%28102%2C+108%2C+97%2C+103%2C+32%2C+105%2C+115%2C+32%2C+83%2C+81%2C+76%2C+95%2C+73%2C+110%2C+106%2C+101%2C+99%2C+116%2C+105%2C+111%2C+110%29%2C3+--%2B&password=&user-info-php-submit-button=View+Account+Details HTTP/1.1" 200 9582 "http://192.168.32.134/mutillidae/index.php?page=user-info.php&username=something&password=&user-info-php-submit-button=View+Account+Details" "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36"
```

Ну тут `UNION` всё выдаёт. Я сразу пошёл подбирать флаг, заключая его в указанный формат. Я и разный регистр пробовал, и
слитно писать, и через `_`, но ничего не работало. Через какое-то время я решил разгадать вот эту часть, которая мне
была непонятна:
```
String.fromCharCode%28102%2C%2B108%2C%2B97%2C%2B103%2C%2B32%2C%2B105%2C%2B115%2C%2B32%2C%2B68%2C%2B97%2C%2B114%2C%2B107%2C%2B67%2C%2B84%2C%2B70%2C%2B123%2C%2B53%2C%2B113%2C%2B108%2C%2B95%2C%2B49%2C%2B110%2C%2B106%2C%2B51%2C%2B99%2C%2B116%2C%2B49%2C%2B48%2C%2B110%2C%2B125%29%2C3
```

Вначале я декодировал URL через [URLDecode](https://www.urldecode.org):
```
String.fromCharCode(102,+108,+97,+103,+32,+105,+115,+32,+68,+97,+114,+107,+67,+84,+70,+123,+53,+113,+108,+95,+49,+110,+106,+51,+99,+116,+49,+48,+110,+125),3
```

Далее загуглил, с каким языком имею дело: [String.fromCharCode()](https://developer.mozilla.org/ru/docs/Web/JavaScript/Reference/Global_Objects/String/fromCharCode).
Ага, JavaScript. Ну тогда можно прямо в браузере консолью воспользоваться:
```js
>> String.fromCharCode(102,+108,+97,+103,+32,+105,+115,+32,+68,+97,+114,+107,+67,+84,+70,+123,+53,+113,+108,+95,+49,+110,+106,+51,+99,+116,+49,+48,+110,+125)
"flag is DarkCTF{5ql_1nj3ct10n}"
```

А, ну теперь ясно, почему подбор был неуспешным.
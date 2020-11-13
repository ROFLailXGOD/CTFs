# Callboy (127 points, 207 solves)

> Have you ever called a Callboy? No!? Then you should definitely try it. To make it a pleasant experience for you, we 
> have recorded a call with our Callboy to help you get started, so that there is no embarrassing silence between you.
>
> PS: do not forget the to wrap flag{} around the secret 

К данному заданию прикреплён файл [Callboy.pcapng](./Callboy.pcapng). Я сразу же понял, что это дамп сетевого
трафика. К сожалению, особого опыта с подобными заданиями у меня не было, я лишь знал, что этот файл можно
анализировать через [Wireshark](https://www.wireshark.org/). Я долго гуглил различные подходы, ибо по сути это
поиск иголки в стоге сена. Я искал файлы, например, но их не оказалось. Однако подсказка была на самом видном месте -
в названии (да и в описании тоже).

Если упорядочить данные по колонке `Протокол`, то можно обнаружить обилие [RTP](https://en.wikipedia.org/wiki/Real-time_Transport_Protocol)
пакетов:

```
The Real-time Transport Protocol (RTP) is a network protocol for delivering audio and video over IP networks.
```

Передача аудио? Callboy? Да у нас, похоже, джекпот! Всё, что осталось, это прослушать сообщение. Через Wireshark это
делается так:

1. В меню выбираем `Telephony -> RTP -> RTP Streams`. Получаем следующее окно:

![](https://i.imgur.com/VmG0I0p.png)

2. Выбираем первое (по идее надо просто все проверить) и жмём `Analyze`. Открывается следующее окно:

![](https://i.imgur.com/rJWqOhj.png)

3. Просто нажимаем `Play Streams`. Открывается ещё одно окно:

![](https://i.imgur.com/swtemFM.png)

4. Прослушиваем аудио, в котором нам буквально диктуют флаг:

```
flag{call_me_baby_1337_more_times}
```

Очень интересное задание, если честно. Я ожидал чего-то совершенно другого.

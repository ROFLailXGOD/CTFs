# Welcome! (100 points, 480 solves)

> Welcome to DUCTF!
>
> ssh ductf@chal.duc.tf -p 30301
> 
> Password: ductf
> 
> Epilepsy warning

Подключаемся к серверу и видим спам из цветных сообщений.

![](https://i.imgur.com/qwSopl6.png)

Они появляются так быстро, что заметить флаг трудно. Скриншот, конечно, помогает, но во время соревнования
я сделал так:

```shell script
$ ssh ductf@chal.duc.tf -p 30301 > file.txt
ductf@chal.duc.tf's password: 
Connection to chal.duc.tf closed.
$ strings file.txt | grep "DUCTF{"
[10;11HDUCTF{w3lc0m3_t0_DUCTF_h4v3_fun!}
```

Это было нетрудно.

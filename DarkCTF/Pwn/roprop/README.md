# roprop (313 points, 171 solves)

> This is from the back Solar Designer times where you require rope to climb and get anything you want.
>
> nc pwn.darkarmy.xyz 5002

В приложениях находим файл [roprop](./roprop). Небольшое исследование показало, что перед нами
не что иное, как очередное задание на `ret2libc`. Я подозревал, что это одно из самых базовых заданий в этой
категории и встречаться оно будет часто в различных CTF, поэтому сделал подробный разбор на примере 
[Return to what](../../../DownUnderCTF%202020/Pwn/Return%20to%20what) из DownUnderCTF 2020. Собственно, решения
никак не отличаются, поэтому не вижу смысла повторяться. Можно ещё в [roprop.py](./roprop.py) заглянуть, там тоже есть
пара комментариев.
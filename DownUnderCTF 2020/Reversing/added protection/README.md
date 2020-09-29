# added protection (200 points, 187 solves)

> This binary has some e^tra added protection on the advanced 64bit shellcode

В файлах находим [added protection](./added_protection).

Честно говоря, я был под впечатлением от прошлого [задания](../formatting) и решил попробовать ту же
технику:
```shell script
$ chmod +x added_protection
$ ltrace -s 100 ./added_protection
fprintf(0x7f57dc51c5c0, "size of code: %zu\n", 130size of code: 130
)                                                                               = 18
mmap(0, 130, 7, 34)                                                                                                               = 0x7f57dc563000
memcpy(0x7f57dc563000, "H\203\354dH\211\341I\270DUCTF{adI\271v4ncedEnI\272crypt3dSI\273hellCodeI\274}Can u fI\275ind the I\276flag?   A\277\n\0\0\0AWAVAUATASARAQAP\270"..., 130) = 0x7f57dc563000
Can u find the flag?   
+++ exited (status 1) +++
```

Ой, кажется, `memcpy` выдаёт нам флаг, разбавленный какими-то символами. Однако никто не мешает попробовать отправить 
`DUCTF{adv4ncedEncrypt3dShellCode}`, и это сработало!

*Примечание:* сложность задания была помечена как `hard`, но его решили аж 187 человек. Что-то мне подсказывает, что моё
решение было неким обходным путём. Ни шеллкод, ни XOR, упомянутые в описании, не пригодились.

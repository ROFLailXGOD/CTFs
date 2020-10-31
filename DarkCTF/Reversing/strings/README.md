# strings (363 points, 133 solves)

> Just manipulation of couple of strings....
>
> Note: Enclose the final output inside darkCTF{} [File](./strings)

Пойдём по проверенной схеме и откроем файл в Ghidra:
```c
undefined8 main(void)

{
  int iVar1;
  size_t sVar2;
  ulong uVar3;
  undefined8 local_118;
  undefined8 local_110;
  undefined2 local_108;
  undefined local_106;
  undefined8 local_fc;
  undefined2 local_f4;
  undefined8 local_f2;
  undefined2 local_ea;
  char acStack232 [32];
  char local_c8 [32];
  undefined8 local_a8;
  undefined8 local_a0;
  undefined2 local_98;
  undefined local_96;
  byte local_88 [32];
  int local_68;
  int local_64;
  char *local_60;
  char *local_58;
  int local_50;
  int local_4c;
  int local_48;
  int local_44;
  int local_40;
  int local_3c;
  int local_38;
  int local_34;
  int local_30;
  int local_2c;
  int local_28;
  int local_24;
  int local_20;
  int local_1c;
  
  setbuf(stdout,(char *)0x0);
  setbuf(stdin,(char *)0x0);
  setbuf(stderr,(char *)0x0);
  local_1c = 0;
  local_20 = 1;
  local_58 = "ZUB*aVrOUsCPS;$R=Q";
  local_60 = "!8u)05/>!#,.W/%H-G";
  printf("Use this as ur input:  %s\n","!8u)05/>!#,.W/%H-G");
  __isoc99_scanf("%[^\n]%*c");
...
// Ещё куча логики
```

Честно говоря, разбираться с декомпиляцией желания не было, ибо смотрелось там всё не очень просто. 
Поэтому я решил пойти по накатанному пути с gdb. Однако на пару вещей я всё же обратил внимание. В `local_58` и
`local_60` лежат какие-то интересные строки. Вполне вероятно, что они используются для получения флага. Программа даже
предлагает использовать вторую в качестве входной строки. Что же, так и поступим. Поставим брейкпоинт в самом конце 
`main` и запустим программу:
```shell script
gdb-peda$ disas main
...
   0x00000000000014ee <+889>:	call   0x1060 <strncat@plt>
   0x00000000000014f3 <+894>:	add    DWORD PTR [rbp-0x44],0x1
   0x00000000000014f7 <+898>:	sub    DWORD PTR [rbp-0x48],0x1
   0x00000000000014fb <+902>:	cmp    DWORD PTR [rbp-0x48],0x0
   0x00000000000014ff <+906>:	jns    0x14a5 <main+816>
   0x0000000000001501 <+908>:	mov    eax,0x0
   0x0000000000001506 <+913>:	add    rsp,0x108
   0x000000000000150d <+920>:	pop    rbx
   0x000000000000150e <+921>:	pop    rbp
   0x000000000000150f <+922>:	ret    
End of assembler dump.
gdb-peda$ b *main+908
gdb-peda$ r
Use this as ur input:  !8u)05/>!#,.W/%H-G
$ !8u)05/>!#,.W/%H-G
...
[------------------------------------stack-------------------------------------]
0000| 0x7fffffffdce0 ("wah_howdu_found_me")
0008| 0x7fffffffdce8 ("u_found_me")
0016| 0x7fffffffdcf0 --> 0x3400000656d 
0024| 0x7fffffffdcf8 --> 0x6f6e5f6500000340 
0032| 0x7fffffffdd00 --> 0x687700615f6f645f ('_do_a')
0040| 0x7fffffffdd08 --> 0x6d647566757768 ('hwufudm')
0048| 0x7fffffffdd10 ("v|ml|wl|z")
0056| 0x7fffffffdd18 --> 0x3400000007a 
[------------------------------------------------------------------------------]
Legend: code, data, rodata, value

Breakpoint 1, 0x0000555555555501 in main ()
```

Очень интересная строка лежит в стаке. Это и есть флаг, главное не забыть добавить `darkCTF{}`.

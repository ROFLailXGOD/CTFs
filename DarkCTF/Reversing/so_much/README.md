# so_much (186 points, 283 solves)

> strcmp printf

В приложениях находим [so_much](./so_much). Откроем файл в Ghidra. Первое, что бросается в глаза, -
большое количество функций вида `flag_*`. Но начнём с `main()`:
```c
undefined8 main(int param_1,long param_2)
{
  int iVar1;
  long in_FS_OFFSET;
  char *local_18;
  long local_10;
  
  local_10 = *(long *)(in_FS_OFFSET + 0x28);
  local_18 = "";
  get_flag(&local_18);
  if (param_1 == 2) {
    iVar1 = strcmp(*(char **)(param_2 + 8),local_18);
    if (iVar1 == 0) {
      printf("darkCTF%s\n",local_18);
      puts("WoW! so much revving...");
    }
    else {
      puts("Nada. Not the right password!\n*Psst the password is part of the flag*");
    }
  }
  else {
    puts("Let\'s have an argument. Shall we?");
  }
  if (local_10 != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return 0;
}
```

Что здесь происходит? В переменную `local_18` заносится какое-то значение в ветке `get_flag()` и
во всех вложенных функциях. Потом уже происходит сравнение с тем, что мы передаём в программу. Подождите, генерация
строки, которая попадает в `local_18` никак не зависит от нашего ввода. Так давайте в gdb подгоним значение
регистра так, чтобы проверка
```c
if (iVar1 == 0) {
```
вернула `True`.
```
$ gdb so_much
gdb-peda$ disas main
Dump of assembler code for function main:
   0x00000000000011c9 <+0>:	endbr64 
   0x00000000000011cd <+4>:	push   rbp
   0x00000000000011ce <+5>:	mov    rbp,rsp
   0x00000000000011d1 <+8>:	sub    rsp,0x20
   0x00000000000011d5 <+12>:	mov    DWORD PTR [rbp-0x14],edi
   0x00000000000011d8 <+15>:	mov    QWORD PTR [rbp-0x20],rsi
   0x00000000000011dc <+19>:	mov    rax,QWORD PTR fs:0x28
   0x00000000000011e5 <+28>:	mov    QWORD PTR [rbp-0x8],rax
   0x00000000000011e9 <+32>:	xor    eax,eax
   0x00000000000011eb <+34>:	lea    rax,[rip+0xe16]        # 0x2008
   0x00000000000011f2 <+41>:	mov    QWORD PTR [rbp-0x10],rax
   0x00000000000011f6 <+45>:	lea    rax,[rbp-0x10]
   0x00000000000011fa <+49>:	mov    rdi,rax
   0x00000000000011fd <+52>:	call   0x1281 <get_flag>
   0x0000000000001202 <+57>:	cmp    DWORD PTR [rbp-0x14],0x2
   0x0000000000001206 <+61>:	jne    0x125a <main+145>
   0x0000000000001208 <+63>:	mov    rdx,QWORD PTR [rbp-0x10]
   0x000000000000120c <+67>:	mov    rax,QWORD PTR [rbp-0x20]
   0x0000000000001210 <+71>:	add    rax,0x8
   0x0000000000001214 <+75>:	mov    rax,QWORD PTR [rax]
   0x0000000000001217 <+78>:	mov    rsi,rdx
   0x000000000000121a <+81>:	mov    rdi,rax
   0x000000000000121d <+84>:	call   0x10c0 <strcmp@plt>
   0x0000000000001222 <+89>:	test   eax,eax
   0x0000000000001224 <+91>:	jne    0x124c <main+131>
   0x0000000000001226 <+93>:	mov    rax,QWORD PTR [rbp-0x10]
   0x000000000000122a <+97>:	mov    rsi,rax
   0x000000000000122d <+100>:	lea    rdi,[rip+0xdd5]        # 0x2009
   0x0000000000001234 <+107>:	mov    eax,0x0
   0x0000000000001239 <+112>:	call   0x10b0 <printf@plt>
...
```

Нас интересует последнее сравнение перед `printf()`, т.е. `main+89`. Ставим брейкпоинт, запускаем со случайным 
аргументом, меняем `eax` регистр и продолжаем работу программы:
```
gdb-peda$ b *main+89
gdb-peda$ r "random str"
gdb-peda$ set $eax=0
gdb-peda$ c
Continuing.
darkCTF{w0w_s0_m4ny_funct10ns}
WoW! so much revving...
```

Это было нетрудно.
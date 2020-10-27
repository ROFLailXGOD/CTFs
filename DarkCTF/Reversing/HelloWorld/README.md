# HelloWorld (298 points, 182 solves)

> taking small Bites of Bytes

В приложениях архив с файлом [hw](./hw). Вновь смотрим на него в Ghidra:
```c
undefined8 main(int param_1,long param_2)
{
  int iVar1;
  
  if (param_1 == 3) {
    iVar1 = check(*(undefined8 *)(param_2 + 8),1);
    if (iVar1 == 0) {
      iVar1 = check(*(undefined8 *)(param_2 + 0x10),2);
      if (iVar1 == 0) {
        print();
      }
      else {
        printf("invalid argument: %s\n",*(undefined8 *)(param_2 + 0x10));
      }
    }
    else {
      printf("invalid argument: %s\n",*(undefined8 *)(param_2 + 8));
    }
  }
  else {
    puts("Enter the right arguments");
  }
  return 0;
}
```

Вновь, как и в [so_much](../so_much), наши переданные аргументы нужны лишь в `if` выражениях. Аналогично 
прошлой задачке предлагаю воспользоваться gdb:
```
gdb-peda$ disas main
Dump of assembler code for function main:
   0x0000000000001209 <+0>:	endbr64 
   0x000000000000120d <+4>:	push   rbp
   0x000000000000120e <+5>:	mov    rbp,rsp
   0x0000000000001211 <+8>:	sub    rsp,0x10
   0x0000000000001215 <+12>:	mov    DWORD PTR [rbp-0x4],edi
   0x0000000000001218 <+15>:	mov    QWORD PTR [rbp-0x10],rsi
   0x000000000000121c <+19>:	cmp    DWORD PTR [rbp-0x4],0x3
   0x0000000000001220 <+23>:	je     0x1230 <main+39>
   0x0000000000001222 <+25>:	lea    rdi,[rip+0xddf]        # 0x2008
   0x0000000000001229 <+32>:	call   0x10c0 <puts@plt>
   0x000000000000122e <+37>:	jmp    0x12af <main+166>
   0x0000000000001230 <+39>:	mov    rax,QWORD PTR [rbp-0x10]
   0x0000000000001234 <+43>:	add    rax,0x8
   0x0000000000001238 <+47>:	mov    rax,QWORD PTR [rax]
   0x000000000000123b <+50>:	mov    esi,0x1
   0x0000000000001240 <+55>:	mov    rdi,rax
   0x0000000000001243 <+58>:	call   0x14c5 <check>
   0x0000000000001248 <+63>:	test   eax,eax
   0x000000000000124a <+65>:	jne    0x1290 <main+135>
   0x000000000000124c <+67>:	mov    rax,QWORD PTR [rbp-0x10]
   0x0000000000001250 <+71>:	add    rax,0x10
   0x0000000000001254 <+75>:	mov    rax,QWORD PTR [rax]
   0x0000000000001257 <+78>:	mov    esi,0x2
   0x000000000000125c <+83>:	mov    rdi,rax
   0x000000000000125f <+86>:	call   0x14c5 <check>
   0x0000000000001264 <+91>:	test   eax,eax
   0x0000000000001266 <+93>:	jne    0x126f <main+102>
   0x0000000000001268 <+95>:	call   0x12b6 <print>
...
```

Интересные адреса: `main+63` и `main+91`.
```
gdb-peda$ b *main+63
gdb-peda$ b *main+91
gdb-peda$ r "a" "b"
Breakpoint 1, 0x0000555555555248 in main ()
gdb-peda$ set $eax=0
gdb-peda$ c
Breakpoint 2, 0x0000555555555264 in main ()
gdb-peda$ set $eax=0
gdb-peda$ c
Continuing.
darkCTF{4rgum3nts_are_v3ry_1mp0rt4nt!!!}
```
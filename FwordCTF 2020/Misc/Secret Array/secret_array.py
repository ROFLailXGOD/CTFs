from pwn import *


conn = remote('secretarray.fword.wtf', 1337)
intro = conn.recvuntil('START:\n')
sums = []
for i in range(1, 1337):
    conn.sendline(f'0 {i}')
    a = conn.recvline()
    b = int(str(a)[2:-3])
    sums.append(b)
    print(i, b)

conn.sendline('1 2')
a = conn.recvline()
z_plus_y = int(str(a)[2:-3])
z_minus_y = sums[1] - sums[0]

y = (z_plus_y - z_minus_y) // 2

result = []
result.append(sums[0] - y)
result.append(y)
for i in range(1, 1336):
    result.append(sums[i] - result[0])

output = 'DONE'
for i in range(1337):
    output += f' {result[i]}'

conn.sendline(output)
print(conn.recvline())
print(conn.recvline())

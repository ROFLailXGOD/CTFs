from pwn import *
from Crypto.Util.strxor import strxor

flag = b''
for i in range(6):
    conn = remote('chal.duc.tf', 30201)
    conn.recvuntil(b'read: ')

    hash = conn.recvline().strip().decode()
    blocks = [bytes.fromhex(hash[i:i+32]) for i in range(0, len(hash), 32)]

    conn.recv()
    if i == 0:
        conn.sendline(blocks[0].hex())
        conn.recv()
        conn.sendline(blocks[0].hex())
        data = conn.recv().strip().decode()
        flag += bytes.fromhex(data[:32])
    else:
        payload = 16 * b'\x10'
        xored = strxor(blocks[i-1], blocks[i])
        conn.sendline(payload.hex())
        iv = conn.recv().strip().decode()
        iv = bytes.fromhex(iv[32:64])
        xored = strxor(iv, xored)
        conn.sendline(xored.hex())
        data = conn.recv().strip().decode()
        data = data[:32]
        flag += bytes.fromhex(data)

print(flag)

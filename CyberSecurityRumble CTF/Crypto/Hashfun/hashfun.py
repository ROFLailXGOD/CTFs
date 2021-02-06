encoded = [10, 30, 31, 62, 27, 9, 4, 0, 1, 1, 4, 4, 7, 13, 8, 12, 21, 28, 12, 6, 60]
flag = 'CSR{'

for i in range(len(encoded)):
    flag += chr(encoded[i] ^ ord(flag[i]))

print(flag)

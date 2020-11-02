with open('./lsb1.bmp', 'rb') as f:
    img = f.read()

mult = 128
out = 0
for i in range(54, 54+40*8):
    bit = img[i] & 1
    out += bit * mult
    if mult != 1:
        mult //= 2
    else:
        mult = 128
        print(chr(out), end='')
        out = 0

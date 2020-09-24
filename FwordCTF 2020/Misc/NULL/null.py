import binascii

ihdr_start = bytearray(b'\x49\x48\x44\x52')
ihdr_end = bytearray(b'\x08\x06\x00\x00\x00')
crc32 = 0xe3677ec0
for w in range(2000):
    for h in range(2000):
        ihdr = ihdr_start + w.to_bytes(4, 'big') + h.to_bytes(4, 'big') + ihdr_end
        if binascii.crc32(ihdr) == crc32:
            print(w, h)
            exit(0)

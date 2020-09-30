def add(num1, num2):
    res = 0
    for i in range(4):
        res += (((num1 & 1) + (num2 & 1)) % 2) << i
        num1 >>= 1
        num2 >>= 1
    return res


# b'The secret message is:'.hex()
plain = '54686520736563726574206d6573736167652069733a'
cipher = '85677bc8302bb20f3be728f99be0002ee88bc8fdc045'


def bruteforce(key: str, inp: str, out: str, s: int, pos: int):
    if inp in key:
        res = add(key.index(inp), s)
        if out in key and key.index(out) != res:
            return
        if out not in key and key[res] != 'X':
            return
        cur_key = key[:res] + out + key[res+1:]
        bruteforce(cur_key, plain[pos+1], cipher[pos+1], cur_key.index(inp), pos+1)

    for i in range(16):
        if key[i] != 'X':
            continue

        cur_key = key[:i] + inp + key[i+1:]
        res = add(i, s)

        if out in cur_key and cur_key.index(out) != res:
            continue
        if out not in cur_key and cur_key[res] != 'X':
            continue
        cur_key = cur_key[:res] + out + cur_key[res+1:]
        if 'X' not in cur_key:
            print(cur_key)
            return
        bruteforce(cur_key, plain[pos+1], cipher[pos+1], i, pos+1)


# bruteforce('XXXXXXXXXXXXXXXX', plain[0], cipher[0], 7, 0)
key = '456b7e812c3af90d'
out = '85677bc8302bb20f3be728f99be0002ee88bc8fdc045b80e1dd22bc8fcc0034dd809e8f77023fbc83cd02ec8fbb11cc02cdbb62837677bc8f2277eeaaaabb1188bc998087bef3bcf40683cd02eef48f44aaee805b8045453a546815639e6592c173e4994e044a9084ea4000049e1e7e9873fc90ab9e1d4437fc9836aa80423cc2198882a'


def guess_char(flag: str):
    while len(flag) != len(out):
        for i in range(32, 176):
            cur_flag = flag + chr(i).encode('utf_8').hex()

            ciphertext = ''
            s = 7
            for m_i in cur_flag:
                c_i = key[add(key.index(m_i), s)]
                ciphertext += c_i
                s = key.index(m_i)

            if ciphertext in out:
                guess_char(cur_flag)
    print(bytes.fromhex(flag))
    exit(0)


guess_char(b'The secret message is:'.hex())

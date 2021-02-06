from hashlib import sha1
from ecdsa.curves import SECP256k1
from ecdsa.numbertheory import inverse_mod
from ecdsa import SigningKey


n = SECP256k1.order

r = int('13d8f71de2338048bcddd4846ea9762fa022172b6602f269c519892d8bf7e94f', 16)
s1 = int('d97cd3f867ef3bacfc4059d69e1a7d1221eae9ec136709b01264b26f35e69275', 16)
m1 = b'test'
z1 = int(sha1(m1).hexdigest(), 16)

s2 = int('88c20c839ef03abce59bfcbd8bbad4206e6e0812044139f695de024ac852bbf4', 16)
m2 = b'1234'
z2 = int(sha1(m2).hexdigest(), 16)

k = (((z1 - z2) % n) * inverse_mod(s1 - s2, n)) % n


dA = ((((s1 * k) % n) - z1) * inverse_mod(r, n)) % n
print(hex(dA))

sk = SigningKey.from_secret_exponent(dA, curve=SECP256k1)
print(sk.sign(b'admin', k=k).hex())

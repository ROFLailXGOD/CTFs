N = 0x3b7c97ceb5f01f8d2095578d561cad0f22bf0e9c94eb35a9c41028247a201a6db95f
e = 0x10001
ct = 0x1B5358AD42B79E0471A9A8C84F5F8B947BA9CB996FA37B044F81E400F883A309B886

# http://factordb.com/index.php?query=1763350599372172240188600248087473321738860115540927328389207609428163138985769311
p = 31415926535897932384626433832795028841
q = 56129192858827520816193436882886842322337671

phi = (p - 1) * (q - 1)
d = pow(e, -1, phi)  # Python 3.8 and higher
m = pow(ct, d, N)

print(m.to_bytes(31, 'big'))
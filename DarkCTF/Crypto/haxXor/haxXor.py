from Crypto.Util.strxor import strxor

inp = '5552415c2b3525105a4657071b3e0b5f494b034515'
inp = bytes.fromhex(inp)
ctf = b'darkCTF{'
print(strxor(ctf, inp[:len(ctf)]))  # b'1337hack'

key = b'1337hack'*10
print(strxor(inp, key[:len(inp)]))

prefix = 'Hello. Your flag is DarkCTF{'
suffix = '}.'
main_string = 'c an u br ea k th is we ir d en cr yp ti on'.split()

res = 'eawethkthcrthcrthonutiuckirthoniskisuucthththcrthanthisucthirisbruceaeathanisutheneabrkeaeathisenbrctheneacisirkonbristhwebranbrkkonbrisbranthypbrbrkonkirbrciskkoneatibrbrbrbrtheakonbrisbrckoneauisubrbreacthenkoneaypbrbrisyputi'


def get_index(string):
    if string[:2] in main_string:
        index = main_string.index(string[:2])
        string = string[2:]
    else:
        index = main_string.index(string[:1])
        string = string[1:]
    return index, string


out = ''
while len(res):
    i1, res = get_index(res)
    i2, res = get_index(res)

    out += chr(i1 * 16 + i2)

print(out)

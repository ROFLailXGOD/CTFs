import pickle

with open('data', 'rb') as f:
    data = pickle.load(f)
    flag = ''
    for _, v in data.items():
        if _ == 24:
            break
        if isinstance(v, int):
            flag += chr(v)
        else:
            flag += v
print(flag)

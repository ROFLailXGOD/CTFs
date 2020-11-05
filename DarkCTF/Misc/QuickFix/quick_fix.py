from cv2 import imread, imwrite, vconcat, hconcat


png = b'\x89\x50\x4e\x47\x0d\x0a\x1a\x0a'
for i in range(100):
    for j in range(100):
        with open(f'./images/flag_{i}_{j}.jpg', 'rb') as inp, open(f'./images_fixed/flag_{i}_{j}.png', 'wb') as out:
            inp_b = inp.read()
            out.write(png)
            out.write(inp_b[10:])

img_v = []
for i in range(100):
    img_h = []
    for j in range(100):
        img_h.append(imread(f'./images_fixed/flag_{i}_{j}.png'))
    img_v.append(hconcat(img_h))
imwrite('./out.png', vconcat(img_v))

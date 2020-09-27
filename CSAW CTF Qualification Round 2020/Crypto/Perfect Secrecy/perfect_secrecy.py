from PIL import Image, ImageChops

# Open images
im1 = Image.open("/home/vofel/Downloads/image1.png")
im2 = Image.open("/home/vofel/Downloads/image2.png")

result = ImageChops.logical_xor(im1, im2)
result.save('result.png')

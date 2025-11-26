import math
import numpy as np
from PIL import Image
import sys
import random
import copy
import ImageGen

def four_bit_to_hex(four_bit):
    return str(four_bit) if four_bit < 10 else chr(four_bit+65-10)

def rgb_to_12_hex(rgb):
    return four_bit_to_hex(rgb[0]>>4) + four_bit_to_hex(rgb[1]>>4) + four_bit_to_hex(rgb[2]>>4)

path = "brent1.png"

colour_space = []

for r in [0, 255]:#range(0, 255, 16):
    for g in [0, 255]:#range(0, 255, 16):
        for b in [0, 255]:#range(0, 255, 16):
            colour_space.append([r, g, b])

dithered_img, non_dithered_img = ImageGen.ReturnDitheredImage(path, width=640, height=480, colour=True, colour_space=colour_space, returnNoDitherToo=True)

image_sv = open(f"image_{path.split('.')[0]}.sv", 'w')

image_sv.write("module image_rom (\n\tinput logic [9:0] v_count,\n\tinput logic [9:0] h_count,\n\toutput logic [11:0] rgb_colour\n);\n\tconst [11:0] array[0:479][0:639] = '{")

for y in range(480):
    image_sv.write("\n\t\t'{")
    image_sv.write(f"12'h{rgb_to_12_hex(dithered_img[y][0])}")
    for x in range(1, 640):
        if x < len(dithered_img[0]):
            image_sv.write(f", 12'h{rgb_to_12_hex(dithered_img[y][x])}")
        else:
            image_sv.write(f", 12'h000")
    image_sv.write("\t},")
image_sv.write("};\n")

image_sv.write("\n\tassign rgb_colour = array[v_count][h_count];\nendmodule")
image_sv.close()


ImageGen.saveImage(dithered_img, path+"_Dithered.png", colour=True)
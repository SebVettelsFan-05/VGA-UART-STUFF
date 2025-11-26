import math
import numpy as np
from PIL import Image
import sys
import random
import copy
import ImageGen

path = "brent1.png"

file = open("foo.txt")

colour_space = [[0,0,0], [255, 255, 255]]

dithered_img, non_dithered_img = ImageGen.ReturnDitheredImage(path, width=640, height=480, colour=True, colour_space=colour_space, returnNoDitherToo=True)

print(dithered_img)
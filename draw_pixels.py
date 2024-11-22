import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
import numpy as np
import argparse
import sys

def get_pixel_data(infilepath: str, is_from_fpga=True, image_width=256, image_height=256):
    pixel_map = np.ndarray(shape=(image_width, image_height, 3))
    with open(infilepath, 'r') as f:
        processing_time = float(f.readline().removesuffix('\n').removesuffix(','))
        if is_from_fpga:
            processing_time /= (200.0 * 10**3) # 10^3 not 10^6 because we want ms not s
        for i in range(image_width):
            for j in range(image_height):
                rgb_str = f.readline().removesuffix('\n').removesuffix(',')
                rgb_data = [float(i) for i in rgb_str.split(',')]
                pixel_map[i][j] = [rgb_data[k]/256.0 for k in range(3)]
    return pixel_map

def plot_pixels(pixel_map: np.ndarray, outfilepath: str):
    # there is probably a MUCH better way of
    # mapping individual RGB values into a Colormap,
    # but this brute force way works too
    N = 256 #16777216
    vals = np.ones((N,4))
    vals[:, 0] = np.linspace(0, 1, N)
    vals[:, 1] = np.linspace(0, 1, N)
    vals[:, 2] = np.linspace(0, 1, N)
    cmap = ListedColormap(vals)
    plt.imsave(outfilepath, pixel_map, cmap=cmap)

if __name__ == '__main__':
    arg_parser = argparse.ArgumentParser(description="ECE 759 Pixel Script; outputs a PNG of the generated frame buffer image", exit_on_error=False)

    DEFAULT_IMAGE_OUTPUT = 'output.png'
    arg_parser.add_argument('-i', metavar='<input file>', dest='input', type=str, required=True, help='csv/list of RGB colors to display as an image')
    arg_parser.add_argument('-o', metavar='<output image file>', dest='output', type=str, required=False, default=DEFAULT_IMAGE_OUTPUT, help=f'output image file name, default: {DEFAULT_IMAGE_OUTPUT}')
    arg_parser.add_argument('-wid', metavar='<width>', dest='width', type=int, required=False, default=256, help='output image file width, default: 256')
    arg_parser.add_argument('-hgt', metavar='<height>', dest='height', type=int, required=False, default=256, help='output image file height, default: 256')

    try:
        cla = arg_parser.parse_args()
    except:
        arg_parser.print_help()
        sys.exit(1)

    plot_pixels(pixel_map=get_pixel_data(infilepath=cla.input, image_width=cla.width, image_height=cla.height), outfilepath=cla.output)
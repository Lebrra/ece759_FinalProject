import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
import numpy as np
import argparse
import sys

def get_pixel_data(infilepath: str, is_from_fpga=True):
    xs = []
    ys = []
    with open(infilepath, 'r') as f:
        processing_time = float(f.readline().removesuffix('\n'))
        
        # if we are getting the data from the FPGA, we need to calculate the time from the clock cycles
        if is_from_fpga:
            processing_time /= (200.0 * 10**3) # 10^3 not 10^6 because we want ms not s
        
        print('Execution time in ms: ' + str(processing_time))

        while True:
            point_str = f.readline().removesuffix('\n')
            if point_str == "": break # if last line is blank then ignore it
            point = [float(i) for i in point_str.split(',')]
            if (point[2] == 0): continue
            xs.append(point[0])
            ys.append(point[1])

        plt.plot(xs, ys, '.', ms=1)
        plt.show()

# this probably will be used for the SW side, the HW side runs the pixel extraction automatically
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

    get_pixel_data(infilepath=cla.input, is_from_fpga=False)

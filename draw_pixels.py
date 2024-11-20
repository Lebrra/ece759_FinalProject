import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
import numpy as np

def get_pixel_data(infilepath: str, is_from_fpga=True, image_width=256, image_height=256):
    pixel_map = np.ndarray(shape=(image_width, image_height, 3))
    with open(infilepath, 'r') as f:
        processing_time = float(f.readline().removeprefix('"').removesuffix('",\n'))
        if is_from_fpga:
            processing_time /= (200.0 * 10**3) # 10^3 not 10^6 because we want ms not s
        for i in range(image_width):
            for j in range(image_height):
                rgb_str = f.readline()
                rgb_data = [float(i) for i in rgb_str.removeprefix('"').removesuffix('",\n').split('","')]
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
    plot_pixels(pixel_map=get_pixel_data(infilepath='test_colors.csv', image_width=4, image_height=4), outfilepath='test.png')
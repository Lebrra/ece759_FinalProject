import os
import sys
import select
import serial
import numpy as np
from typing import List

# Expects num_triangles to be a string representation of the number of triangles in hex
def send_num_triangles(num_triangles: str, uart_socket:serial.Serial, debug=False):
    # convert to raw hex and send little endian
    raw_hex = bytes.fromhex(num_triangles)
    if debug:
        print(raw_hex.hex())
    else:
        uart_socket.write(raw_hex)



# Expects triangle_data to be list of 9 floats; x, y, z coords for 3 vertices
def send_triangle(triangle_data: List[np.float16], uart_socket: serial.Serial, debug=False):
    # for each coordinate in this triangle, convert to raw hex and send little endian
    for i in range(9):
        coord = triangle_data[i]
        raw_hex = coord.tobytes()
        if debug:
            print(raw_hex.hex())
        else:
            uart_socket.write(raw_hex)

# expects the file to be a .CSV, where the first line is the number of triangles,
# and each subsequent line is a vertex, that holds x,y,z coordinates for that vertex
def send_file(file_path: str, uart_socket: serial.Serial, status_msg=True, debug=False):
    if not os.path.isfile(file_path):
        print('Bootloader Error: Unable to find specified file to send')
        return

    with open(file_path, 'r') as f:
        # read the number of triangles
        file_data = f.readlines()
        num_triangles = int(file_data[0].removeprefix('"').removesuffix('"\n'))

        if status_msg:
            print('Sending...')

        # send the number of triangles to the FPGA
        send_num_triangles(hex(num_triangles)[2:].zfill(8), uart_socket, debug)
        
        # for each triangle, send it's vertex data to the FPGA
        for i in range(1, num_triangles + 1):
            triangle = []
            for j in range(3):
                vertex = file_data[i+j]

                if status_msg:
                    print(vertex)

                vertices = vertex.split(',')
                for k in range(3):
                    triangle.append(np.float16(vertices[k].removeprefix('"').removesuffix('"').removesuffix('"\n')))
            send_triangle(triangle, uart_socket, debug)

        if status_msg:
            print('Transmission complete\n\n')
    return

def read_framebuffer(uart_socket: serial.Serial, output_file: str):
    with open(output_file, '+w') as f:
        print('Reading frame buffer data. Press enter to exit\n\n')
        have_read_timing=False
        while True:
            data = list(uart_socket.read(3))
            if len(data) > 0:
                # read the timing info
                if not have_read_timing:
                    have_read_timing = True
                    time = 0
                    i = 2
                    for byte in data:
                        time += int(byte) + (i*256)
                        i -= 1
                    f.write('"'+time+'",\n')

                # read the RGB values
                for byte in data:
                    f.write('"'+int(byte)+'",')
                f.write('\n')

            # break out of data collection on enter key hit
            if select.select([sys.stdin], [], [], 0) == ([sys.stdin], [], []):
                c = sys.stdin.read(1)
                if c == '\n':
                    break
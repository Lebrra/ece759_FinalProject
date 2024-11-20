import argparse
import serial
import sys
from bootloader import send_file, read_framebuffer
from draw_pixels import *

DEFAULT_BAUD_RATE = 115200
DEFAULT_DEBUG = False
DEFAULT_READ_TIMEOUT = 0.01
DEFAULT_SERIAL_PORT = '/dev/ttyUSB0'
DEFAULT_TRIANGLE_FILE = '../vectors.csv'
DEFAULT_OUTPUT_FILE = 'FPGA_framebuffer.csv'
DEFAULT_IMAGE_FILE = 'FPGA_image.png'

# Handles CLA arguments
def parse_args():
    arg_parser = argparse.ArgumentParser(description='ECE 759 Bootloader and Frame Buffer Reader; Based on Scripts from ECE 554', exit_on_error=False)

    # Initialize possible arguments
    arg_parser.add_argument('-p', metavar='<port>', dest='port', type=str, required=False, default=DEFAULT_SERIAL_PORT, help=f'Port to open serial communication on. Default: {DEFAULT_SERIAL_PORT}')
    arg_parser.add_argument('-b', metavar='<baud>', dest='baud', type=int, required=False, default=DEFAULT_BAUD_RATE, help=f'Baud rate for serial port. Default: {DEFAULT_BAUD_RATE}')
    arg_parser.add_argument('-t', metavar='<read_timeout>', dest='r_timeout', type=float, required=False, default=DEFAULT_READ_TIMEOUT, help=f'Maximum time to read from serial before checking for keyboard input. Default: {DEFAULT_READ_TIMEOUT}')
    arg_parser.add_argument('-f', metavar='<triangle file>', dest='triangle_file', type=str, required=False, default=DEFAULT_TRIANGLE_FILE, help=f'Input file for reading triangle data. Default: {DEFAULT_TRIANGLE_FILE}')
    arg_parser.add_argument('-o', metavar='<output file>', dest='output', type=str, required=False, default=DEFAULT_OUTPUT_FILE, help=f'File to write the frame buffer data to as a comma separated list. Default: {DEFAULT_OUTPUT_FILE}')
    arg_parser.add_argument('-i', metavar='<output image>', dest='image', type=str, required=False, default=DEFAULT_IMAGE_FILE, help=f'Image file to generate of rasterization. Default: {DEFAULT_IMAGE_FILE}')
    arg_parser.add_argument('-d', metavar='<debug message>', dest='debug', type=bool, required=False, default=DEFAULT_DEBUG, help=f'Bootloader print data')

    # Process arguments
    try:
        cla = arg_parser.parse_args()
    except:
        arg_parser.print_help()
        sys.exit(1)

    return cla


# Opens the UART socket 
def open_serial(cla):
    try:
        uart_socket = serial.Serial(port=cla.port, baudrate=cla.baud, timeout=cla.r_timeout)
    except ValueError:
        print('Startup Error: Invalid uart baud')
        sys.exit(1)
    except serial.SerialException:
        print('Startup Error: Invalid uart port')
        sys.exit(1)

    return uart_socket


cla = parse_args()
uart_socket = open_serial(cla)

while True:
    user_input = input('\nPress b to bootload, r to read frame buffer, e to exit:')

    match user_input:
        case 'b':
            send_file(cla.triangle_file, uart_socket, True, cla.debug)
        case 'r':
            pass
            read_framebuffer(uart_socket, cla.output)
            plot_pixels(pixel_map=get_pixel_data(infilepath=cla.output), outfilepath=cla.image)
        case 'e':
            break
        case _:
            print('Invalid input')

sys.exit(0)
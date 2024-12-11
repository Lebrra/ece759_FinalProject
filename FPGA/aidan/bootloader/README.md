### How to use the bootloader ###
- This bootloader is meant to be run with Cyclone V FPGAs
- Hook up the FPGA to the USB UART cable, and connect the USB side to the host PC (this computer you're reading this from)
- Run the python script with python3 main.py -f {triangle vertex txt file} with several other optional flags (see main.py for options)
- Put the FPGA into bootloading mode, and press b on your keyboard
- Take the FPGA out of bootloading mode and wait for the status LED to indicate the calculation is done
- Put the FPGA into read mode, and press r on your keyboard
- The draw_pixels script should automatically run, and you should have the output image!
- You can now press e to exit the bootloader
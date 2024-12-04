### ECE 759 Final Project - Rasterization ###

## Steps to run: ##
1. Get a model (stl file)
2. Convert model to txt files:
    - (command line) python read_model.py -f [file name without extention]
    - this will generate 2 text files for the vetices and faces
    - ideally these should be placed in the WorkingFiles folder, but as long as they exist in the same place it doesn't matter
3. Rasterize!
    - (command line) rasterize.exe [file name without extention]
    - this is the base C++ execution
    - this will generate an txt output file in the same place as the two files it used
4. Convert back into image:
    - (command line) python draw_pixels.py -i [EXACT filename (ex filename_output.txt)]
    - this will generate the final image! (found in the same folder)
# https://github.com/pyvista/stl-reader
import random
import stl_reader
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-f', '--file', type=str, default="file.stl", help="stl file name (excluding .stl)")
args = parser.parse_args()

stl = f"{args.file}.stl"

vertices, faces = stl_reader.read(stl)

vertFile = open(f"{args.file}_vertices.txt", "w")
faceFile = open(f"{args.file}_faces.txt", "w")

print(f"Writing {len(vertices)} verticies to {args.file}_vertices.txt...")
vertFile.write(f"{len(vertices)}\n")
for i in range(len(vertices)):  # rounding for eaiser math later
    #print(f"{str(round(vertices[i][0], 2))}, {str(round(vertices[i][1], 2))}, {str(round(vertices[i][2], 2))}")
    vertFile.write(f"{str(round(vertices[i][0], 2))}, {str(round(vertices[i][1], 2))}, {str(round(vertices[i][2], 2))}\n")
print(f"Completed {args.file}_vertices.txt")

print(f"Writing {len(faces)} verticies to {args.file}_faces.txt...")
faceFile.write(f"{len(faces)}\n")
for i in range(len(faces)): # these are ints, no rounding
    #print(f"{faces[i][0]}, {faces[i][1]}, {faces[i][2]}")
    faceFile.write(f"{faces[i][0]}, {faces[i][1]}, {faces[i][2]}\n")
print(f"Completed {args.file}_faces.txt")
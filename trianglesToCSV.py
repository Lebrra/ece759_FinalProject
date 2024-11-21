# https://github.com/pyvista/stl-reader
import random
import stl_reader

vertices, faces = stl_reader.read("badSTLTest.stl")

rand = random.randrange(len(faces) - 20)

print("points")
for ind in range(rand, rand+20):
    print (vertices[ind])

print("\nfaces:")
for ind in range(rand, rand+20):
    print (faces[ind])
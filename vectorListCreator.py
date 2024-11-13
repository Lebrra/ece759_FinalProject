from xml.dom import minidom
import csv

svg_file = "testSVG.svg"
doc = minidom.parse(svg_file)
path_strings = [path.getAttribute('d') for path in doc.getElementsByTagName('path')]
doc.unlink()

iterator = 0
vector_str = []
for chunk in path_strings:
    for piece in chunk.split("l"):
        vector_str.append([])
        pair = piece.split(",")
        try:
            vector_str[iterator].append(int(''.join(c for c in pair[0] if c.isdigit() or c == "-")))
            vector_str[iterator].append(int(''.join(c for c in pair[1] if c.isdigit() or c == "-")))
        except:
            print("error parsing")
        iterator += 1

print(str(len(vector_str)))
for pair in vector_str:
    print(f"({pair[0]}, {pair[1]})")

with open("vectors.csv", 'w', newline='') as myfile:
     wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
     wr.writerow(str(len(vector_str)))
     for pair in vector_str:
        wr.writerow(pair)
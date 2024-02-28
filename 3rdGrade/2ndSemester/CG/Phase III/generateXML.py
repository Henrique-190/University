import math
import sys

d =  float(sys.argv[2])

alpha =  (math.pi * 2) / 16
x = d
z = 0.0
y = 0.0

out = open("out.txt", "w")

if(sys.argv[1]=="planet"):
    out.write(f'<point x="{x}" y="0" z="{z}" />\n')

    i=15
    while i>0:
        angle = i * alpha
        x = float(d * math.cos(angle))
        z = float(d * math.sin(angle))
        out.write(f'<point x="{x}" y="0" z="{z}" />\n')
        i = i -1
elif(sys.argv[1]=="comet"):
    i=0
    a = 290.0
    b = 30.0
    h = 265.0
    k = 0.0
    while i<16:
        angle = i * alpha
        x = float(h + a*math.cos(angle))
        z = float(k + b*math.sin(angle))
        y = float(0.1068 * x - 3.3981)
        out.write(f'<point x="{x}" y="{y}" z="{z}" />\n')
        i = i + 1



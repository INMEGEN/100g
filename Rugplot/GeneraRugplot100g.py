import numpy as np
import svgwrite, random
from rugplot import CircleMarker, Scatter
from pprint import pprint

lines = open("Datos95g.csv", "r").readlines()
g=[]
amr= []
eas=[]
sas=[]
eur=[]
afr=[]

for line in lines[1:]:
    campos = line.strip().split(",")

    g.append(float(campos[4]))
    amr.append(float(campos[5]))
    eas.append(float(campos[6]))
    sas.append(float(campos[7]))
    eur.append(float(campos[8]))
    afr.append(float(campos[9]))

N = 1479
x = np.asarray(g)
y = np.asarray(amr)
z = np.asarray(eas)
a = np.asarray(sas)
b = np.asarray(eur)
c = np.asarray(afr)



markers = []
for i in range(N):
    markers.append(CircleMarker(x=x[i], y=y[i], r=1.2,
                                fill=random.choice(['black', 'purple', 'grey','blue', 'green', 'blue', 'orange', 'red', 'brown'])))

s = Scatter(x, y, markers, insert=(10,10), size=(290,780))
s.drawBorder(stroke='grey', fill='white', stroke_width=0.2)
s.drawMarkers()
s.drawDotDash(['n','s','e'], dash_height=10, stroke="grey", stroke_width=0.2)


s1 = Scatter(x, z, markers, insert=(310,10), size=(290,780))
s1.drawBorder(stroke='grey', fill='white', stroke_width=0.2)
s1.drawMarkers()
s1.drawDotDash(['n','s','e'], dash_height=10, stroke="grey", stroke_width=0.2)


s2 = Scatter(x, a, markers, insert=(610,10), size=(290,780))
s2.drawBorder(stroke='grey', fill='white', stroke_width=0.2)
s2.drawMarkers()
s2.drawDotDash(['n','s','e'], dash_height=10, stroke="grey", stroke_width=0.2)


s3 = Scatter(x, b, markers, insert=(910,10), size=(290,780))
s3.drawBorder(stroke='grey', fill='white', stroke_width=0.2)
s3.drawMarkers()
s3.drawDotDash(['n','s','e'], dash_height=10, stroke="grey", stroke_width=0.2)



s4 = Scatter(x, c, markers, insert=(1210,10), size=(290,780))
s4.drawBorder(stroke='grey', fill='white', stroke_width=0.2)
s4.drawMarkers()
s4.drawDotDash(['n','s','e'], dash_height=10, stroke="grey", stroke_width=0.4)


rug = svgwrite.Drawing('prueba.svg')
rug.add(s.dwg)
rug.add(s1.dwg)
rug.add(s2.dwg)
rug.add(s3.dwg)
rug.add(s4.dwg)
rug.save()

import samples
import jinx_distances as distance

from pprint import pprint

allsamples = samples.european.keys() + samples.amerindian.keys()

rows = []
for i in allsamples:
    cols = []
    for j in allsamples:
        cols.append(str(distance.jinx.get((i,j),
                                          distance.jinx.get((j,i), 1))))
    rows.append(cols)




for row in rows:
    print ",".join(row)

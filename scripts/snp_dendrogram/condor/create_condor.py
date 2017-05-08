from experiment import samples, paths
from itertools import combinations

encabezado = """
Executable      = jaccard.py

should_transfer_files = YES
when_to_transfer_output = ON_EXIT
"""


plantilla = """
Error           = err_{s1}_{s2}
Output          = jinx_{s1}_{s2}
Log             = log_{s1}_{s2}

transfer_input_files = {s1}, {s2}
Arguments       = {s1} {s2}
Queue 

"""

pickles = ["%s.pickle" % s for s in samples.amerindian]
pickles += ["%s.pickle" % s for s in samples.asian]
pickles += ["%s.pickle" % s for s in samples.african]
pickles += ["%s.pickle" % s for s in samples.european]

print encabezado

for pair in combinations(pickles,2):
    print plantilla.format(s1=pair[0], s2=pair[1])

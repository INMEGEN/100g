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

pickles = [
    'HG00311.pickle',
    'HG00479.pickle',
    'HG02610.pickle',
    'SM-3MG3P.pickle',
    'SM-3MG3R.pickle',
    'SM-3MG3V.pickle',
    'SM-3MG45.pickle',
    'SM-3MG46.pickle',
    'SM-3MG47.pickle',
    'SM-3MG4C.pickle',
    'SM-3MG4E.pickle',
    'SM-3MG4H.pickle',
    'SM-3MG4J.pickle',
    'SM-3MG4K.pickle',
    'SM-3MG51.pickle',
    'SM-3MG52.pickle',
    'SM-3MG53.pickle',
    'SM-3MG55.pickle',
    'SM-3MG56.pickle',
    'SM-3MG5A.pickle',
    'SM-3MG5E.pickle',
    'SM-3MG5L.pickle',
    'SM-3MG5N.pickle',
    'SM-3MG5O.pickle',
    'SM-3MG5V.pickle',
    'SM-3MG5Y.pickle',
    'SM-3MG5Z.pickle',
    'SM-3MG63.pickle',
    'SM-3MG66.pickle',
    'SM-3MG67.pickle',
    'SM-3MG68.pickle',
    'SM-3MG6A.pickle',
    'SM-3MG6B.pickle',
    'SM-3MGPP.pickle',]

print encabezado
for pair in combinations(pickles,2):
    print plantilla.format(s1=pair[0], s2=pair[1])

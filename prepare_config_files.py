import json
import uuid
import functools
import operator
import numpy as np
from params import params

def fixup(adict, k, v):
    """
    Parameters
    ----------
    adict : TYPE
        Description
    k : TYPE
        Description
    v : TYPE
        Description
    
    """
    for key in adict.keys():
        if key == k:
            adict[key] = v
        elif type(adict[key]) is dict:
            fixup(adict[key], k, v)


class NumpyEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.integer):
            return int(obj)
        elif isinstance(obj, np.floating):
            return float(obj)
        elif isinstance(obj, np.bool_):
            return bool(obj)
        elif isinstance(obj, np.ndarray):
            return obj.tolist()
        else:
            return super(MyEncoder, self).default(obj)

def main():

    config_template = None
    with open("config_template.json", 'r') as f:
        config_template = json.load(f)

    n = functools.reduce(operator.mul, [len(value) for value in params.values()], 1)

    d = dict([(key, np.tile(value, (n // len(value)))) if np.ndim(value) == 1 else (key, np.tile(value, (n // len(value), 1))) for key, value in params.items()])

    for i in range(n):
        for (key, value) in d.items():
            fixup(config_template, key, value[i])
        with open(str(uuid.uuid4()) + ".json", 'w') as f:
            json.dump(config_template, f, cls=NumpyEncoder, indent = 4)

if __name__ == '__main__':
	main()

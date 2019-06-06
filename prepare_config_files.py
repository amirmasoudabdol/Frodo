#!/usr/bin/env python3

import json
import uuid
import functools
import operator
import numpy as np
from yourprojectname_params import params

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
    with open("yourprojectname_config_template.json", 'r') as f:
        config_template = json.load(f)

    n = functools.reduce(operator.mul, [len(value) for value in params.values()], 1)

    d = dict([(key, np.tile(value, (n // len(value)))) if np.ndim(value) == 1 else (key, np.tile(value, (n // len(value), 1))) for key, value in params.items()])

    configfilenames = open("configfilenames.pool", 'w')

    for i in range(n):
        for (key, value) in d.items():
            fixup(config_template, key, value[i])
        
        uid = str(uuid.uuid4())
        filename = uid + ".json" 
        configfilenames.write(filename + "\n")

        with open("configs/" + filename, 'w') as f:
            fixup(config_template, "output_prefix", uid)
            json.dump(config_template, f, cls=NumpyEncoder, indent = 4)

    configfilenames.close()

    print("Saved %s configuration files in configs/" % n)
    print("The \"params.pool\" file contains names of all configuration files.")


if __name__ == '__main__':
	main()

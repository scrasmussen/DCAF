import matplotlib.pyplot as plt
# import matplotlib.colors
# from matplotlib import rcParams
import numpy as np
import pandas as pd
import sys

def get_label(s):
    s = s[12:]
    if (s == 'ACC'):
        return 'OpenACC'
    elif (s == 'OMP'):
        return 'OpenMP'
    elif (s == 'DC'):
        return 'Do Concurrent'
    elif (s == 'DO'):
        return 'Do Loops'


dir='single_image_multigputest/'
files=['output_DCAF_ACC', 'output_DCAF_DC', 'output_DCAF_DO',
       'output_DCAF_OMP']

names = ['nx', 'ny', 't', 'loop']
df = pd.DataFrame(columns=names)

for f in files:
    file = dir + f +'.txt'
    names = ['nx', 'ny', 't']
    array = pd.read_csv(file, '\s+', header=None, names=names)
    array['loop'] = f

    df = df.append(array)

df = df.drop(['ny'],axis=1)


markers = ['v','^','<','>']
colors = ['b','g','r','k']

plt.figure()
for i,f in enumerate(files):
    data = df.loc[df['loop']==f]
    # plt.plot(data['nx'], data['t'], label=f, marker=markers[i],
    #          color=colors[i])
    label = get_label(f)

    plt.loglog(data['nx'], data['t'], label=label, marker=markers[i],
             color=colors[i])



plt.legend()
plt.show()

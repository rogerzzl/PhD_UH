# **PhD_UH**

*by Zhanliang*

## THESE CODES MAINLY USE FOR CALCULATE UNIT HYDROGRAPH

## ***Hydrographs***

From [NEH Hydrology Ch. 16, Ex. 16-1](http://www.wcc.nrcs.usda.gov/ftpref/wntsc/H&H/NEHhydrology/ch16.pdf#page=15):

## ***Unit Hydrograph***
The theory can be found in [THIS LINK](https://www.meted.ucar.edu/hydro/basic_int/unit_hydrograph/print.php#page_1-1-0)

*************************************************************************************

## **My Code**

### hydrograpg.py

This *py* code is a class, which contains methods about calculate varialbes of UH and plot the results.
Necessary packages:
```
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.pylab import rcParams
```
- Method *calc()* to calculate:

```
    def calc(self):
        #Tp represents the Tl in Chapter11, means basin lag time
#        self.tp = self.C1 * self.Ct * \
#                  ((self.L * 0.621371) * (self.Lc * 0.621371) ** 0.3)
        self.tp = self.C1 * self.Ct * \
                  ((self.L * self.Lc) ** 0.3)
        self.tr = self.tp / 5.5
        # tpr is basin lag, same as tlr in Chapter 11
#        self.tPR = self.tp + 0.25 * (self.tR - self.tr)
        self.tPR = self.tp + 0.25 * (self.tR - self.tr)
        # qpr is the peak discharge per unit of watershed area
        self.QPR = 2.75 * self.Cp * (self.A / self.tPR)
        # width of the UH at values of 50% with a 2.14 values of Cw
        self.W50 = 2.14 / ((self.QPR / self.A) ** 1.08)
        # width of the UH at values of 75% with a 1.22 values of Cw
        self.W75 = 1.22 / ((self.QPR / self.A) ** 1.08)
        # tb means the base time
        self.Tb = 11.11 * (self.A / self.QPR) - 1.5 * self.W50 - self.W75
        return dict(tp=self.tp, tr=self.tr, tPR=self.tPR, QPR=self.QPR,
                    W50=self.W50, W75=self.W75, Tb=self.Tb, tR=self.tR)
```

- Method *plot()* to plot

```
    def plot(self):
        self.calc()
        self.plot_t = np.array([0, (self.tr / 2 + self.tPR) - self.W50 / 3,
                               (self.tr / 2 + self.tPR) - self.W75 / 3,
                               self.tr / 2 + self.tPR,
                               (self.tr / 2 + self.tPR) + self.W75 / 3,
                               (self.tr / 2 + self.tPR) + self.W50 / 3,
                               self.Tb]
                               )
        self.plot_Q = np.array([0, self.QPR * 0.5, self.QPR * 0.75,
                               self.QPR, self.QPR * 0.75, self.QPR * 0.5, 0])
        fig, ax1 = plt.subplots(1, 1)
        ax1.plot(self.plot_t, self.plot_Q)
        plt.vlines(self.plot_t[3], self.plot_Q[3], 0,
                   color='DarkOrange', linestyle='dashed', lw=2)
        plt.text(self.plot_t[3], self.plot_Q[3], 'QPR')
        plt.hlines(self.plot_Q[2], self.plot_t[2], self.plot_t[4],
                   color='DarkOrange', linestyle='dashed', lw=2)
        plt.text(self.plot_t[4] + 0.3, self.plot_Q[2], 'W75')
        plt.hlines(self.plot_Q[1], self.plot_t[1], self.plot_t[5],
                   color='DarkOrange', linestyle='dashed', lw=2)
        plt.text(self.plot_t[5] + 0.3, self.plot_Q[1], 'W50')
        plt.hlines(self.QPR + 0.5, 0, self.tr,
                   color='Blue', lw=15)
        plt.hlines(self.QPR + 0.5, self.tr / 2, self.plot_t[3],
                   color='DarkOrange', linestyle='-.', lw=2.5)
        plt.text(0.5, self.QPR, 'tR  ' + str(round(self.tr, 4)) + '  hr')
        plt.text(self.Tb / 2, 0.5,
                 'Base time: ' + str(round(self.Tb, 4)) + ' hr')
        plt.hlines(0, 0, self.Tb,
                   color='DarkOrange', linestyle='dashed', lw=5)
        plt.title('Snyder Synthetic Unit Hydrograph')
        plt.xlabel('t (hr)')
        plt.ylabel('Q m3/sec')
        plt.grid()
        plt.savefig('SUH_{}_{}_tr.png'.format(self.name,self.tR),
                    bbox_inches='tight')
```

### example_UH_Mykonos.py


This is the main(), and if you want to use it, u need to input some varialbes of target catchment.
try to run it to get nice pics.
```
A = 2.7
L = 2.10
Lc = 1.37
C1 = 1
Ct = 1.9
Cp = 0.65
tR = 0.25

#Make ShyderUH
mykonosUH = SnyderUH(name, A, L, Lc, C1, Ct, Cp, tR)

# Calculate ShyderUh
print(mykonosUH.calc())

# View plot
mykonosUH.plot()

# Calculate UH & View plot for various rainfall durations
for item in [0.25,0.5,1,2,3,4]:
	UH = SnyderUH(name, A, L, Lc, C1, Ct, Cp, item)
	UH.calc()
	UH.plot()                                                              
	print("tR: {} hr, Q: {}, Tb:{} hr".format(UH.tR, UH.QPR, UH.Tb))
```
This part contains two codes, and the reference is in [Here](https://github.com/kickapoo/ISLA_Thalis_P16_KaloLivadi.git), which was originally written by Anastasiadis Stavros. Copyright (C) 2014 University of Aegean, Research Program ISLA! 

## 1.unitHydrograph.m

This .m file is a script based on Matlab for obtain Unit Hydrograph.
See the whole file and try run it.

## 2.Nakayasu_UH.m

This .m file is a script based on Matlab for obtain Unit Hydrograph using Nakayasu method.

## 3. Test.py

This .py file is a script about LSTM networks.
It mainlu uses these modules:
```
import numpy as np
import torch
from torch import nn
import matplotlib.pyplot as plt
```
Download and run it, you will get a nice train img!




## To be continue...

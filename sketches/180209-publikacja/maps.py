import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import LogNorm
from symresults import *
from itertools import product as cartproduct

#------------------------------------------------------------------------------#

from diskvert import *
from par import *

#------------------------------------------------------------------------------#

for ds in dsets:

    yy, yl, ys = meta[ds[0]]
    xx, xl, xs = meta[ds[1]]

    dset3 = read2Ddataset(lambda i,j: 'data/04-' + ix2fn(ds,(i,j)) + '.txt',
        len(yy), len(xx))

    #--------------------------------------------------------------------------#

    fig, axes = plt.subplots(2, 3, figsize = (15,8), sharex = True, sharey = True)

    for ax in axes.ravel():
        ax.set_xlabel(xl)
        ax.set_ylabel(yl)
        ax.set_xscale(xs)
        ax.set_yscale(ys)

    def overplot_contours(ax, color = 'white'):
        cs = ax.contour(xx, yy, DPA(dset3, 'taues_cor'), 11,
            linewidths = np.linspace(0.2, 1.8, 11),
            colors = color)
        ax.clabel(cs, inline = True, fontsize = 9, color = color, fmt = '%.1f')
        if ds == 'NA':
            ax.scatter(sym_alphas, sym_nus, color = color)
            for i,l in enumerate(sym_labels):
                ax.annotate(l, xy = (sym_alphas[i] + 0.01, sym_nus[i]), color = color)
        ax.set_xlim(np.min(xx), np.max(xx))
        ax.set_ylim(np.min(yy), np.max(yy))

    #--------------------------------------------------------------------------#

    ax = axes[0,0]
    ax.set_title('$T_{{\\rm avg}}$ [keV] (warm)')
    zz = DPA(dset3, 'tavg_cor_nohard')
    cs = ax.contourf(xx, yy, zz / 11.6e6, cmap = 'CMRmap', levels = np.linspace(0.1,1.3,16), extend = 'both')
    plt.colorbar(cs, ax = ax) #, ticks = [1e6, 3e6, 1e7, 3e7, 1e8])
    overplot_contours(ax, color = 'white')

    #--------------------------------------------------------------------------#

    ax = axes[1,0]
    ax.set_title('$T_{{\\rm avg}}$ [keV] (hot)')
    zz = DPA(dset3, 'tavg_hard')
    cs = ax.contourf(xx, yy, zz / 11.6e6, cmap = 'CMRmap', levels = np.linspace(1,60,16), extend = 'both') # , norm = LogNorm(), levels = np.logspace(6.6, 8.0, 17)
    plt.colorbar(cs, ax = ax) #, ticks = [1e6, 3e6, 1e7, 3e7, 1e8])
    # overplot_contours(ax, color = 'white')

    #--------------------------------------------------------------------------#

    ax = axes[0,2]
    ax.set_title('$\\chi = 1 - F_{{\\rm rad}}^{{\\rm disk}} / F_{{\\rm rad}}^{{\\rm tot}}$')
    zz = DPA(dset3, 'chi_tmin')
    cs = ax.contourf(xx, yy, zz, levels = np.linspace(0, 1, 19),
            cmap = 'Spectral_r')
    plt.colorbar(cs, ax = ax, ticks = [0, 0.25, 0.5, 0.75, 1])

    cs = ax.contour(xx, yy, DPA(dset3, 'xcor'),
        levels = np.linspace(1,3,9),
        linewidths = np.linspace(0.2, 1.8, 9),
        colors = 'black')
    ax.clabel(cs, inline = True, fontsize = 9, color = 'black', fmt = 'x = %.2f')

    #--------------------------------------------------------------------------#

    ax = axes[0,1]
    ax.set_title('$Y_{{\\rm avg}}$')
    cs = ax.contourf(xx, yy, DPA(dset3, 'compy_therm'), 13,
        cmap = 'magma', vmin = 0)
    plt.colorbar(cs, ax = ax)
    overplot_contours(ax, color = 'white')

    #--------------------------------------------------------------------------#

    ax = axes[1,2]
    ax.set_title('$\\epsilon$ and $\\tau_{{\\rm es}}$ at $\\tau* = 1$')
    kes = DPA(dset3, 'kapsct_therm')
    kabp = DPA(dset3, 'kapabp_therm')
    cs = ax.contourf(xx, yy, kabp / (kes + kabp) , 13, vmin = 0,
        cmap = 'RdYlGn')
    plt.colorbar(cs, ax = ax)
    cs = ax.contour(xx, yy, DPA(dset3, 'taues_therm'), 11,
        linewidths = np.linspace(0.2, 1.8, 11),
        colors = 'black')
    ax.clabel(cs, inline = True, fontsize = 9, color = 'black', fmt = '%.1f')

    #--------------------------------------------------------------------------#

    ax = axes[1,1]
    ax.set_title('$\\min \\left\\{ d \\ln \\Lambda \\ / \\ d \\ln T \\right\\}$')
    cm = plt.cm.get_cmap('PiYG')
    cmx = lambda lvl: [ cm(x) for x in np.linspace(0, 1, len(lvl)) ]
    cs = ax.contourf(xx, yy, DPA(dset3, 'instabil'),
        levels = [-2.0, -1.0, -0.5, -0.2, -0.1, -0.05, -0.02, -0.01, -0.005, 0, 0.0005, 0.001, 0.002, 0.005, 0.01, 0.02],
        # linewidths = [ 0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 2.0, 1.4, 1.2, 0.02 ],
        colors = [cm(x) for x in [0.0, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.47, 0.53, 0.6, 0.67, 0.8, 0.9, 0.95, 1.0]],
        extend = 'both')
    ax.contour(xx, yy, DPA(dset3, 'instabil'), levels = [0], linewidths = 0.8, colors = 'black', alpha = 0.4, linestyles = ':')
    # ax.clabel(cs, fontsize = 9)
    plt.colorbar(cs, ax = ax)
    # cs = ax.contour(xx, yy, DPA(dset3, 'taues_therm'), 11,
    #     linewidths = np.linspace(0.2, 1.8, 11),
    #     colors = 'black')
    # ax.clabel(cs, inline = True, fontsize = 9, color = 'black', fmt = '%.1f')

    #--------------------------------------------------------------------------#

    plt.tight_layout()
    plt.savefig('maps-{}.{}'.format(ds, figext))

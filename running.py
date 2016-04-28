#!/usr/bin/python3
# -*- coding: utf-8 -*-

# Copyright © 2016 Martin Ueding <dev@martin-ueding.de>

import argparse

import matplotlib.pyplot as pl
import numpy as np
import scipy.optimize as op


def main():
    options = _parse_args()

    n_g = 3
    n_h = 1

    b_3 = 11 - 4/3 * n_g
    b_2 = 22/3 - 4/3 * n_g - 1/6 * n_h
    b_1 = - 4/3 * n_g - 1/10 * n_h

    a_inv_1 = 58.98
    a_inv_2 = 29.60
    a_inv_3 = 8.47

    q = np.logspace(4, 20, 10)

    m_z = 91

    a_inv_1_q = a_inv_1 + b_1 / (2 * np.pi) * np.log(q / m_z)
    a_inv_2_q = a_inv_2 + b_2 / (2 * np.pi) * np.log(q / m_z)
    a_inv_3_q = a_inv_3 + b_3 / (2 * np.pi) * np.log(q / m_z)

    pl.plot(q, a_inv_1_q, label='U(1)')
    pl.plot(q, a_inv_2_q, label='SU(2)')
    pl.plot(q, a_inv_3_q, label='SU(3)')
    pl.xscale('log')
    pl.margins(0.05)
    pl.savefig('running.pdf')

    np.savetxt('running-1.txt', np.column_stack([q, a_inv_1_q]))
    np.savetxt('running-2.txt', np.column_stack([q, a_inv_2_q]))
    np.savetxt('running-3.txt', np.column_stack([q, a_inv_3_q]))


def _parse_args():
    '''
    Parses the command line arguments.

    :return: Namespace with arguments.
    :rtype: Namespace
    '''
    parser = argparse.ArgumentParser(description='')
    options = parser.parse_args()

    return options


if __name__ == '__main__':
    main()

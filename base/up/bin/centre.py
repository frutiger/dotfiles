#!/usr/bin/env python3

import os
import shutil
import sys

def main():
    if len(sys.argv) == 1 or sys.argv[1] == '-':
        infile = sys.stdin
    else:
        infile = open(sys.argv[1], 'r')

    lines = infile.readlines()

    columns, rows = shutil.get_terminal_size()

    if len(lines) > rows:
        raise RuntimeError('Too many lines')

    for index, line in enumerate(lines):
        if len(line) - 1 > columns:
            raise RuntimeError('Line {} is too long'.format(index))

    for i in range((rows - len(lines)) // 2):
        print()

    line_format = '{:^' + str(columns) + '}'
    for line in lines:
        print(line_format.format(line[:-1]))

    for i in range((rows - len(lines)) // 2):
        print()

if __name__ == '__main__':
    main()

# coding: utf-8

import json
import re
import urllib, urllib2
from lxml import etree
import time
import requests
import collections


# a = urllib.urlopen("https://www.qcloud.com/act/campus#discount")
# h = a.read().decode("utf-8")

# print h


# r = requests.get("http://www.1905.com/vod/play/1110697.shtml")

# h = r.content


# h = etree.HTML(h)

# print h.xpath("//*[@id='playerBoxIntroCtx']/div[2]/ul/li[2]/span/a/text()")


# post_time = localtime(mktime(strptime(post_time, "%a %b %d %H:%M:%S %Y")))
# a = strftime('%Y-%m-%d %H:%M:%S', post_time)


# import datetime

# print datetime.date.today() -  datetime.date.today()


class Solution(object):
    def solveSudoku(self, board):
        """
        :type board: List[List[str]]
        :rtype: void Do not return anything, modify board in-place instead.
        """
        
        row = []
        for i in xrange(9):
            row.append(set())
            for j in xrange(9):
                if board[i][j] == '.':
                    continue
                row[i].add(board[i][j])

        column = []
        for i in xrange(9):
            column.append(set())
            for j in xrange(9):
                if board[j][i] == '.':
                    continue
                column[i].add(board[j][i])

        area = []
        for i in xrange(9):
            area.append(set())
            for j in xrange(9):
                if board[i/3*3+j/3][i%3*3+j%3] == '.':
                    continue
                area[i].add(board[i/3*3+j/3][i%3*3+j%3])
        Solution().fun(row, column, area ,board, 0)

    def fun(self, row, column, area ,board, n):
        print n, board
        if n == 81:
            return True
        i = n / 9
        j = n % 9
        if board[i][j] != '.':
            if Solution().fun(row, column, area ,board, n+1):
                return True
            else:
                return False
        choose_num = row[i] & column[j] & area[i/3*3+j/3]
        if not choose_num:
            return False

        for num in choose_num:
            board[i][j] = num
            row[i].remove(num)
            column[j].remove(num)
            area[i/3*3+j/3].remove(num)

            if Solution().fun(row, column, area ,board, n+1):
                return True

            row[i].add(num)
            column[j].add(num)
            area[i/3*3+j/3].add(num)
            board[i][j] = '.'

a = [['.', '.', '9', '7', '4', '8', '.', '.', '.'], ['7', '.', '.', '.', '.', '.', '.', '.', '.'], ['.', '2', '.', '1', '.', '9', '.', '.', '.'], ['.', '.', '7', '.', '.', '.', '2', '4', '.'], ['.', '6', '4', '.', '1', '.', '5', '9', '.'], ['.', '9', '8', '.', '.', '.', '3', '.', '.'], ['.', '.', '.', '8', '.', '3', '.', '2', '.'], ['.', '.', '.', '.', '.', '.', '.', '.', '6'], ['.', '.', '.', '2', '7', '5', '9', '.', '.']]
Solution().solveSudoku(a)
print a

# a = ["..9748...","7........",".2.1.9...","..7...24.",".64.1.59.",".98...3..","...8.3.2.","........6","...2759.."]
# b = []
# for i in xrange(9):
#     b.append([])
#     for j in a[i]:
#         b[i].append(j)

# print b









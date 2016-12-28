# coding:utf-8
# from lxml import etree
# import re
# import requests
# import json
# url = "http://10.3.8.211/" 
# req = requests.get(url)

# html = etree.HTML(req.content)
# last_login_site = html.xpath("/html/body/center/div/form[1]/table/tr[4]/td[2]/text()")[0].split(' ')[0]

# print req.content.decode("gbk")


import math
import collections


class Solution(object):
    def longestIncreasingPath(self, matrix):
        """
        :type matrix: List[List[int]]
        :rtype: int
        """
        if not matrix:
            return 0
        r_max = 1
        for i in xrange(matrix):
            for j in xrange(matrix[0]):
                if i > 0 and matrix[i][j] >= matrix[i-1][j]:
                    continue
                if j > 0 and matrix[i][j] >= matrix[i][j-1]:
                    continue
                if i < len(matrix)-2 and matrix[i][j] >= matrix[i+1][j]:
                    continue
                if j < len(matrix[0])-2 and matrix[i][j] >= matrix[i][j+1]:
                    continue
                x1=x2=x3=x4=1
                if i > 0:
                    x1 = self.fun()
                if j > 0:
                    x1 = self.fun()
                if i < len(matrix)-2:
                    x1 = self.fun()
                if i < len(matrix[0])-2:
                    x1 = self.fun()

                r_max = max(x1,x2,x3,x4)
    def fun(self, tmp, i, j):
                if i > 0:
                    x1 = self.fun()
                if j > 0:
                    x1 = self.fun()
                if i < len(matrix)-2:
                    x1 = self.fun()
                if i < len(matrix[0])-2:
                    x1 = self.fun()


nums = [
  [9,9,4],
  [6,6,8],
  [2,1,1]
]

# print Solution().longestIncreasingPath(nums)



# Longest Increasing Path in a Matrix   
# Given an integer matrix, find the length of the longest increasing path.

# From each cell, you can either move to four directions: left, right, up or down. 
# You may NOT move diagonally or move outside of the boundary (i.e. wrap-around is not allowed).

# Example 1:

# nums = [
#   [9,9,4],
#   [6,6,8],
#   [2,1,1]
# ]
# Return 4
# The longest increasing path is [1, 2, 6, 9].

# Example 2:

# nums = [
#   [3,4,5],
#   [3,2,6],
#   [2,2,1]
# ]
# Return 4
# The longest increasing path is [3, 4, 5, 6]. Moving diagonally is not allowed.










































































































































































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
    def canCompleteCircuit(self, gas, cost):
        """
        :type gas: List[int]
        :type cost: List[int]
        :rtype: int
        """
        if sum(gas) < sum(cost):
            return -1
        tmp = 0
        i = 0
        y = 1
        while i < len(gas):
            x = max(y, 1)
            print i, x, tmp
            while x < len(gas):
                j = (i+x)%len(gas)
                tmp += gas[j]
                tmp -= cost[j]
                if tmp < 0:
                    break
                x += 1
            print tmp
            if x == len(gas):
                return i
            z = i
            while tmp < 0 and z < x+i-1:
                tmp -= gas[z]
                tmp += cost[z]
                z += 1
            print tmp
            i = z
            y = x - i
        return -1


print Solution().canCompleteCircuit([10,12,30,50],[20,30,40,12] )

# Single Number III   
# Given an array of numbers nums, in which exactly two elements appear only once and all the other elements appear exactly twice.
# Find the two elements that appear only once.

# For example:

# Given nums = [1, 2, 1, 3, 2, 5], return [3, 5].

# Note:
# The order of the result is not important. So in the above example, [5, 3] is also correct.
# Your algorithm should run in linear runtime complexity. Could you implement it using only constant space complexity?




# Gas Station   
# There are N gas stations along a circular route, where the amount of gas at station i is gas[i].

# You have a car with an unlimited gas tank and it costs cost[i] of gas to travel from station i
#  to its next station (i+1). You begin the journey with an empty tank at one of the gas stations.

# Return the starting gas station's index if you can travel around the circuit once, otherwise return -1.
























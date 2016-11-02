# coding:utf-8
# from lxml import etree
# import re
# import requests
# import json

# url = "http://ip.zxinc.org/ipquery/?ip=130.225.198.0" 
# req = requests.get(url)
# html = etree.HTML(req.content)
# last_login_site = html.xpath("/html/body/center/div/form[1]/table/tr[4]/td[2]/text()")[0].split(' ')[0]

# print last_login_site

import collections
class Solution(object):
    def letterCombinations(self, digits):
        """
        :type digits: str
        :rtype: List[str]
        """
        if digits == "":
            return []

        a = {
        '2': ['a', 'b', 'c'],
        '3': ['d','e','f'],
        '4': ['g','h','i'],
        '5': ['j','k','l'],
        '6': ['m','n','o'],
        '7': ['p','q','r','s'],
        '8': ['t','u','v'],
        '9': ['w','x','y','z']
        }

        num = -1
        while 1:
            if len(digits) == 1:
                return a[digits]

            tmp = collections.defaultdict(int)
            n_max = 0
            s_max = ""
            now = ""
            for i in xrange(1, len(digits)):
                if digits[i-1:i+1] == now:
                    now = ""
                else:
                    tmp[digits[i-1:i+1]] += 1
                    if tmp[digits[i-1:i+1]] > n_max:
                        n_max = tmp[digits[i-1:i+1]] 
                        s_max = digits[i-1:i+1]
                    now = digits[i-1:i+1]

            tmp0 = []
            for i in a[s_max[0]]:
                for j in a[s_max[1]]:
                    tmp0.append(i+j)
            a['0'] = tmp0

            digits = digits.replace(s_max, "0")






print len(Solution().letterCombinations("2323232323"))

print 3**10












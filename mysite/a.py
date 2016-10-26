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
    def countAndSay(self, n):
        """
        :type n: int
        :rtype: str
        """
        x = '1'
        for j in xrange(n):
            now = x[0]
            tmp = 1
            s = ''
            for i in xrange(1, len(x)):
                if x[i] == now:
                    tmp += 1
                else:
                    s = s + str(tmp) + now
                    now = x[i]
                    tmp = 1
            s = s + str(tmp) + now
            x = s
        return s

        
print Solution().countAndSay(5)








# coding: utf-8

from scrapy import signals
from scrapy.exceptions import NotConfigured
import re
import requests
import json

from SpiderConfig import SpiderConfig


class SpiderOpenCloseLogging(object):

    def __init__(self):
        pass

    @classmethod
    def from_crawler(cls, crawler):
        if not crawler.settings.getbool('MYEXT_ENABLED'):
            raise NotConfigured
        ext = cls()
        crawler.signals.connect(ext.spider_opened, signal=signals.spider_opened)
        crawler.signals.connect(ext.spider_closed, signal=signals.spider_closed)

        return ext

    def spider_opened(self, spider):
        print "*"*50 + "Spider Opened Extension" + "*"*50

    def spider_closed(self, spider):
        print "*"*50 + "Spider Closed Extension" + "*"*50
        if SpiderConfig.spider_type == 'userspider' or SpiderConfig.spider_type == 'userupdate':
            SpiderOpenCloseLogging.deal_login_site()

    @staticmethod
    def deal_login_site():
        # 处理taobao接口新获取的ip
        pass

    @staticmethod
    def last_login(last_login_ip):
        if re.findall(r'^10\.', last_login_ip):
            return u"北京市"

        last_login_ip = last_login_ip.replace("*", "0")
        url = "http://ip.taobao.com/service/getIpInfo.php?ip=%s" % last_login_ip
        req = requests.get(url)
        ip_content = json.loads(req.content)

        if ip_content['code'] == -1 or ip_content['code'] == 1:
            return u""
        if ip_content['data']['country'] == u'中国':
            return ip_content['data']['region']
        else:
            return ip_content['data']['country']

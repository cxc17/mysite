# coding: utf-8

from scrapy import signals
from scrapy.exceptions import NotConfigured
from lxml import etree
import re
import requests
import json

from SpiderConfig import SpiderConfig
from byrbbs.mysqlclient import get_mysql


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
        # 未分配IP
        pass

        # 使用http://ip.zxinc.org/查找剩余IP
        mh = get_mysql()
        sql = "select id, last_login_ip from user where `last_login_site`=''"
        ret_info = mh.select(sql)

        for ret in ret_info:
            last_login_ip = ret[1].replace("*", "0")
            url = "hhttp://ip.zxinc.org/ipquery/?ip=%s" % last_login_ip
            req = requests.get(url)
            html = etree.HTML(req.content)
            last_login_site = html.xpath("/html/body/center/div/form[1]/table/tr[4]/td[2]/text()")[0].split(' ')[0]

            sql = "update "



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

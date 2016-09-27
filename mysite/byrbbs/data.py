# coding: utf-8
# 整理所有数据
from byrbbs.SpiderConfig import SpiderConfig
from byrbbs.mysqlclient import get_mysql

from lxml import etree
from collections import defaultdict
import json
import requests
import re


class DealData(object):
    def __init__(self):
        SpiderConfig.initialize()

    @staticmethod
    def astro():
        sql = "select gender, astro from user"
        mh = get_mysql()
        ret_info = mh.select(sql)

        astro = {u'女生': defaultdict(int), u'男生': defaultdict(int), u'全部': defaultdict(int)}
        for ret in ret_info:
            if ret[1] == u'' or ret[1] == u'未知':
                continue

            if ret[0] == u'女生':
                astro[u'女生'][ret[1]] += 1
                astro[u'全部'][ret[1]] += 1
            elif ret[0] == u'男生':
                astro[u'男生'][ret[1]] += 1
                astro[u'全部'][ret[1]] += 1
            else:
                continue

        astro = json.dumps(astro, ensure_ascii=False)

        sql = "delete from data where `data_name`='astro'"
        mh = get_mysql()
        mh.execute(sql)

        sql = "insert into data(`data_name`, `data_value`) values ('astro', '%s')" % astro
        mh = get_mysql()
        mh.execute(sql)

    @staticmethod
    def site():
        sql = "select id, last_login_ip from user"
        mh = get_mysql()
        ret_info = mh.select(sql)

        for ret in ret_info:
            if re.findall(r'^10\.', ret[1]):
                continue

            last_login_ip = ret[1].replace("*", "0")
            url = "http://ip.zxinc.org/ipquery/?ip=%s" % last_login_ip
            req = requests.get(url)
            html = etree.HTML(req.content)
            try:
                last_login_site = html.xpath("/html/body/center/div/form[1]/table/tr[4]/td[2]/text()")[0].split(" ")[0]
            except Exception, e:
                raise e

            if re.findall(u'省', last_login_site):
                last_login_site = re.findall(u'(.+?省)', last_login_site)[0]
            elif re.findall(u'市', last_login_site):
                last_login_site = re.findall(u'(.+?市)', last_login_site)[0]
            print last_login_site

            sql = "update user set last_login_site='%s' where id='%s'" % (last_login_site, ret[0])
            mh = get_mysql()
            mh.execute(sql)

if __name__ == '__main__':
    DealData().astro()


# 10.8 无线网

# 10.110 学十创新大本营
# 10.109 新科研楼
# 10.108 新科研楼
# 10.107 明光楼

# 10.106 教九
# 10.105 主楼
# 10.103 教三
# 10.104 教四
# 10.102 教二
# 10.101 教一

# 10.201 学一
# 10.202 学二
# 10.203 学三
# 10.204 学四
# 10.205 学五
# 10.206 学六
# 10.208 学八
# 10.209 学九
# 10.210 学十
# 10.211 学十一
# 10.213 学十三
# 10.215 学二十九


# 10.30 VPN





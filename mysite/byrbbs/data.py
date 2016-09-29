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
        sql = "SELECT last_login_site, last_login_ip from `user` where last_login_site != '' and last_login_ip " \
              "not LIKE '10\.%' and last_login_site not LIKE '%市' and last_login_site not LIKE '%省' and " \
              "last_login_site not LIKE '%区' and last_login_site not in ('台湾', '香港', '澳门') GROUP BY " \
              "last_login_site, last_login_ip"
        mh = get_mysql()
        ret_info = mh.select(sql)

        for ret in ret_info:
            

        # sql = "update user set last_login_site='%s' where id='%s'" % (last_login_site, ret[0])
        # mh = get_mysql()
        # mh.execute(sql)

    @staticmethod
    def bupt_site():
        sql = "select id, last_login_ip from user"
        mh = get_mysql()
        ret_info = mh.select(sql)

        for ret in ret_info:
            if not re.findall(r'^10.\.', ret[1]):
                continue

            if re.findall(r'^10\.8\.', ret[1]):
                last_login_bupt = u"无线网"
            elif re.findall(r'^10\.101\.', ret[1]):
                last_login_bupt = u"教一"
            elif re.findall(r'^10\.102\.', ret[1]):
                last_login_bupt = u"教二"
            elif re.findall(r'^10\.103\.', ret[1]):
                last_login_bupt = u"教三"
            elif re.findall(r'^10\.104\.', ret[1]):
                last_login_bupt = u"教四"
            elif re.findall(r'^10\.105\.', ret[1]):
                last_login_bupt = u"主楼"
            elif re.findall(r'^10\.106\.', ret[1]):
                last_login_bupt = u"教九"
            elif re.findall(r'^10\.107\.', ret[1]):
                last_login_bupt = u"明光楼"
            elif re.findall(r'^10\.108\.', ret[1]):
                last_login_bupt = u"新科研楼"
            elif re.findall(r'^10\.109\.', ret[1]):
                last_login_bupt = u"新科研楼"
            elif re.findall(r'^10\.110\.', ret[1]):
                last_login_bupt = u"学十创新大本营"
            elif re.findall(r'^10\.201\.', ret[1]):
                last_login_bupt = u"学一"
            elif re.findall(r'^10\.201\.', ret[1]):
                last_login_bupt = u"无线网"
            elif re.findall(r'^10\.202\.', ret[1]):
                last_login_bupt = u"学二"
            elif re.findall(r'^10\.203\.', ret[1]):
                last_login_bupt = u"学三"
            elif re.findall(r'^10\.204\.', ret[1]):
                last_login_bupt = u"学四"
            elif re.findall(r'^10\.205\.', ret[1]):
                last_login_bupt = u"学五"
            elif re.findall(r'^10\.206\.', ret[1]):
                last_login_bupt = u"学六"
            elif re.findall(r'^10\.208\.', ret[1]):
                last_login_bupt = u"学八"
            elif re.findall(r'^10\.209\.', ret[1]):
                last_login_bupt = u"学九"
            elif re.findall(r'^10\.210\.', ret[1]):
                last_login_bupt = u"学十"
            elif re.findall(r'^10\.211\.', ret[1]):
                last_login_bupt = u"学十一"
            elif re.findall(r'^10\.213\.', ret[1]):
                last_login_bupt = u"学十三"
            elif re.findall(r'^10\.215\.', ret[1]):
                last_login_bupt = u"学二十九"
            else:
                last_login_bupt = u"未知"



if __name__ == '__main__':
    DealData().site()


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





# coding: utf-8
# 整理所有数据
from byrbbs.SpiderConfig import SpiderConfig
from byrbbs.mysqlclient import get_mysql

from collections import defaultdict
import json


class DealData(object):
    def __init__(self):
        SpiderConfig.initialize()

    @staticmethod
    # 统计星座信息
    def astro():
        mh = get_mysql()
        sql = "select gender, astro from user"
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
        mh.execute(sql)

        sql = "insert into data(`data_name`, `data_value`) values ('astro', '%s')" % astro
        mh.execute(sql)

    @staticmethod
    # 统计全国各地区用户数
    def user_number_china():
        mh = get_mysql()
        sql = "select gender, province from user where province!=''"
        ret_info = mh.select(sql)

        china = defaultdict(int)
        for ret in ret_info:
            china[ret[0]] += 1

        china = {u'女生': defaultdict(int), u'男生': defaultdict(int), u'全部': defaultdict(int)}
        for ret in ret_info:
            if ret[0] == u'女生':
                china[u'女生'][ret[1]] += 1
                china[u'全部'][ret[1]] += 1
            elif ret[0] == u'男生':
                china[u'男生'][ret[1]] += 1
                china[u'全部'][ret[1]] += 1
            else:
                china[u'全部'][ret[1]] += 1

        china = json.dumps(china, ensure_ascii=False)

        sql = "delete from data where `data_name`='china'"
        mh.execute(sql)

        sql = "insert into data(`data_name`, `data_value`) values ('china', '%s')" % china
        mh.execute(sql)

    @staticmethod
    # 统计全世界各地区用户数
    def user_number_world():
        mh = get_mysql()
        sql = "select gender, country_en from user where country_en!=''"
        ret_info = mh.select(sql)

        world = defaultdict(int)
        for ret in ret_info:
            world[ret[0]] += 1

        world = {u'女生': defaultdict(int), u'男生': defaultdict(int), u'全部': defaultdict(int)}
        for ret in ret_info:
            if ret[0] == u'女生':
                world[u'女生'][ret[1]] += 1
                world[u'全部'][ret[1]] += 1
            elif ret[0] == u'男生':
                world[u'男生'][ret[1]] += 1
                world[u'全部'][ret[1]] += 1
            else:
                world[u'全部'][ret[1]] += 1

        world = json.dumps(world, ensure_ascii=False)

        sql = "delete from data where `data_name`='world'"
        mh.execute(sql)

        sql = "insert into data(`data_name`, `data_value`) values ('world', '%s')" % world
        mh.execute(sql)

if __name__ == '__main__':
    DealData().user_number_world()


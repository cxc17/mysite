# coding: utf-8
# 整理所有数据
from byrbbs.SpiderConfig import SpiderConfig
from byrbbs.mysqlclient import get_mysql

from collections import defaultdict
import json
import re


class DealData(object):
    def __init__(self):
        SpiderConfig.initialize()

    @staticmethod
    # 统计星座信息
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
    # 统计ip地址
    def site():
        mh = get_mysql()
        sql = "SELECT last_login_site, last_login_ip from `user` where last_login_site != '' and last_login_ip " \
              "not LIKE '10\.%' and last_login_site not LIKE '%市' and last_login_site not LIKE '%省' and " \
              "last_login_site not LIKE '%区' and last_login_site not in ('台湾', '香港', '澳门') GROUP BY " \
              "last_login_site, last_login_ip"
        ret_info = mh.select(sql)

        country_map = {u"阿曼": "Oman", u"韩国": "South Korea", u"斯洛文尼亚": "Slovenia", u"埃及": "Egypt", u"埃塞俄比亚": "Ethiopia", u"科威特": "Kuwait", u"马来西亚": "Malaysia", u"秘鲁": "Peru", u"伊拉克": "Iraq", u"以色列": "Israel", u"匈牙利": "Hungary", u"苏丹": "Sudan", u"南非": "South Africa", u"德国": "Germany", u"葡萄牙": "Portugal", u"格鲁吉亚": "Georgia", u"利比里亚": "Liberia", u"巴西": "Brazil", u"哥伦比亚": "Colombia", u"澳大利亚": "Australia", u"老挝": "Laos", u"西班牙": "Spain", u"白俄罗斯": "Belarus", u"阿尔巴尼亚": "Albania", u"卡塔尔": "Qatar", u"厄瓜多尔": "Ecuador", u"泰国": "Thailand", u"阿拉伯联合酋长国": "United Arab Emirates", u"墨西哥": "Mexico", u"多米尼加共和国": "Dominican Republic", u"巴基斯坦": "Pakistan", u"塞拉利昂": "Sierra Leone", u"朝鲜": "North Korea", u"阿根廷": "Argentina", u"加拿大": "Canada", u"沙特阿拉伯": "Saudi Arabia", u"俄罗斯": "Russia", u"乌克兰": "Ukraine", u"法国": "France", u"日本": "Japan", u"危地马拉": "Guatemala", u"坦桑尼亚": "United Republic of Tanzania", u"比利时": "Belgium", u"越南": "Vietnam", u"丹麦": "Denmark", u"尼日利亚": "Nigeria", u"纳米比亚": "Namibia", u"委内瑞拉": "Venezuela", u"波兰": "Poland", u"美国": "United States of America", u"乌兹别克斯坦": "Uzbekistan", u"荷兰": "Netherlands", u"哈萨克斯坦": "Kazakhstan", u"孟加拉国": "Bangladesh", u"立陶宛": "Lithuania", u"瑞典": "Sweden", u"意大利": "Italy", u"希腊": "Greece", u"爱尔兰": "Ireland", u"斯里兰卡": "Sri Lanka", u"菲律宾": "Philippines", u"英国": "United Kingdom", u"牙买加": "Jamaica", u"印度尼西亚": "Indonesia", u"阿尔及利亚": "Algeria", u"瑞士": "Switzerland", u"印度": "India", u"缅甸": "Myanmar", u"芬兰": "Finland", u"奥地利": "Austria", u"贝宁": "Benin", u"挪威": "Norway", u"新西兰": "New Zealand", u"土耳其": "Turkey"}
        for ret in ret_info:
            try:
                country_en = country_map[ret[0]]
            except:
                print ret[0]
            sql = "insert into site(`country_cn`, `country_en`, `province`, `ip`) value ('%s', '%s', '', '%s')" \
                  % (ret[0], country_en, ret[1])
            mh.execute(sql)

        sql = "SELECT last_login_site, last_login_ip from `user` where last_login_site != '' and last_login_ip " \
              "not LIKE '10\.%' and ( last_login_site LIKE '%市' or last_login_site LIKE '%省' or " \
              "last_login_site LIKE '%区' or last_login_site in ('台湾', '香港', '澳门') ) GROUP BY " \
              "last_login_site, last_login_ip"
        ret_info = mh.select(sql)

        for ret in ret_info:
            sql = "insert into site(`country_cn`, `country_en`, `province`, `ip`) value ('%s', 'China', '%s', '%s')" \
                  % (u'中国', ret[0], ret[1])
            mh.execute(sql)

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



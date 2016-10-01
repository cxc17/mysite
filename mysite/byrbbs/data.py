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
    # 统计ip地址
    def site():
        mh = get_mysql()
        sql = "SELECT last_login_site, last_login_ip from `user` where last_login_site != '' and country_cn = '' " \
              "and last_login_ip not LIKE '10\.%' and last_login_site not LIKE '%市' and last_login_site not " \
              "LIKE '%省' and last_login_site not LIKE '%区' and last_login_site not in ('台湾', '香港', '澳门') " \
              "GROUP BY last_login_site, last_login_ip"
        ret_info = mh.select(sql)

        country_map = {u'柬埔寨': 'Cambodia', u'卢森堡': 'Luxembourg', u'伊朗': 'Iran', u"阿曼": "Oman", u"韩国": "South Korea", u"斯洛文尼亚": "Slovenia", u"埃及": "Egypt", u"埃塞俄比亚": "Ethiopia", u"科威特": "Kuwait", u"马来西亚": "Malaysia", u"秘鲁": "Peru", u"伊拉克": "Iraq", u"以色列": "Israel", u"匈牙利": "Hungary", u"苏丹": "Sudan", u"南非": "South Africa", u"德国": "Germany", u"葡萄牙": "Portugal", u"格鲁吉亚": "Georgia", u"利比里亚": "Liberia", u"巴西": "Brazil", u"哥伦比亚": "Colombia", u"澳大利亚": "Australia", u"老挝": "Laos", u"西班牙": "Spain", u"白俄罗斯": "Belarus", u"阿尔巴尼亚": "Albania", u"卡塔尔": "Qatar", u"厄瓜多尔": "Ecuador", u"泰国": "Thailand", u"阿拉伯联合酋长国": "United Arab Emirates", u"墨西哥": "Mexico", u"多米尼加共和国": "Dominican Republic", u"巴基斯坦": "Pakistan", u"塞拉利昂": "Sierra Leone", u"朝鲜": "North Korea", u"阿根廷": "Argentina", u"加拿大": "Canada", u"沙特阿拉伯": "Saudi Arabia", u"俄罗斯": "Russia", u"乌克兰": "Ukraine", u"法国": "France", u"日本": "Japan", u"危地马拉": "Guatemala", u"坦桑尼亚": "United Republic of Tanzania", u"比利时": "Belgium", u"越南": "Vietnam", u"丹麦": "Denmark", u"尼日利亚": "Nigeria", u"纳米比亚": "Namibia", u"委内瑞拉": "Venezuela", u"波兰": "Poland", u"美国": "United States of America", u"乌兹别克斯坦": "Uzbekistan", u"荷兰": "Netherlands", u"哈萨克斯坦": "Kazakhstan", u"孟加拉国": "Bangladesh", u"立陶宛": "Lithuania", u"瑞典": "Sweden", u"意大利": "Italy", u"希腊": "Greece", u"爱尔兰": "Ireland", u"斯里兰卡": "Sri Lanka", u"菲律宾": "Philippines", u"英国": "United Kingdom", u"牙买加": "Jamaica", u"印度尼西亚": "Indonesia", u"阿尔及利亚": "Algeria", u"瑞士": "Switzerland", u"印度": "India", u"缅甸": "Myanmar", u"芬兰": "Finland", u"奥地利": "Austria", u"贝宁": "Benin", u"挪威": "Norway", u"新西兰": "New Zealand", u"土耳其": "Turkey"}
        for ret in ret_info:
            try:
                country_en = country_map[ret[0]]
            except:
                print ret[0]
                continue
            sql = "insert into site(`site`, `country_cn`, `country_en`, `province`, `ip`) value " \
                  "('%s', '%s', '%s', '', '%s')" % (ret[0], ret[0], country_en, ret[1])
            mh.execute(sql)

        sql = "SELECT last_login_site, last_login_ip from `user` where last_login_site != '' and country_cn = '' " \
              "and last_login_ip not LIKE '10\.%' and ( last_login_site LIKE '%市' or last_login_site LIKE '%省' or " \
              "last_login_site LIKE '%区' or last_login_site in ('台湾', '香港', '澳门') ) GROUP BY " \
              "last_login_site, last_login_ip"
        ret_info = mh.select(sql)

        for ret in ret_info:
            province = ret[0].strip(u'市').strip(u'省').strip(u'自治区').strip(u'维吾尔自治区').strip(u'壮族自治区').strip(u'回族自治区')
            sql = "insert into site(`site`, `country_cn`, `country_en`, `province`, `ip`) value ('%s', '%s', 'China'," \
                  " '%s', '%s')" % (ret[0], u'中国', province, ret[1])
            mh.execute(sql)


if __name__ == '__main__':
    DealData().site()



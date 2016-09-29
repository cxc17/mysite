# coding: utf-8

import json
import re
import urllib
from lxml import etree
import time
# a = urllib.urlopen("http://www.tudou.com/albumcover/QlCt_c-YqvQ.html")
# h = a.read().decode("gbk")

# # print h
# # print re.findall(r'aid: \'(\d*)\'', h)


# h = etree.HTML(h)

# print h.xpath("//*[@id='gContainer']/div[2]/div[1]/div/div[3]/div[2]/div[4]/span[1]/text()")


# post_time = localtime(mktime(strptime(post_time, "%a %b %d %H:%M:%S %Y")))
# a = strftime('%Y-%m-%d %H:%M:%S', post_time)

import requests, urllib

a = {u"美国": "United States of America", u"日本": "Janan", u"法国": "France", u"加拿大": "Canada", u"新加坡": "", u"瑞士": "", u"英国": "", u"新西兰": "", u"印度": "", u"多米尼加共和国": "", u"德国": "", u"澳大利亚": "", u"卡塔尔": "", u"尼日利亚": "", u"奥地利": "", u"比利时": "", u"马来西亚": "", u"西班牙": "", u"泰国": "", u"越南": "", u"荷兰": "", u"芬兰": "", u"巴林": "", u"丹麦": "", u"瑞典": "", u"危地马拉": "", u"韩国": "", u"阿尔及利亚": "", u"纳米比亚": "", u"爱尔兰": "", u"埃及": "", u"乌克兰": "", u"阿根廷": "", u"毛里求斯": "", u"沙特阿拉伯": "", u"缅甸": "", u"立陶宛": "", u"阿曼": "", u"巴西": "", u"俄罗斯": "", u"意大利": "", u"以色列": "", u"孟加拉国": "", u"墨西哥": "", u"挪威": "", u"南非": "", u"坦桑尼亚": "", u"菲律宾": "", u"伊拉克": "", u"阿拉伯联合酋长国": "", u"土耳其": "", u"波兰": "", u"乌兹别克斯坦": "", u"巴基斯坦": "", u"葡萄牙": "", u"利比里亚": "", u"印度尼西亚": "", u"科威特": "", u"老挝": "", u"朝鲜": "", u"塞拉利昂": "", u"汤加": "", u"希腊": "", u"斯里兰卡": "", u"委内瑞拉": "", u"白俄罗斯": "", u"哥伦比亚": "", u"贝宁": "", u"厄瓜多尔": "", u"苏丹": "", u"斯洛文尼亚": "", u"埃塞俄比亚": "", u"牙买加": "", u"哈萨克斯坦": "", u"格鲁吉亚": "", u"阿尔巴尼亚": "", u"科特迪瓦": "", u"秘鲁": "", u"匈牙利": ""}


b = {
'Afghanistan':u'阿富汗',
'Angola':u'安哥拉',
'Albania':u'阿尔巴尼亚',
'United Arab Emirates':u'阿拉伯联合酋长国',
'Argentina':u'阿根廷',
'Armenia':u'亚美尼亚',
'French Southern and Antarctic Lands':u'法属南半球和南极领地',
'Australia':u'澳大利亚',
'Austria':u'奥地利',
'Azerbaijan':u'阿塞拜疆',
'Burundi':u'布隆迪',
'Belgium':u'比利时',
'Benin':u'贝宁',
'Burkina Faso':u'布基纳法索',
'Bangladesh':u'孟加拉国',
'Bulgaria':u'保加利亚',
'The Bahamas':u'巴哈马',
'Bosnia and Herzegovina':u'波斯尼亚和黑塞哥维那',
'Belarus':u'白俄罗斯',
'Belize':u'伯利兹',
'Bermuda':u'百慕大',
'Bolivia':u'玻利维亚',
'Brazil':u'巴西',
'Brunei':u'文莱',
'Bhutan':u'不丹',
'Botswana':u'博茨瓦纳',
'Central African Republic':u'中非共和国',
'Canada':u'加拿大',
'Switzerland':u'瑞士',
'Chile':u'智利',
'China':u'中国',
'Ivory Coast':u'象牙海岸',
'Cameroon':u'喀麦隆',
'Democratic Republic of the Congo':u'刚果民主共和国',
'Republic of the Congo':u'刚果共和国',
'Colombia':u'哥伦比亚',
'Costa Rica':u'哥斯达黎加',
'Cuba':u'古巴',
'Northern Cyprus':u'北塞浦路斯',
'Cyprus':u'塞浦路斯',
'Czech Republic':u'捷克共和国',
'Germany':u'德国',
'Djibouti':u'吉布提',
'Denmark':u'丹麦',
'Dominican Republic':u'多米尼加共和国',
'Algeria':u'阿尔及利亚',
'Ecuador':u'厄瓜多尔',
'Egypt':u'埃及',
'Eritrea':u'厄立特里亚',
'Spain':u'西班牙',
'Estonia':u'爱沙尼亚',
'Ethiopia':u'埃塞俄比亚',
'Finland':u'芬兰',
'Fiji':u'斐济',
'Falkland Islands':u'福克兰群岛',
'France':u'法国',
'Gabon':u'加蓬',
'United Kingdom':u'英国',
'Georgia':u'格鲁吉亚',
'Ghana':u'加纳',
'Guinea':u'几内亚',
'Gambia':u'冈比亚',
'Guinea Bissau':u'几内亚比绍',
'Equatorial Guinea':u'赤道几内亚',
'Greece':u'希腊',
'Greenland':u'格陵兰',
'Guatemala':u'危地马拉',
'French Guiana':u'法属圭亚那',
'Guyana':u'圭亚那',
'Honduras':u'洪都拉斯',
'Croatia':u'克罗地亚',
'Haiti':u'海地',
'Hungary':u'匈牙利',
'Indonesia':u'印度尼西亚',
'India':u'印度',
'Ireland':u'爱尔兰',
'Iran':u'伊朗',
'Iraq':u'伊拉克',
'Iceland':u'冰岛',
'Israel':u'以色列',
'Italy':u'意大利',
'Jamaica':u'牙买加',
'Jordan':u'约旦',
'Japan':u'日本',
'Kazakhstan':u'哈萨克斯坦',
'Kenya':u'肯尼亚',
'Kyrgyzstan':u'吉尔吉斯斯坦',
'Cambodia':u'柬埔寨',
'South Korea':u'韩国',
'Kosovo':u'科索沃',
'Kuwait':u'科威特',
'Laos':u'老挝',
'Lebanon':u'黎巴嫩',
'Liberia':u'利比里亚',
'Libya':u'利比亚',
'Sri Lanka':u'斯里兰卡',
'Lesotho':u'莱索托',
'Lithuania':u'立陶宛',
'Luxembourg':u'卢森堡',
'Latvia':u'拉脱维亚',
'Morocco':u'摩洛哥',
'Moldova':u'摩尔多瓦',
'Madagascar':u'马达加斯加',
'Mexico':u'墨西哥',
'Macedonia':u'马其顿',
'Mali':u'马里',
'Myanmar':u'缅甸',
'Montenegro':u'黑山',
'Mongolia':u'蒙古',
'Mozambique':u'莫桑比克',
'Mauritania':u'毛里塔尼亚',
'Malawi':u'马拉维',
'Malaysia':u'马来西亚',
'Namibia':u'纳米比亚',
'New Caledonia':u'新喀里多尼亚',
'Niger':u'尼日尔',
'Nigeria':u'尼日利亚',
'Nicaragua':u'尼加拉瓜',
'Netherlands':u'荷兰',
'Norway':u'挪威',
'Nepal':u'尼泊尔',
'New Zealand':u'新西兰',
'Oman':u'阿曼',
'Pakistan':u'巴基斯坦',
'Panama':u'巴拿马',
'Peru':u'秘鲁',
'Philippines':u'菲律宾',
'Papua New Guinea':u'巴布亚新几内亚',
'Poland':u'波兰',
'Puerto Rico':u'波多黎各',
'North Korea':u'朝鲜',
'Portugal':u'葡萄牙',
'Paraguay':u'巴拉圭',
'Qatar':u'卡塔尔',
'Romania':u'罗马尼亚',
'Russia':u'俄罗斯',
'Rwanda':u'卢旺达',
'Western Sahara':u'西撒哈拉',
'Saudi Arabia':u'沙特阿拉伯',
'Sudan':u'苏丹',
'South Sudan':u'南苏丹',
'Senegal':u'塞内加尔',
'Solomon Islands':u'所罗门群岛',
'Sierra Leone':u'塞拉利昂',
'El Salvador':u'萨尔瓦多',
'Somaliland':u'索马里兰',
'Somalia':u'索马里',
'Republic of Serbia':u'塞尔维亚共和国',
'Suriname':u'苏里南',
'Slovakia':u'斯洛伐克',
'Slovenia':u'斯洛文尼亚',
'Sweden':u'瑞典',
'Swaziland':u'斯威士兰',
'Syria':u'叙利亚',
'Chad':u'乍得',
'Togo':u'多哥',
'Thailand':u'泰国',
'Tajikistan':u'塔吉克斯坦',
'Turkmenistan':u'土库曼斯坦',
'East Timor':u'东帝汶',
'Trinidad and Tobago':u'特里尼达和多巴哥',
'Tunisia':u'突尼斯',
'Turkey':u'土耳其',
'United Republic of Tanzania':u'坦桑尼亚',
'Uganda':u'乌干达',
'Ukraine':u'乌克兰',
'Uruguay':u'乌拉圭',
'United States of America':u'美国',
'Uzbekistan':u'乌兹别克斯坦',
'Venezuela':u'委内瑞拉',
'Vietnam':u'越南',
'Vanuatu':u'瓦努阿图',
'West Bank':u'西岸',
'Yemen':u'也门',
'South Africa':u'南非',
'Zambia':u'赞比亚',
'Zimbabwe':u'津巴布韦'}



for k, v in b.items():
	if v in a.keys():
		a[v] = k

for k, v in a.items():
	if not v:
		print k, v














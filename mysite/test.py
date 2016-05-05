# coding:utf-8

import re
import xlwt
import math
import datetime
import requests
import pytesseract
from PIL import Image
from lxml import etree


user_agents = [
            "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/22.0.1207.1 Safari/537.1"
            "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1092.0 Safari/536.6",
            "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1090.0 Safari/536.6",
            "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/19.77.34.5 Safari/537.1",
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.9 Safari/536.5",
            "Mozilla/5.0 (Windows NT 6.0) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.36 Safari/536.5",
            "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1063.0 Safari/536.3",
            "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1063.0 Safari/536.3",
            "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1062.0 Safari/536.3",
            "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1062.0 Safari/536.3",
            "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.1 Safari/536.3",
            "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.1 Safari/536.3",
            "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.1 Safari/536.3",
            "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.0 Safari/536.3",
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.24 (KHTML, like Gecko) Chrome/19.0.1055.1 Safari/535.24",
            "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/535.24 (KHTML, like Gecko) Chrome/19.0.1055.1 Safari/535.24",
            "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1667.0 Safari/537.36"
            'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36',
            'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5',
            'Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5',
            'Mozilla/5.0 (iPad; U; CPU OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5',
            'MQQBrowser/26 Mozilla/5.0 (Linux; U; Android 2.3.7; zh-cn; MB200 Build/GRJ22; CyanogenMod-7) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1',
            'Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20100101 Firefox/5.0',
            'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.2; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET4.0E; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET4.0C)',
            'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.2; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET4.0E; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET4.0C)',
            'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)',
            'Opera/9.80 (Windows NT 5.1; U; zh-cn) Presto/2.9.168 Version/11.50',
            'Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1',
            'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727; TheWorld)',
            'Mozilla/5.0 (Linux; U; Android 2.3.3; zh-cn; HTC_DesireS_S510e Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1',
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.835.202 Safari/535.1',
            'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6'
            ]

form_data = {
    'account': 'gaa002',
    'password': '123456',
    'verify': '',
    'ajax': '1',
    'button': '',
    '__hash__': ''
}


# form_data2 = {
#     'Urlsz': '5',
#     'oldpassword': '123456',
#     'submit': '確 認',
#     '__hash__': '99b2f2dae6d9cc5e2db826bdfb06a664_fd47e4f467b08550e178cab203ddade0'
# }

headers = {'User-Agent': ''}
pid = 1


def login():
    url = 'http://vip.jryzjt88888.com/index.php?s=/Public/login/'
    login_url = 'http://vip.jryzjt88888.com/index.php?s=/Public/checkLogin/'
    headers['User-Agent'] = user_agents[pid % 31]

    # url = raw_input("请输入网址：")
    try:
        prex_url = re.findall(r'(http://.+?\..+?\..+?)/', url)[0]
    except:
        print "***********************************ERROR**********************************"
        print "请输出正确格式的网址，如http://vip.jryzjt88888.com/index.php?s=/Public/login/"
        print "***********************************ERROR**********************************"
        return

    # password = raw_input("请输入一级密码：")
    # password2 = raw_input("请输入二级密码：")
    flag = raw_input("请选择输出格式（0：完整数据；1：部分数据）：")

    session = requests.session()


    login_two(session, headers, flag)

    return


    s = session.get(url, headers=headers)
    html = s.content
    page = etree.HTML(html)

    # 获取form_data['__hash__']值
    hash = page.xpath('//*[@id="form1"]/input/@value')[0]
    form_data['__hash__'] = hash

    # 获取验证码地址
    xpath_url = '//*[@id="verifyImg"]/@src'
    picture_url = prex_url + page.xpath(xpath_url)[0]


    print picture_url, hash
    return

    # 下载验证码
    outfile = open('code.png', 'w')
    outfile.write(session.get(picture_url, headers=headers).content)
    outfile.close()

    # 分析验证码
    # image = Image.open('code.png')
    # vcode = pytesseract.image_to_string(image)
    # vcode.replace('o', '0')
    # try:
    #     verify = re.findall(r'\d\d\d\d', vcode)[0]
    # except Exception, e:
    #     verify = ''

    verify = raw_input("input verify:")

    form_data['verify'] = verify

    # 登录
    r = session.post(login_url, data=form_data, headers=headers)

    if re.findall(r'\\u9a57\\u8b49\\u78bc\\u932f\\u8aa4\\uff01', r.content):
        print 'error'
    else:
        print 'ok'
        writedata(session, headers)
        login_two(session, headers, flag)


# 写入需求2中的数据
def writedata(session, headers):

    data_url = 'http://vip.jryzjt88888.com/index.php?s=/Public/main'

    s = session.get(data_url, headers=headers)
    html = s.content
    page = etree.HTML(html)

    xpath_data = '/html/body/table/tbody/tr[2]/td[2]/table/tbody/tr[3]/td/table/tbody/tr/td[2]/table/tbody/tr[%s]/td[2]/text()'

    user_id = page.xpath(xpath_data % '3')[0]
    total_prize = page.xpath(xpath_data % '4')[0]
    cash_currency = page.xpath(xpath_data % '5')[0]
    regis_currency = page.xpath(xpath_data % '6')[0]
    declar_currency = page.xpath(xpath_data % '7')[0]
    shop_currency = page.xpath(xpath_data % '8')[0]

    book = xlwt.Workbook(encoding='utf-8', style_compression=0)
    sheet = book.add_sheet('sheet', cell_overwrite_ok=True)

    sheet.write(0, 0, '会员编号')
    sheet.write(0, 1, '总奖金')
    sheet.write(0, 2, '现金币')
    sheet.write(0, 3, '注册币')
    sheet.write(0, 4, '报单币')
    sheet.write(0, 5, '购物币')

    sheet.write(1, 0, user_id)
    sheet.write(1, 1, total_prize)
    sheet.write(1, 2, cash_currency)
    sheet.write(1, 3, regis_currency)
    sheet.write(1, 4, declar_currency)
    sheet.write(1, 5, shop_currency)

    now = datetime.datetime.now()
    filename = now.strftime("%Y-%m-%d-%H-%M-%S")
    book.save('./%s.xls' % filename)


def login_two(session, headers, flag):
    data_url = 'http://vip.jryzjt88888.com/index.php?s=/Tree/Tree2/ID/6037/uLev/3'

    # cookie
    cookies = {}
    cookies["PHPSESSID"] = "9dfe7400fdb4c3816cf9f773f68a3368"

    # s = session.get(data_url, headers=headers)#, cookies=cookies)
    s = requests.get(data_url, cookies=cookies)
    html = s.content
    page = etree.HTML(html)

    now = datetime.datetime.now()
    filename = 'gaa002-' + now.strftime("%Y-%m-%d-%H-%M-%S")
    new_file = open('%s.txt' % filename, 'w')

    if flag == '0':
        for i in xrange(1, 11):
            xpath_test = '/html/body/table/tbody/tr[2]/td[2]/table/tr[1]/td/table[%s]/tr[1]/td[1]/table/tr[1]/td/a/text()' % i
            data = page.xpath(xpath_test)[0]
            if data == u'\u9ede\u64ca\u8a3b\u518a':
                print '+++++++++++++++++'
                break

            for j in xrange(1, int(math.pow(2, i-1)+1)):
                xpath_title = '/html/body/table/tbody/tr[2]/td[2]/table/tr[1]/td/table[%s]/tr[1]/td[%s]/table/tr[1]/td/a/text()' % (i, j)
                xpath_title1 = '/html/body/table/tbody/tr[2]/td[2]/table/tr[1]/td/table[%s]/tr[1]/td[%s]/table/tr[2]/td[1]/text()' % (i, j)
                xpath_title2 = '/html/body/table/tbody/tr[2]/td[2]/table/tr[1]/td/table[%s]/tr[1]/td[%s]/table/tr[2]/td[3]/text()' % (i, j)
                xpath_title3 = '/html/body/table/tbody/tr[2]/td[2]/table/tr[1]/td/table[%s]/tr[1]/td[%s]/table/tr[3]/td[1]/text()' % (i, j)
                xpath_title4 = '/html/body/table/tbody/tr[2]/td[2]/table/tr[1]/td/table[%s]/tr[1]/td[%s]/table/tr[3]/td[3]/text()' % (i, j)

                ID = page.xpath(xpath_title)[0]
                LS = page.xpath(xpath_title1)[0]
                RS = page.xpath(xpath_title2)[0]
                L = page.xpath(xpath_title3)[0]
                R = page.xpath(xpath_title4)[0]

                data = '[ROW:%s, LINE:%s, ID：%s，LS：%s，RS：%s，L：%s，R：%s]' % (i, j, ID, LS, RS, L, R)

                new_file.write(data)
                new_file.write("\r\n")
    elif flag == '1':
        for i in xrange(1, 11):
            xpath_test = '/html/body/table/tbody/tr[2]/td[2]/table/tr[1]/td/table[%s]/tr[1]/td[1]/table/tr[1]/td/a/text()' % i
            data = page.xpath(xpath_test)[0]
            if data == u'\u9ede\u64ca\u8a3b\u518a':
                print '+++++++++++++++++'
                break

            for j in xrange(1, int(math.pow(2, i-1)+1)):
                xpath_title = '/html/body/table/tbody/tr[2]/td[2]/table/tr[1]/td/table[%s]/tr[1]/td[%s]/table/tr[1]/td/a/text()' % (i, j)

                ID = page.xpath(xpath_title)[0]

                data = '[ROW:%s, LINE:%s, ID：%s]' % (i, j, ID)

                new_file.write(data)
                new_file.write("\r\n")



if __name__ == '__main__':
    login()
    # print u'\u767b\u9304\u6210\u529f\uff01'











# coding: utf-8

from scrapy import Spider
from scrapy import FormRequest
from scrapy import Request
from time import strftime, localtime
import json

from byrbbs.items import userItem
from byrbbs.mysqlclient import get_mysql
from byrbbs.SpiderConfig import SpiderConfig


class UserSpider(Spider):
    name = "userspider"
    allowed_domains = ["bbs.byr.cn"]
    start_urls = (
        'https://bbs.byr.cn/user/ajax_login.json',
    )

    def __init__(self):
        SpiderConfig.initialize()

    # 登录byr论坛
    def start_requests(self):
        return [FormRequest('https://bbs.byr.cn/user/ajax_login.json',
                            meta={'cookiejar': 1},
                            formdata={'id': SpiderConfig.account_id, 'passwd': SpiderConfig.account_passwd},
                            callback=self.logged_in,
                            headers={'X-Requested-With': 'XMLHttpRequest'})]

    # 遍历所有的版块
    def logged_in(self, response):
        login_info = json.loads(response.body.decode('gbk'))

        if login_info['ajax_msg'] != u'操作成功':
            print 'ERROR!!!'
            return

        # 从数据库中找出每个版块的名称
        sql = "select user_id from user_id"
        mh = get_mysql()
        ret_sql = mh.select(sql)

        for ret in ret_sql:
            user_id = ret[0]
            # user_id = "oneseven"
            user_url = 'https://bbs.byr.cn/user/query/%s.json' % user_id
            yield Request(user_url,
                          meta={'cookiejar': response.meta['cookiejar']},
                          headers={'X-Requested-With': 'XMLHttpRequest'},
                          callback=self.user_info)

    def user_info(self, response):
        try:
            user_info = json.loads(response.body.decode('gbk'))
        except:
            return

        if user_info['ajax_msg'] != u"操作成功":
            return
        else:
            item = userItem()

        item['type'] = "user"
        item['user_id'] = user_info['id']
        item['user_name'] = user_info['user_name']

        if user_info['gender'] == u'f':
            item['gender'] = u"女生"
        elif user_info['gender'] == u'm':
            item['gender'] = u"男生"
        else:
            item['gender'] = u"保密"

        item['astro'] = user_info['astro']
        item['qq'] = user_info['qq']
        item['msn'] = user_info['msn']

        item['home_page'] = user_info['home_page']
        item['level'] = user_info['level']
        item['post_count'] = user_info['post_count']
        item['score'] = user_info['score']

        item['life'] = user_info['life']
        try:
            item['last_login_time'] = strftime('%Y/%m/%d %H:%M:%S', localtime(float(user_info['last_login_time'])))
        except:
            item['last_login_time'] = ""

        item['last_login_ip'] = user_info['last_login_ip']
        item['face_url'] = user_info['face_url']
        item['face_height'] = user_info['face_height']
        item['face_width'] = user_info['face_width']

        item['status'] = user_info['status']
        try:
            item['status'] = item['status'].replace("\n", "")
            item['status'] = item['status'].replace("<span class='blue'>", "")
            item['status'] = item['status'].replace("</span>", "")
        except:
            item['status'] = u"目前不在站上"

        return item

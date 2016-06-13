# -*- coding: utf-8 -*-
from scrapy import Spider
from scrapy import FormRequest
from scrapy import Request
from scrapy.selector import Selector
import json
import MySQLdb


class AllSpider(Spider):
    name = "allspider"
    allowed_domains = ["bbs.byr.cn"]
    start_urls = (
        'https://bbs.byr.cn/user/ajax_login.json',
    )

    def start_requests(self):
        return [Request('https://bbs.byr.cn/user/ajax_login.json', meta={'cookiejar': 1}, callback=self.post_login,
                        headers={'X-Requested-With': 'XMLHttpRequest'})]

    def post_login(self, response):
        print response.body
        return [FormRequest('https://bbs.byr.cn/user/ajax_login.json',
                            meta={'cookiejar': response.meta['cookiejar']},
                            formdata={'id': 'oneseven', 'passwd': '349458cddCXC'},
                            callback=self.logged_in,
                            headers={'X-Requested-With': 'XMLHttpRequest'})]

    def logged_in(self, response):
        login_info = json.loads(response.body.decode('gbk'))

        if login_info['ajax_msg'] != u'操作成功':
            print 'ERROR!!!'
            return
        print '+++++++++++++'
        conn = MySQLdb.connect(host="192.168.1.28", user="root", passwd="123456", db="byr", charset="utf8")
        cursor = conn.cursor()

        # 从数据库中找出每个版块的名称
        sql = "select board_name from board"

        cursor.execute(sql)
        for board in cursor.fetchall():
            section_url = 'https://bbs.byr.cn/board/%s' % board[0]
            return Request(section_url,
                           meta={'board_name': board[0], 'cookiejar': response.cookiejar},
                           callback=self.board_page)

        cursor.close()
        conn.close()

    def board_page(self, response):
        sel = Selector(response)
        print response.body
        return
        PostNum_xpath = '//div[4]/div[1]/ul/li[1]/i/text()'
        post_num = sel.xpath(PostNum_xpath).extract()
        print post_num
































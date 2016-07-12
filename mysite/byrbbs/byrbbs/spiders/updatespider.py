# -*- coding: utf-8 -*-
from scrapy import Spider
from scrapy import FormRequest
from scrapy import Request
from scrapy.selector import Selector
import os
import json
import MySQLdb
import ConfigParser



class UpdatespiderSpider(Spider):
    name = "updatespider"
    allowed_domains = ["bbs.byr.cn"]
    start_urls = (
        'https://bbs.byr.cn/user/ajax_login.json',
    )

    pre_path = os.getcwd().replace(u"\\", u"/")
    # 配置文件路径
    pre_path = pre_path.replace('/byrbbs', '')
    config_path = pre_path + '/byrbbs/byrbbs/spider.conf'

    config = ConfigParser.ConfigParser()
    config.read(config_path)
    host = config.get('database', 'host')
    user = config.get('database', 'user')
    passwd = config.get('database', 'passwd')
    db = config.get('database', 'db')

    account_id = config.get('account_info', 'id')
    account_passwd = config.get('account_info', 'passwd')

    # 登录byr论坛
    def start_requests(self):
        return [FormRequest('https://bbs.byr.cn/user/ajax_login.json',
                            meta={'cookiejar': 1},
                            formdata={'id': self.account_id, 'passwd': self.account_passwd},
                            callback=self.logged_in,
                            headers={'X-Requested-With': 'XMLHttpRequest'})]

    # 遍历所有的版块
    def logged_in(self, response):
        login_info = json.loads(response.body.decode('gbk'))

        if login_info['ajax_msg'] != u'操作成功':
            print 'ERROR!!!'
            return

        conn = MySQLdb.connect(host=self.host, user=self.user, passwd=self.passwd, db=self.db, charset="utf8")
        cursor = conn.cursor()

        # 从数据库中找出每个版块的名称
        sql = "select board_name from board"

        cursor.execute(sql)
        for board in cursor.fetchall():
            section_url = 'https://bbs.byr.cn/board/%s' % board[0]
            yield Request(section_url,
                          meta={'board_name': board[0], 'cookiejar': response.meta['cookiejar']},
                          headers={'X-Requested-With': 'XMLHttpRequest'},
                          callback=self.board_page)

        cursor.close()
        conn.close()

    # 爬取每个版块的帖子的页数
    def board_page(self, response):
        sel = Selector(response)

        PostNum_xpath = '/html/body/div[4]/div[1]/ul/li[1]/i/text()'
        post_num = int(sel.xpath(PostNum_xpath).extract()[0])

        if post_num % 30 == 0:
            post_page = post_num / 30 + 1
        else:
            post_page = post_num / 30 + 2

        for num in xrange(1, 3):#post_page):
            page_url = 'https://bbs.byr.cn/board/%s?p=%s' % (response.meta['board_name'], num)

            yield Request(page_url,
                          meta={'board_name': response.meta['board_name'], 'cookiejar': response.meta['cookiejar']},
                          headers={'X-Requested-With': 'XMLHttpRequest'},
                          callback=self.post_list)

    # 遍历爬取所有的帖子
    def post_list(self, response):
        sel = Selector(response)

        # SELECT `last_time` FROM post where `board_name`='Constellations' ORDER BY `last_time` DESC LIMIT 1

        for i in xrange(1, 31):
            PostURL_xpath = '/html/body/div[3]/table/tbody/tr[%s]/td[2]/a/@href' % i
            PostTitle_xpath = '/html/body/div[3]/table/tbody/tr[%s]/td[2]/a/text()' % i
            AuthorID_xpath = '/html/body/div[3]/table/tbody/tr[%s]/td[4]/a/text()' % i
            LastTime_xpath = '/html/body/div[3]/table/tbody/tr[%s]/td[6]/a/text()' % i

            try:
                post_title = sel.xpath(PostTitle_xpath).extract()[0]
                post_url = sel.xpath(PostURL_xpath).extract()[0]
                author_id = sel.xpath(AuthorID_xpath).extract()[0]
                last_time = sel.xpath(LastTime_xpath).extract()[0]
            except:
                return

            post_url = 'https://bbs.byr.cn' + post_url

            yield Request(post_url,
                          meta={'cookiejar': response.meta['cookiejar'],
                                'post_title': post_title,
                                'post_url': post_url,
                                'author_id': author_id,
                                'last_time': last_time,
                                'board_name': response.meta['board_name']},
                          headers={'X-Requested-With': 'XMLHttpRequest'},
                          callback=self.post_spider)

    # 爬取帖子的内容
    def post_spider(self, response):
        pass

# coding: utf-8
from scrapy import Spider
from scrapy import FormRequest
from scrapy import Request
from scrapy.selector import Selector
from time import strftime, strptime, mktime, localtime
from byrbbs.items import postItem
import re
import json
import MySQLdb


class AllSpider(Spider):
    name = "allspider"
    allowed_domains = ["bbs.byr.cn"]
    start_urls = (
        'https://bbs.byr.cn/user/ajax_login.json',
    )

    # 登录byr论坛
    def start_requests(self):
        return [FormRequest('https://bbs.byr.cn/user/ajax_login.json',
                            meta={'cookiejar': 1},
                            formdata={'id': 'oneseven', 'passwd': '349458cddCXC'},
                            callback=self.logged_in,
                            headers={'X-Requested-With': 'XMLHttpRequest'})]

    # 遍历所有的版块
    def logged_in(self, response):
        login_info = json.loads(response.body.decode('gbk'))

        if login_info['ajax_msg'] != u'操作成功':
            print 'ERROR!!!'
            return

        conn = MySQLdb.connect(host="192.168.1.98", user="root", passwd="123456", db="byr", charset="utf8")
        cursor = conn.cursor()

        # 从数据库中找出每个版块的名称
        sql = "select board_name from board"

        cursor.execute(sql)
        for board in cursor.fetchall():
            section_url = 'https://bbs.byr.cn/board/%s' % board[0]
            return Request(section_url,
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

        for num in xrange(1, post_page):
            page_url = 'https://bbs.byr.cn/board/%s?p=%s' % (response.meta['board_name'], num)

            return Request(page_url,
                          meta={'board_name': response.meta['board_name'], 'cookiejar': response.meta['cookiejar']},
                          headers={'X-Requested-With': 'XMLHttpRequest'},
                          callback=self.post_list)

    # 遍历爬取所有的帖子
    def post_list(self, response):
        sel = Selector(response)

        for i in xrange(1, 31):
            PostURL_xpath = '/html/body/div[3]/table/tbody/tr[%s]/td[2]/a/@href' % i
            PostTitle_xpath = '/html/body/div[3]/table/tbody/tr[%s]/td[2]/a/text()' % i
            LastTime_xpath = '/html/body/div[3]/table/tbody/tr[%s]/td[6]/a/text()' % i

            try:
                post_title = sel.xpath(PostTitle_xpath).extract()[0]
                post_url = sel.xpath(PostURL_xpath).extract()[0]
                last_time = sel.xpath(LastTime_xpath).extract()[0]
            except Exception, e:
                raise e

            post_url = 'https://bbs.byr.cn' + post_url

            return Request(post_url,
                          meta={'cookiejar': response.meta['cookiejar'],
                                'post_title': post_title,
                                'post_url': post_url,
                                'last_time': last_time,
                                'board_name': response.meta['board_name']},
                          headers={'X-Requested-With': 'XMLHttpRequest'},
                          callback=self.post_content)

    # 爬取帖子的内容
    def post_content(self, response):
        sel = Selector(response)
        item = postItem()

        item['post_title'] = response.meta['post_title']
        item['post_url'] = response.meta['post_url']
        item['last_time'] = response.meta['last_time']
        item['board_name'] = response.meta['board_name']

        # 作者id和用户名
        AuthorInfo_xpath = '/html/body/div[3]/div[1]/table/tr[2]/td[2]/div/text()[1]'
        author_info = sel.xpath(AuthorInfo_xpath).extract()[0]

        item['author_id'] = re.findall(r':(.+?)\(', author_info)[0]
        item['author_name'] = re.findall(r'\((.+?)\)', author_info)[0]

        # 帖子发布时间
        PostTime_xpath = '/html/body/div[3]/div[1]/table/tr[2]/td[2]/div/text()[3]'
        post_time = sel.xpath(PostTime_xpath).extract()[0]

        post_time = re.findall(r'\((.+?)\)', post_time)[0]
        post_time = localtime(mktime(strptime(post_time, "%a %b %d %H:%M:%S %Y")))
        item['post_time'] = strftime('%Y-%m-%d %H:%M:%S', post_time)

        # 帖子总数
        PostNum_xpath = '/html/body/div[4]/div[1]/ul/li[1]/i/text()'
        item['post_num'] = sel.xpath(PostNum_xpath).extract()[0]

        # 帖子内容
        PostContent_xpath = '/html/body/div[3]/div[1]/table/tr[2]/td[2]/div'
        post_content = sel.xpath(PostContent_xpath).extract()[0]

        post_content = re.findall(r'.+?<br>.+?<br>.+?<br>(.+?)<font class=', post_content)[0]
        item['post_content'] = post_content.replace('<br>', '')

        return item








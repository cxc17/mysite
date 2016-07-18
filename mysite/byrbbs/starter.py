# coding: utf-8

from twisted.internet import reactor
from scrapy.utils.project import get_project_settings
from scrapy.crawler import Crawler
from scrapy.spider import log
from scrapy import signals

from byrbbs.spiders.updatespider import UpdatespiderSpider
from byrbbs.spiders.allspider import AllSpider

import sys


if __name__ == '__main__':
    spider_name = sys.argv[1]

    if spider_name == 'updatespider':
        spider = UpdatespiderSpider()
    elif spider_name == 'allspider':
        spider = AllSpider()
    else:
        print 'NO'
        exit(1)

    settings = get_project_settings()
    crawler = Crawler(settings)
    crawler.signals.connect(reactor.stop, signal=signals.spider_closed)
    crawler.configure()
    crawler.crawl(spider)
    crawler.start()

    # 启动log.
    log.scrapy_info(settings)
    log.start_from_settings(settings, crawler)

    reactor.run()

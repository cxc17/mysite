# -*- coding: utf-8 -*-
import scrapy


class AllSpider(scrapy.Spider):
    name = "allspider"
    allowed_domains = ["bbs.byr.cn"]
    start_urls = (
        'http://www.bbs.byr.cn/',
    )

    def parse(self, response):
        pass

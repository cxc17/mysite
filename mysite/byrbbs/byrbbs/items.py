# coding: utf-8

import scrapy


class postItem(scrapy.Item):
    type = scrapy.Field()
    post_id = scrapy.Field()
    post_title = scrapy.Field()
    post_url = scrapy.Field()
    post_content = scrapy.Field()
    author_id = scrapy.Field()
    author_name = scrapy.Field()
    board_name = scrapy.Field()
    post_num = scrapy.Field()
    post_time = scrapy.Field()
    last_time = scrapy.Field()


class commentItem(scrapy.Item):
    type = scrapy.Field()
    post_id = scrapy.Field()
    comment_url = scrapy.Field()
    comment_content = scrapy.Field()
    commenter_id = scrapy.Field()
    commenter_name = scrapy.Field()
    comment_time = scrapy.Field()

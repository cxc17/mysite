# -*- coding: utf-8 -*-

# Scrapy settings for byrbbs project
#
# For simplicity, this file contains only the most important settings by
# default. All the other settings are documented here:
#
#     http://doc.scrapy.org/en/latest/topics/settings.html
#

LOG_LEVEL = 'CRITICAL'

BOT_NAME = 'byrbbs'

SPIDER_MODULES = ['byrbbs.spiders']
NEWSPIDER_MODULE = 'byrbbs.spiders'

ITEM_PIPELINES = {'byrbbs.pipelines.ByrbbsPipeline': 100}

# Crawl responsibly by identifying yourself (and your website) on the user-agent
# USER_AGENT = 'byrbbs (+http://www.yourdomain.com)'

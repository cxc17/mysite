# coding: utf-8

import MySQLdb.cursors
from twisted.enterprise import adbapi
from time import time, localtime, strftime
import ConfigParser
import os


class ByrbbsPipeline(object):
    pre_path = os.getcwd()
    # pre_path = pre_path.replace('/byrbbs', '')
    # config_path = pre_path + '/byrbbs/byrbbs/spider.conf'

    pre_path = pre_path.replace('\\byrbbs', '')
    config_path = pre_path + '\\byrbbs\\byrbbs\\spider.conf'

    config = ConfigParser.ConfigParser()
    config.read(config_path)

    host = config.get('database', 'host')
    user = config.get('database', 'user')
    passwd = config.get('database', 'passwd')
    db = config.get('database', 'db')

    def __init__(self):
        self.dbpool = adbapi.ConnectionPool(
            dbapiName='MySQLdb',
            host=self.host,
            db=self.db,
            user=self.user,
            passwd=self.passwd,
            cursorclass=MySQLdb.cursors.DictCursor,
            charset='utf8',
            use_unicode=False
        )

    def process_item(self, item, spider):
        if item['type'] == 'post':
            self.dbpool.runInteraction(self.post_insert, item)
        else:
            self.dbpool.runInteraction(self.comment_insert, item)

        return item
    
    def post_insert(self, tx, item):
        now_time = localtime(time())
        now_time = strftime('%Y-%m-%d %H:%M:%S', now_time)

        sql = 'INSERT INTO `post` (`post_id`, `post_title`, `post_url`, `post_content`, `author_id`, ' \
              '`author_name`, `board_name`, `post_num`, `post_time`, `last_time`, `insert_time`) ' \
              'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)'

        tx.execute(sql, (item['post_id'], item['post_title'], item['post_url'], item['post_content'],
                         item['author_id'], item['author_name'], item['board_name'], item['post_num'],
                         item['post_time'], item['last_time'], now_time))

    def comment_insert(self, tx, item):
        sql = 'INSERT INTO `comment` (`post_id`, `comment_url`, `comment_content`, `commenter_id`, `commenter_name`, ' \
              '`comment_time`) VALUES (%s, %s, %s, %s, %s, %s)'

        tx.execute(sql, (item['post_id'], item['comment_url'], item['comment_content'], item['commenter_id'],
                         item['commenter_name'], item['comment_time']))

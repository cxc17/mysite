# coding: utf-8

import sys
import MySQLdb.cursors
from twisted.enterprise import adbapi

reload(sys)
sys.setdefaultencoding('utf-8')


class ByrbbsPipeline(object):
    def __init__(self):
        self.dbpool = adbapi.ConnectionPool(
            dbapiName='MySQLdb',
            host='192.168.1.98',
            db='byr',
            user='root',
            passwd='123456',
            cursorclass=MySQLdb.cursors.DictCursor,
            charset='utf8',
            use_unicode=False
        )

    def process_item(self, item, spider):
        query = self.dbpool.runInteraction(self._conditional_insert, item)
        return item
    
    def _conditional_insert(self, tx, item):
        sql = 'INSERT INTO `post` (`post_title`, `post_url`, `post_content`, `author_id`, ' \
              '`author_name`, `board_name`, `post_num`, `post_time`, `last_time`) ' \
              'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)'
        tx.execute(sql, (item['post_title'][0:], item['post_url'][0:], item['post_content'][0:], item['author_id'][0:],
                         item['author_name'][0:], item['board_name'][0:], item['post_num'][0:], item['post_time'][0:],
                         item['last_time'][0:]))
        # print '123'
        # sql = 'INSERT INTO `post` (`post_title`, `post_url`, `post_content`, `author_id`, ' \
        #       '`author_name`, `board_name`, `post_num`, `post_time`, `last_time`) ' \
        #       'VALUES (1, 1, 1, 1, 1, 1, 1, 1, 1)'
        # tx.execute(sql)


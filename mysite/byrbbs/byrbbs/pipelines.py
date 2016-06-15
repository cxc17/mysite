# coding: utf-8

import MySQLdb.cursors
from twisted.enterprise import adbapi


class ByrbbsPipeline(object):
    items = []

    def __init__(self):
        self.dbpool = adbapi.ConnectionPool(
            dbapiName='MySQLdb',
            host='127.0.0.1',
            db='byr',
            user='root',
            passwd='123456',
            cursorclass=MySQLdb.cursors.DictCursor,
            charset='utf8',
            use_unicode=False
        )

    def process_item(self, item, spider):
        if item['type'] == 'post':
            self.dbpool.runInteraction(self.post_insert, item)
        else:
            print len(item)
            self.dbpool.runInteraction(self.comment_insert, item)

        return item
    
    def post_insert(self, tx, item):
        sql = 'INSERT INTO `post` (`post_title`, `post_url`, `post_content`, `author_id`, ' \
              '`author_name`, `board_name`, `post_num`, `post_time`, `last_time`) ' \
              'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)'
        tx.execute(sql, (item['post_title'], item['post_url'], item['post_content'], item['author_id'],
                         item['author_name'], item['board_name'], item['post_num'], item['post_time'],
                         item['last_time']))

    def comment_insert(self, tx, item):
        pass

        # sql = 'INSERT INTO `post` (`post_title`, `post_url`, `post_content`, `author_id`, ' \
        #       '`author_name`, `board_name`, `post_num`, `post_time`, `last_time`) ' \
        #       'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)'
        # tx.execute(sql, (item['post_title'], item['post_url'], item['post_content'], item['author_id'],
        #                  item['author_name'], item['board_name'], item['post_num'], item['post_time'],
        #                  item['last_time']))

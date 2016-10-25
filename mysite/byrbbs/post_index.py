# coding: utf-8
# 建立post索引
from byrbbs.mysqlclient import get_mysql
from byrbbs.SpiderConfig import SpiderConfig


class post_index(object):
    def __init__(self):
        SpiderConfig.initialize()

    @staticmethod
    def Word_Segmentation():
        mh = get_mysql()

        sql = "select title, content from post"
        ret = mh.select(sql)

        for i in xrange(10):
            print ret[0][0]


if __name__ == '__main__':
    post_index().Word_Segmentation()


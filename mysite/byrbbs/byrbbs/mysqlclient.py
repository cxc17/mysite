# -*- coding: utf-8 -*-

import MySQLdb
from SpiderConfig import SpiderConfig


class get_mysql(object):
    __conn = None
    __cursor = None

    def __init__(self):
        self.__conn = MySQLdb.connect(host=SpiderConfig.host, user=SpiderConfig.user, passwd=SpiderConfig.passwd,
                                      db=SpiderConfig.db, charset="utf8")
        self.__cursor = self.__conn.cursor()

    def __del__(self):
        self.__cursor.close()
        self.__conn.close()

    def select(self, sql):
        try:
            self.__cursor.execute(sql)
            result_list = self.__cursor.fetchall()
        except Exception, err:
            raise err

        return result_list

    def execute(self, sql):
        try:
            self.__cursor.execute(sql)
        except Exception, err:
            raise err

        return


# coding: utf-8

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

    @staticmethod
    def select(sql):
        try:
            get_mysql.__cursor.execute(sql)
            result_list = get_mysql.__cursor.fetchall()
        except Exception, err:
            raise err

        return result_list

    @staticmethod
    def execute(sql):
        try:
            get_mysql.__cursor.execute(sql)

            # 没有commit调用就无法将更新语句写入数据库中
            get_mysql.__conn.commit()
        except Exception, err:
            # 数据库操作失败时回滚事务
            get_mysql.__conn.rollback()

            raise err

        return

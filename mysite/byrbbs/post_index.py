# coding: utf-8
# 建立post索引
from byrbbs.mysqlclient import get_mysql
from byrbbs.SpiderConfig import SpiderConfig

import jieba
import re


class post_index(object):
    def __init__(self):
        SpiderConfig.initialize()

    @staticmethod
    def Word_Segmentation():
        mh = get_mysql()
        mh2 = get_mysql()
        seg = ur"[\s+\.\!\/\"\'\-\|\]\[\{\}\\]+|[+——！，。：、~@#￥%……&*（）；－):①②③④⑤⑥⑦⑧⑨⑩⑴⑵⑶⑷⑸⑺─┅┆┈┍┎┒┙├┝┟┣┫┮┰┱┾┿╃╄╆╈╋▉▲▼※Ⅱ←→↖↗↘↙《》┊┋┇┉┠┨┌┐┑└┖┘┚┤┥┦┏┓┗┛┯┷┻┳┃━〓¤`˙⊙│〉〈⒂～？．＂”“’·■／￣�︱〕〔【】』『」「◎○◆●☉　┬┴┸┼═╔╗╚╝╩╭╮╯╰╱╲▁▅▆▇█▊▌▍▎▓▕□▽◇◢◣◤◥★☆︶︻︼︵︿﹃﹎﹏]+"

        sql = "select title, content from post limit 100000"
        mh.query(sql)

        for i in xrange(100000):
            ret = mh.selectone()
            title = re.sub(seg, " ".decode("utf8"), ret[0])
            title = set(jieba.cut(title))
            content = re.sub(seg, " ".decode("utf8"), ret[1])
            content = set(jieba.cut(content))
            for word in title:
                if word == u' ':
                    continue
                sql = "select * from post_index where word='%s'" % word
                ret = mh2.select(sql)
                if ret:
                    pass
                else:
                    sql = "insert into post_index(`word`) values ('%s') " % word
                    mh2.execute(sql)
            for word in content:
                if word == u' ':
                    continue
                sql = "select * from post_index where word='%s'" % word
                ret = mh2.select(sql)
                if ret:
                    pass
                else:
                    sql = "insert into post_index(`word`) values ('%s') " % word
                    mh2.execute(sql)


if __name__ == '__main__':
    import time
    a = time.time()
    post_index().Word_Segmentation()
    print time.time()-a

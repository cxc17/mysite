# coding:utf-8

import multiprocessing
import urllib

def run(i):
    print i
    urllib.urlopen('http://www.baidu.com')
    i = str(i) + '\n'
    f = open('1.txt', 'a+')
    f.write(i)
    f.close()
    print i,'ok'


if __name__ == '__main__':
    f = open('1.txt', 'w')
    f.close()
    pool = multiprocessing.Pool(processes=5)
    for i in xrange(10000):
        pool.apply_async(run, (i+1, ))
        # run(i)
    print 'asd'

    pool.close()
    pool.join()
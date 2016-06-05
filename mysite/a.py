# coding: utf-8

from multiprocessing import Manager, Lock, Pool, Process
from multiprocessing.dummy import Pool as ThreadPool 
import time, multiprocessing
import urllib


def run(lock):
    for x in xrange(400000000):
        x += 1
    return


# IO 密集型任务
def run2(lock):
    try:
        urllib.urlopen('https://www.baidu.com')
    except Exception, e:
        pass
    return
    for j in xrange(50):
        try:
            time.sleep(0.1)
            urllib.urlopen('https://www.baidu.com')
        except Exception, e:
            pass
        # lock.acquire()
        f = open('2.txt', 'a+')
        f.write(str(j+1)+'\n')
        f.close()
        # lock.release()

if __name__ == '__main__':
    f = open('2.txt', 'w')
    f.close()
    pool_size = multiprocessing.cpu_count()
    print pool_size
    c = time.time()

    lock = Manager().Lock()
    pool = Pool(processes=17)
    for i in xrange(100):
        pool.apply_async(run2, (lock,))
        # p = Process(target=run2,args=(lock, ))
        # p.start()
        # p.join()
    pool.close()
    pool.join()

    b = time.time()
    # print b - c


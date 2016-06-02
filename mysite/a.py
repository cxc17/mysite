# coding:utf-8

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
        urllib.urlopen('http://10.3.8.211')
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
    pool = Pool(processes=4)
    for i in xrange(1000):
        pool.apply_async(run2, (lock,))
        # p = Process(target=run2,args=(lock, ))
        # p.start()
        # p.join()
    pool.close()
    pool.join()

    b = time.time()
    # print b - c

# lock问题

# from multiprocessing import Process,Lock
# import time

# def f(l,i):

#     l.acquire()

#     print "hello world",i
#     time.sleep(1)
#     l.release()


# if __name__ == "__main__":

#     lock = Lock()

#     for num in range(10):
#         Process(target=f,args=(lock,num)).start()



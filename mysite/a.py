# coding:utf-8

from multiprocessing import Lock, Pool
import urllib
import time


# a = 0
def run(i):
    for x in xrange(20000000):
    # a = 1
        x += 1
    return

    try:
        urllib.urlopen('https://www.baidu.com')
    except Exception, e:
        print i

    i = str(i) + '\n'
    f = open('2.txt', 'a+')
    f.write(i)
    f.close()


if __name__ == '__main__':
    f = open('2.txt', 'w')
    f.close()

    c = time.time()
    for x in xrange(20000000):
    # a = 1
        x += 1
    # pool = Pool(processes=10)

    # for i in xrange(10):
    #     pool.apply_async(run, (i, ))

    # pool.close()
    # pool.join()

    b = time.time()
    print b - c

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



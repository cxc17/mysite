#coding=utf-8
import threading
import time
import urllib

a = 0
def run(lock, i):
    print float('%0.5f' %time.time())
    for x in xrange(50000000):
        x += 1
    return



    print 123
    time.sleep(1)
    return
    for j in xrange(1000):
        lock.acquire()
        global a
        a += 1
        lock.release()
        if a == 10000:
            print a
        # print i, j
        try:
            # urllib.urlopen('https://www.baidu.com')
            # time.sleep(0.1)
            pass
        except Exception, e:
            print i, j
        while 1:
            # lock.acquire()
            # f = open('1.txt', 'a+')
            # f.write(str(j+1)+'\n')
            # f.close()
            # lock.release()
            break


if __name__ == '__main__':
    threads = []
    f = open('1.txt', 'w')
    f.close()

    c = time.time()

    lock = threading.Lock()
    # run(lock, 1)

    for i in xrange(2):
        t1 = threading.Thread(target=run,args=(lock, i))
        threads.append(t1)

    for t in threads:
        # t.setDaemon(True)
        t.start()
    # 此处join的原理就是依次检验线程池中的线程是否结束，没有结束就阻塞直到线程结束，如果结束则跳转执行下一个线程的join函数。
    for t in threads:
        t.join()
    
    b = time.time()

    print b-c

    # global a
    # print a


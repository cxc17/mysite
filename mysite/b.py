#coding=utf-8
import threading
import time
import urllib


def run(lock, i):
    # lock.acquire()

    # print "hello world",i
    # time.sleep(1)
    # lock.release()

    for j in xrange(1000):
        print i, j
        urllib.urlopen('https://www.baidu.com')
        while 1:
            lock.acquire()
            f = open('1.txt', 'a+')
            f.write(str(j+1)+'\n')
            f.close()
            lock.release()
            break


if __name__ == '__main__':
    threads = []
    f = open('1.txt', 'w')
    f.close()

    a = time.time()

    lock = threading.Lock()
    # run(lock, 1)

    for i in xrange(10):
        t1 = threading.Thread(target=run,args=(lock, i))
        threads.append(t1)

    for t in threads:
        # t.setDaemon(True)
        t.start()
    
    
    t.join()
    
    b = time.time()

    print (b-a)

#coding=utf-8
import threading
import time


# CPU 密集型任务
def run():
    for x in xrange(5000000):
        x += 1
    return

# IO 密集型任务
def run2(lock):
    for j in xrange(1000):
        lock.acquire()
        # global a
        # a += 1
        f = open('1.txt', 'a+')
        f.write(str(j+1)+'\n')
        f.close()
        lock.release()

if __name__ == '__main__':
    threads = []
    f = open('1.txt', 'w')
    f.close()

    c = time.time()

    lock = threading.Lock()
    for i in xrange(2):
        t1 = threading.Thread(target=run2, args=(lock,))
        threads.append(t1)

    for t in threads:
        # t.setDaemon(True)
        t.start()
    # 此处join的原理就是依次检验线程池中的线程是否结束，没有结束就阻塞直到线程结束，如果结束则跳转执行下一个线程的join函数。
    # for t in threads:
    t.join()
    
    b = time.time()
    print b-c



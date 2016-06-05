# coding: utf-8
# python多线程threading模块的例子
import threading
import time
import urllib


var = 0
# CPU 密集型任务
def fun(lock):
    global var
    for i in xrange(100000):
        # with lock: # 另一种获得锁的方式
        lock.acquire()
        var += 1
        lock.release()


# IO 密集型任务
def fun2():
    for j in xrange(50):
        urllib.urlopen('http://www.baidu.com')


if __name__ == '__main__':
    threads = []

    # 线程锁，作为资源的锁，防止多个线程同时访问一个资源，导致最后资源的数据错误。
    lock = threading.Lock()


    # 多线程访问CPU密集型任务，实际效果不如单线程，时间大于单线程
    for i in xrange(5):
        t = threading.Thread(target=fun, args=(lock,))
        threads.append(t)


    # 多线程访问IO密集型任务，实际效果好于单线程，时间小于单线程
    # for i in xrange(5):
    #     t = threading.Thread(target=fun2, args=())
    #     threads.append(t)


    for t in threads:
        # 子线程启动后，父线程也继续执行下去，当父线程执行完最后一条语句后，没有等待子线程，直接就退出了，同时子线程也一同结束。
        # t.setDaemon(True)
        t.start()


    # 此处join只会使最后的线程被阻塞，如果最后的线程没有执行，就不会执行主线程的内容
    t.join()


    # 此处join的原理就是依次检验线程池中的线程是否结束，没有结束就阻塞直到线程结束，如果结束则跳转执行下一个线程的join函数。
    # for t in threads:
        # 这边的线程会依次执行，最后效果和单线程相同
        # t.join()


    # Timer类
    # t = Timer(10, fun2)
    # t.start() # 30秒后, "hello, world"将被打印
    # t.cancel()

 
# Event

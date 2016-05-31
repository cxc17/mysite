# # coding:utf-8

# from multiprocessing import Lock, Pool
# import urllib
# import time


# def run(i, lock):
#     # print i
#     # urllib.urlopen('https://www.baidu.com')
#     # # time.sleep(0.1)
#     # i = str(i) + '\n'
#     # f = open('1.txt', 'a+')
#     # f.write(i)
#     # # print time.time()
#     # f.close()
#     # # print i,'ok'
#     print 123
#     lock.acquire()
#     print i
#     time.sleep(3)
#     lock.release()


# if __name__ == '__main__':
#     f = open('1.txt', 'w')
#     f.close()
#     pool = Pool(processes=1)

#     lock = Lock()
#     for i in xrange(10):
#         pool.apply_async(run, (i, lock, ))
#         # run(i,lock)

#     pool.close()
#     pool.join()

from multiprocessing import Process,Lock
import time

def f(l,i):

      # l.acquire()

      print "hello world",i
      time.sleep(1)
      # l.release()

 

if __name__ == "__main__":

        lock = Lock()

        for num in range(10):

                Process(target=f,args=(lock,num)).start()



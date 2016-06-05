# coding: utf-8
import threading
import time


def fun(cndition):
	time.sleep(1) #确保先运行t2   

	cndition.acquire()
	print 'thread1 acquires lock.'
	cndition.notify()
	cndition.wait()
	print 'thread1 acquires lock again.'
	cndition.release()
	

def fun2(cndition):
	cndition.acquire()

	print 'thread2 acquires lock.'
	cndition.wait()
	print 'thread2 acquires lock again.'
	cndition.notify()
	cndition.release()


if __name__ == '__main__':
	cndition = threading.Condition()
	t1 = threading.Thread(target=fun, args=(cndition,))
	t2 = threading.Thread(target=fun2, args=(cndition,))
	t1.start()
	t2.start()
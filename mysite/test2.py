#coding: utf-8
#多线程爬虫

import multiprocessing
import requests
import time

def spider(url):
	request = requests.get(url)


if __name__ == '__main__':
	urls = []
	url = 'http://www.qq.com'
	for x in xrange(0, 10):
		urls.append(url)
	

	#此部分是单线程操作
	time1 = time.time()
	for i in xrange(0, 10):
		request = requests.get(url)
	time2 = time.time()

	print '单线程时间:', str(time2 - time1)


	#此部分是多线程操作
	pool = multiprocessing.Pool(processes = 2)
	time1 = time.time()
	pool.map(spider, urls)		#map()是解决一个list
	time2 = time.time()

	print '多线程时间:', str(time2 - time1)

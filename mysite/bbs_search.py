# coding: utf-8


from lxml import etree
import requests
import re
import MySQLdb

headers = {'X-Requested-With': 'XMLHttpRequest'}

login_data = {
    'id': 'oneseven',
    'passwd': '349458cddCXC'
}

count = 1

# 以发帖人的ID或标题中的词语为关键字查找帖子 
def keyword_search(session, section_url, board_name):
	global count

	req = session.get(section_url, headers=headers)
	try:
		html = req.content.decode("gbk")
	except Exception, e:
		html = req.content
	
	sel = etree.HTML(html)

	xpath_num = '//div[3]/div/ul/li[1]/i/text()'
	title_num = int(sel.xpath(xpath_num)[0])

	if title_num % 80 == 0:
		page = title_num / 80 - 1
	else:
		page = title_num / 80 


	for board_num in xrange(1,81):
		try:
			xpath_name = '//div[2]/table/tr[%s]/td[2]/a/text()' % board_num
			xpath_url = '//div[2]/table/tr[%s]/td[2]/a/@href' % board_num
			title = sel.xpath(xpath_name)[0]
			url = 'https://bbs.byr.cn/' + sel.xpath(xpath_url)[0]
		except Exception, e:
			break

		print count, board_name
		print title, url
		count += 1


	for i in xrange(page):
		section_url = section_url + '&p=%s' % (i+2)
		req = session.get(section_url, headers=headers)
		try:
			html = req.content.decode("gbk")
		except Exception, e:
			html = req.content
		
		sel = etree.HTML(html)

		for board_num in xrange(1,81):
			try:
				xpath_name = '//div[2]/table/tr[%s]/td[2]/a/text()' % board_num
				xpath_url = '//div[2]/table/tr[%s]/td[2]/a/@href' % board_num
				title = sel.xpath(xpath_name)[0]
				url = 'https://bbs.byr.cn/' + sel.xpath(xpath_url)[0]
			except Exception, e:
				break

			print count, board_name
			print title, url
			count += 1


def main():
	session = requests.session()

	login_url = 'https://bbs.byr.cn/user/ajax_login.json'
	session.post(login_url, data=login_data, headers=headers)

	conn=MySQLdb.connect(host="192.168.1.98", user="root", passwd="123456", db="byr", charset="utf8")    
	cursor = conn.cursor() 

	# 从数据库中找出每个版块的名称
	sql = "select board_name from board"
	
	cursor.execute(sql)      
	for row in cursor.fetchall():
		# 以发帖人的ID为关键字查找帖子 
		section_url = 'https://bbs.byr.cn/s/article?au=%s&b=%s' % ('oneseven', row[0])
		keyword_search(session, section_url, row[0])

		# 以标题中的词语为关键字查找帖子 
		# section_url = 'https://bbs.byr.cn/s/article?t1=%s&b=%s' % ('python', 'Python')#row[0])
		# keyword_search(session, section_url, 'Python')#row[0])

	cursor.close()
	conn.close()


if __name__ == '__main__':
	# main()

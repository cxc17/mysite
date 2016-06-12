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
def run(session, section_url, board_name):
	global count
	req = session.get(section_url, headers=headers)
	try:
		html = req.content.decode("gbk")
	except Exception, e:
		html = req.content
	
	sel = etree.HTML(html)

	section_urls =[] 
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

	conn=MySQLdb.connect(host="127.0.0.1", user="root", passwd="123456", db="byr", charset="utf8")    
	cursor = conn.cursor() 
	sql = "select board_name from board"
	
	cursor.execute(sql)      
	for row in cursor.fetchall():
		section_url = 'https://bbs.byr.cn/s/article?au=%s&b=%s' % ('guitarmega', row[0])
		run(session, section_url, row[0])

	cursor.close()
	conn.close()


if __name__ == '__main__':
	main()



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


def run(session, section_url):
	req = session.get(section_url, headers=headers)
	html = req.content.decode("gbk")
	sel = etree.HTML(html)

	conn=MySQLdb.connect(host="192.168.1.28", user="root", passwd="123456", db="byr", charset="utf8")    
	cursor = conn.cursor() 
	sql = "insert into board (`board_name`) values ('%s')"

	section_urls =[] 
	for board_num in xrange(1,50):
		try:
			xpath_name = '//div[2]/table/tbody/tr[%s]/td[1]/a/@href' % board_num
			board_url = sel.xpath(xpath_name)[0]
		except Exception, e:
			break

		if 'board' in board_url:
			board_name = re.findall(r'board/(.+)', board_url)[0]
			cursor.execute(sql % board_name)
			print board_num, board_url
		else:
			section_url = 'https://bbs.byr.cn' + board_url
			print board_num
			run(session, section_url)

	cursor.close()
	conn.close()


def main():
	session = requests.session()

	login_url = 'https://bbs.byr.cn/user/ajax_login.json'
	session.post(login_url, data=login_data, headers=headers)

	for section_num in xrange(0, 10):
		section_url = 'https://bbs.byr.cn/section/%s' % section_num

		run(session, section_url)


if __name__ == '__main__':
	main()

# 'https://bbs.byr.cn/s/article?t1=2asdads&au=&b=notepad&_uid=oneseven'

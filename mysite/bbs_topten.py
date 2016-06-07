# coding: utf-8


from lxml import etree
import requests
import re

headers = {'X-Requested-With': 'XMLHttpRequest'}

login_data = {
    'id': 'oneseven',
    'passwd': '349458cddCXC'
}


def run(session, section_url):
	req = session.get(section_url, headers=headers)
	html = req.content.decode("gbk")
	sel = etree.HTML(html)

	section_urls =[] 
	for board_num in xrange(1,50):
		try:
			xpath_name = '//div[2]/table/tbody/tr[%s]/td[1]/a/@href' % board_num
			board_url = sel.xpath(xpath_name)[0]
		except Exception, e:
			break

		if 'board' in board_url:
			print board_num, board_url
		else:
			section_url = 'https://bbs.byr.cn' + board_url
			print board_num
			run(session, section_url)


def main():
	session = requests.session()

	login_url = 'https://bbs.byr.cn/user/ajax_login.json'
	session.post(login_url, data=login_data, headers=headers)

	for section_num in xrange(0, 2):
		section_url = 'https://bbs.byr.cn/section/%s' % section_num

		run(session, section_url)


if __name__ == '__main__':
	main()

# 'https://bbs.byr.cn/s/article?t1=2asdads&au=&b=notepad&_uid=oneseven'
# //*[@id="body"]/div[2]/table/tbody/tr[3]/td[1]/a
# //*[@id="body"]/div[2]/table/tbody/tr[2]/td[1]/a

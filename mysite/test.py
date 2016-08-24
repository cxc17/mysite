# coding: utf-8

import os
import MySQLdb
import ConfigParser


def Import_SQL():
	# 配置文件路径
	config_path = './sql.conf'

	config = ConfigParser.ConfigParser()
	config.read(config_path)

	# 数据库配置信息
	host = config.get('database', 'host')
	user = config.get('database', 'user')
	passwd = config.get('database', 'passwd')
	db = config.get('database', 'db')

	# path = "/Users/caixiaochuan/Desktop/mysite/mysite/byr.sql"

	# os.system("mysql -h%s -u%s -p%s" %(host, user, passwd))
	# os.system("use %s;" % db)
	# os.system("source %s;" %path)
	# os.system("exit;")

	# return

	# 连接数据库
	conn = MySQLdb.connect(user=user, passwd=passwd, host=host, db=db, charset='utf8')
	cur = conn.cursor()


	# sql = open("/Users/caixiaochuan/Desktop/byrbbs/byr.sql").read()

	sql = open("/Users/caixiaochuan/Desktop/byrbbs/byr.sql")
	sql = "".join(sql.readlines()).strip()

	for i in sql.split(";"):
		if i:
			cur = conn.cursor()
			cur.execute(i)
			cur.close()

	# cur.execute("source /Users/caixiaochuan/Desktop/byrbbs/byr.sql")
	# cur.execute(sql)

	cur.close()
	conn.close()


def Export_SQL():
	# 配置文件路径
	config_path = './sql.conf'

	config = ConfigParser.ConfigParser()
	config.read(config_path)

	# 数据库配置信息
	host = config.get('database', 'host')
	user = config.get('database', 'user')
	passwd = config.get('database', 'passwd')
	db = config.get('database', 'db')

	os.system(" mysqldump -h%s -u%s -p%s %s > byr.sql" %(host, user, passwd ,db))


if __name__ == '__main__':
	Import_SQL()
	# Export_SQL()

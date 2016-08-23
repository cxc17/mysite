# coding: utf-8
 
import MySQLdb
import ConfigParser


# def Import_SQL():
# 	# 配置文件路径
# 	config_path = './sql.conf'

# 	config = ConfigParser.ConfigParser()
# 	config.read(config_path)

# 	# 数据库配置信息
# 	host = config.get('database', 'host')
# 	user = config.get('database', 'user')
# 	passwd = config.get('database', 'passwd')
# 	db = config.get('database', 'db')

# 	# 连接数据库
# 	conn = MySQLdb.connect(user=user, passwd=passwd, host=host, db=db, charset='utf8')
# 	cur = conn.cursor()

# 	cur.execute("source news.sql")

# 	cur.close()
# 	conn.close()


# if __name__ == '__main__':
# 	Import_SQL()


import time 

a = {"1":1,"2":2}

print len(a)
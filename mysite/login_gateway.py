# coding:utf-8
import urllib 
import urllib2
import sys

def login():    
    # username = "2015140953"
    # passwd = "2157687"
    username = raw_input("input username:")
    passwd = raw_input("input password:")

    data={"DDDDD": username, 'upass': passwd, '0MKKey': ''}
    login_url = "http://10.3.8.211/" 
    data = urllib.urlencode(data)

    req = urllib2.Request(url=login_url, data=data)
    res_data = urllib2.urlopen(req).read()
    return_content = res_data.decode("gbk")
    if u"成功登录" in return_content:
        print "login success"
    else:
        print "login failed"

def logout():
    logout_url = "http://10.3.8.211/F.htm"
    req = urllib2.Request(url=logout_url)
    urllib2.urlopen(req)
    print "logout success"


if __name__ == '__main__':
    try:
        if sys.argv[1] == '1':
            login()
        elif sys.argv[1] == '2':
            logout()
    except:
        print "input your choice"
        print "login: input 1"
        print "logout: input 2"

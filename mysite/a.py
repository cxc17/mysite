import signal
import os
import time
import subprocess 

# Define signal handler function
def myHandler(signum, frame):
    print("Now, it's the time")
    # exit()
    raise Exception
# register signal.SIGALRM's handler


try:
    signal.signal(signal.SIGALRM, myHandler)
    signal.alarm(2)
    # time.sleep(100)
    # os.system("python b.py")
    subprocess.call("python b.py", shell=True) 
    print 'END'
except Exception as e:
    raise e

http://www.jb51.net/article/74844.htm
http://www.cnblogs.com/xautxuqiang/p/5339602.html
http://www.cnblogs.com/dkblog/archive/2011/03/11/1980556.html
http://www.2cto.com/os/201402/276448.html
http://www.cnblogs.com/peida/archive/2012/12/19/2824418.html
http://blog.csdn.net/hbuxiaofei/article/details/8834722

# import tornado.ioloop
# import tornado.web
#
#
# class MainHandler(tornado.web.RequestHandler):
#     def get(self):
#         self.write("Hello, world")
#
#
# def make_app():
#     return tornado.web.Application([
#         (r"/", MainHandler),
#     ])
#
# if __name__ == "__main__":
#     app = make_app()
#     app.listen(8888)
#     tornado.ioloop.IOLoop.current().start()
#

# import math

# while 1:
#     try:
#         l, r = map(int, raw_input().split())
#         cache = [0]*10

#         for i in xrange(1, r+1):
#             a = math.ceil(l*1.0/i)
#             b = r/i - a + 1
#             if b > 0:
#                 cache[int(str(i)[0])] += int(b)

#         for i in xrange(1, 10):
#             print cache[i]
#     except:
#         break

a = """[  3]  1.0- 2.0 sec  94.4 MBytes   792 Mbits/sec   0.027 ms 1230/68602 (1.8%)
[  3]  2.0- 3.0 sec  95.4 MBytes   800 Mbits/sec   0.012 ms  308/68345 (0.45%)
[  3]  3.0- 4.0 sec  95.0 MBytes   797 Mbits/sec   0.023 ms  299/68044 (0.44%)
[  3]  4.0- 5.0 sec  95.0 MBytes   797 Mbits/sec   0.021 ms  403/68196 (0.59%)
[  3]  5.0- 6.0 sec  95.0 MBytes   797 Mbits/sec   0.013 ms  607/68345 (0.89%)
[  3]  6.0- 7.0 sec  94.8 MBytes   795 Mbits/sec   0.013 ms  695/68328 (1%)
[  3]  7.0- 8.0 sec  95.5 MBytes   801 Mbits/sec   0.012 ms  207/68326 (0.3%)
[  3]  8.0- 9.0 sec  94.5 MBytes   793 Mbits/sec   0.013 ms  674/68112 (0.99%)
[  3]  9.0-10.0 sec  95.3 MBytes   800 Mbits/sec   0.025 ms  220/68225 (0.32%)
[  3] 10.0-11.0 sec  89.2 MBytes   748 Mbits/sec   0.013 ms 4739/68364 (6.9%)
[  3] 11.0-12.0 sec  94.8 MBytes   795 Mbits/sec   0.012 ms  725/68325 (1.1%)
[  3] 12.0-13.0 sec  95.4 MBytes   801 Mbits/sec   0.014 ms  155/68239 (0.23%)
[  3] 13.0-14.0 sec  94.7 MBytes   794 Mbits/sec   0.013 ms  697/68252 (1%)
[  3] 14.0-15.0 sec  95.6 MBytes   802 Mbits/sec   0.014 ms  154/68362 (0.23%)
[  3] 15.0-16.0 sec  92.6 MBytes   776 Mbits/sec   0.022 ms 1561/67585 (2.3%)
[  3] 16.0-17.0 sec  95.0 MBytes   797 Mbits/sec   0.019 ms  285/68065 (0.42%)
[  3] 17.0-18.0 sec  94.4 MBytes   792 Mbits/sec   0.016 ms 1141/68452 (1.7%)
[  3] 18.0-19.0 sec  92.2 MBytes   773 Mbits/sec   0.013 ms  389/66142 (0.59%)
[  3] 19.0-20.0 sec  95.1 MBytes   797 Mbits/sec   0.018 ms  441/68253 (0.65%)
[  3] 20.0-21.0 sec  92.8 MBytes   778 Mbits/sec   0.014 ms 1327/67492 (2%)
[  3] 21.0-22.0 sec  95.4 MBytes   800 Mbits/sec   0.019 ms  206/68251 (0.3%)
[  3] 22.0-23.0 sec  95.1 MBytes   798 Mbits/sec   0.012 ms  442/68262 (0.65%)
[  3]  0.0-24.0 sec  2.21 GBytes   791 Mbits/sec   0.187 ms 20120/1633823 (1.2%"""

import re
a = a.split("\n")
for s in a:
    print  float(re.search(r"sec   (.+?)ms", s).group(1))
    # print float(s) +0.05




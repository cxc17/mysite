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

import math

while 1:
    try:
        l, r = map(int, raw_input().split())
        cache = [0]*10

        for i in xrange(1, r+1):
            a = math.ceil(l*1.0/i)
            b = r/i - a + 1
            if b > 0:
                cache[int(str(i)[0])] += int(b)

        for i in xrange(1, 10):
            print cache[i]
    except:
        break


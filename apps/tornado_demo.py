# !/usr/bin/env python
# -*- coding:utf-8 -*-

import tornado.web
import tornado.ioloop


class IndexHandler(tornado.web.RequestHandler):

    def get(self, *args, **kwargs):
        self.write("Hello World, My name is 张岩林")


application = tornado.web.Application([
    (r'/index', IndexHandler),
])

if __name__ == "__main__":
    application.listen(8080)
    tornado.ioloop.IOLoop.instance().start()
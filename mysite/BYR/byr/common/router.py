# coding: utf-8

import webob
import routes.middleware


class ByrRouter(object):

    def __init__(self, conf):
        self.conf = dict(conf)
        mapper = self.set_mapper()
        app = self.set_app()
        self.router = routes.middleware.RoutesMiddleware(app, mapper)

    def set_mapper(self):
        # should be overriden
        pass

    def set_app(self):
        # return wsgi application
        # should be overriden
        pass

    @webob.dec.wsgify
    def __call__(self, req):
        return self.router

    @staticmethod
    def get_match(req):
        url, match = req.environ['wsgiorg.routing_args']
        return match

    @classmethod
    def app_factory(cls, global_conf, **local_conf):
        conf = global_conf.copy()
        conf.update(local_conf)
        return cls(conf)

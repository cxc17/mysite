# coding: utf-8

import routes
import webob
import webob.dec

from byr.common.resp import resp
from byr.common.router import ByrRouter


class Router(ByrRouter):

    def set_mapper(self):
        mapper = routes.Mapper()
        mapper.connect('/',
                       conditions=dict(method=['GET']),
                       action='test')
        mapper.connect('/',
                       conditions=dict(method=['POST']),
                       action='test2')
        return mapper

    def set_app(self):
        return self.application

    @webob.dec.wsgify
    def application(self, req):
        match = self.get_match(req)
        action = match.get('action')

        if action == 'test':
            return DataClient.test(req, match)
        elif action == 'test2':
            return DataClient.test(req, match)
        else:
            return resp(400, 'param error')


class DataClient(object):
    def __init__(self):
        pass

    @staticmethod
    def test(req, match):
        return resp(1, 'param error')

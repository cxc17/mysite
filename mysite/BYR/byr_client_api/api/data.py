# coding: utf-8

import webob
import routes

from byr.common.router import ByrRouter
from byr.common.resp import resp


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

    def test(self):
        return resp(1, 'param error')

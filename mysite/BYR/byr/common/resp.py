# coding: utf-8

import json
import copy
import webob


class PRet(object):
    def __init__(self):
        self.ret = {'ret_code': 0,
                    'ret_info': {}}

    def set_ret(self, v):
        self.ret['ret_code'] = v

    def set_data(self, v):
        self.ret['ret_info'] = copy.deepcopy(v)

    @property
    def json_format(self):
        return str(json.dumps(self.ret))

    @property
    def ch_json_format(self):
        return str(json.dumps(self.ret, ensure_ascii=False))


def resp(ret_code, ret_info, ch=False):
    ret = PRet()
    ret.set_ret(ret_code)
    ret.set_data(ret_info)

    resp = webob.Response()
    if not ch:
        resp.body = ret.ch_json_format
    else:
        resp.text = json.dumps(ret.ret, ensure_ascii=False)
    resp.content_type = 'application/json'

    return resp

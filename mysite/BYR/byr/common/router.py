# coding: utf-8


import routes
import routes.middleware


class ByrRouter():
    @classmethod
    def app_factory(cls, global_conf, **local_conf):
        conf = global_conf.copy()
        conf.update(local_conf)

        return cls(conf)




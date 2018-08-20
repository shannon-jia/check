#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""The Application Interface."""

import logging
import asyncio
# import json
from aiohttp import web

log = logging.getLogger(__name__)


class Api(object):
    ''' Application Interface for RPS
    '''

    def __init__(self, port=8099, site=None):
        loop = asyncio.get_event_loop()
        self.app = web.Application(loop=loop)
        self.port = port
        self.site = site
        self.app.router.add_get('/', self.index)
        self.app.router.add_post('/login', self.cctv_server)

    def start(self):
        # outside
        web.run_app(self.app, host='0.0.0.0', port=self.port)

    async def index(self, request):
        return web.json_response({
            'name': 'Video Driver',
            'api_version': 'V2'})

    async def cctv_server(self, request):
        r = await request.json()
        print('-----------', r)
        return web.json_response({'status': '8000'})


if __name__ == "__main__":
    api = Api()
    api.start()

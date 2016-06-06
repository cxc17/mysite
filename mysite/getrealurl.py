# coding: utf-8

import urllib
import base64
import xml.etree.cElementTree as ET


def analyse_urls(videourl):
	url_base64 = base64.b64encode(videourl)

	f = urllib.urlopen('http://api3.flvurl.net/demo02/?url=%s' % url_base64)
	root = ET.fromstring(f.read())

	urls = []
	for video in root.find('files'):
		video_type = video.find('quality').text
		video_urls = []
		for video_url in video.findall('seg'):
			video_urls.append(video_url.find('furl').text)

		urls.append((video_type, video_urls))

	return urls


def getvideolist(videourl):
	try:
		urls = analyse_urls(videourl)
	except:
		return []

	return urls


if __name__ == '__main__':
	print getvideolist('http://tv.sohu.com/20160605/n453093612.shtml')

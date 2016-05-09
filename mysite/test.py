import requests
import re
import json
for i in xrange(1000):
	s = requests.get('http://acfunfix.sinaapp.com/mama.php?url=http://v.qq.com/cover/3/3xk72twalaqaku0.html&callback=MAMA2_HTTP_JSONP_CALLBACK0')

	data_json = re.findall(r'({.+})', s.content)[0]
	data = json.loads(data_json)

	print i
	print data['mp4']
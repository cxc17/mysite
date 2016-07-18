# coding: utf-8
 
from ctypes import *


libtest = cdll.LoadLibrary('./libSiteParser.so') 
# libtest = cdll.LoadLibrary('./libcpptest.so') 

class RelatedWebUrl(Structure):  
    _fields_ = [('strType', POINTER(c_char)), 
                ('url', POINTER(c_char))
                ] 

class VideoSeg(Structure):  
    _fields_ = [('fileSize', c_ulonglong), 
                ('seconds', c_int),  
                ('fileNO', c_int), 
                ('url', POINTER(c_char))
                ] 


class VideoInType(Structure):  
    _fields_ = [('strType', POINTER(c_char)), 
                ('segCount', c_int),  
                ('segs', POINTER(VideoSeg))
                ] 

class VideoResult(Structure):  
    _fields_ = [('siteID', c_int), 
                ('timeLength', c_ulonglong),  
                ('frameCount', c_ulonglong), 
                ('totalSize', c_ulonglong),

                ('vName', c_int),
                ('tags', c_char),

                ('streamCount', c_int),
                ('streams', POINTER(VideoInType)),

                ('relatedUrlCount', c_int),
                ('relatedUrls', POINTER(RelatedWebUrl))
                ] 


cVideoResult = POINTER(VideoResult)()

# url = c_char_p("http://v.ifeng.com/mil/arms/201208/6a16f9f9-782e-436f-a5de-f89601a5f50d.shtml")
url = c_char_p("http://v.qq.com/video/play.html?vid=7QQh2OVIB6k")

# print libtest.DLVideo_Parse(url, None, None, None)

print libtest.DLVideo_Parse(url, byref(cVideoResult), None, None)

print cVideoResult.contents.siteID


print cVideoResult.contents.vName
# # print cVideoResult.contents.tags
# print cVideoResult.contents.timeLength
# print cVideoResult.contents.frameCount
# print cVideoResult.contents.totalSize

# print cVideoResult.contents.relatedUrlCount
# print cVideoResult.contents.relatedUrls#.contents.strType
print cVideoResult.contents.streamCount
print cVideoResult.contents.streams.contents.strType


# http://blog.csdn.net/taiyang1987912/article/details/44779719
# http://my.oschina.net/taisha/blog/75517
# http://www.cnblogs.com/skynet/p/3372855.html
# http://www.cnblogs.com/zhangxian/articles/4586905.html
# http://blog.csdn.net/cjf_iceking/article/details/17113839
# http://blog.csdn.net/linda1000/article/details/12623527
# https://docs.python.org/3/library/ctypes.html



















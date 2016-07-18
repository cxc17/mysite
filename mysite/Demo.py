# coding: utf-8
 
from ctypes import *


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
                ('tags', c_int),

                ('streamCount', c_int),
                ('streams', POINTER(VideoInType)),

                ('relatedUrlCount', c_int),
                ('relatedUrls', POINTER(RelatedWebUrl))
                ] 

if __name__ == '__main__':
    libtest = cdll.LoadLibrary('./libSiteParser.so') 
    cVideoResult = POINTER(VideoResult)()
    url = c_char_p("http://v.qq.com/video/play.html?vid=7QQh2OVIB6k")

    print libtest.DLVideo_Parse(url, byref(cVideoResult), None, None)


    print cVideoResult.contents.streamCount
    print cVideoResult.contents.streams[0].strType
    print cVideoResult.contents.streams.contents.segCount

    libtest.DLVideo_FreeVideoResult(cVideoResult)

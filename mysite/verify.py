# coding:utf-8

# import Image,ImageEnhance,ImageFilter,sys
from PIL import Image, ImageEnhance, ImageFilter
import sys

standCode=[[[1,1,1,1,1,1,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1],
            [1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1],
            [1,1,1,1,1,1,0,0,0,0,0,0,1,1,0,0,0,0,1,1,1,1,1,1],
            [1,1,1,1,1,0,0,0,1,1,0,1,1,1,1,1,0,0,1,1,1,1,1,1],
            [1,1,0,1,0,0,0,1,1,1,1,1,1,1,1,1,0,0,1,0,1,1,1,1],
            [1,1,1,1,0,0,1,1,1,1,1,0,1,1,1,0,0,0,1,1,1,1,1,1],
            [1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1],
            [1,1,1,1,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1],
            [1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1],
            [1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1]],\

           [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
            [1,1,1,1,1,1,1,1,0,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1],
            [1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1],
            [1,1,1,1,1,1,1,0,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1],
            [1,1,1,1,1,1,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1],
            [1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1],
            [1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1],
            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]],\

           [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1],
            [1,1,1,1,1,1,0,0,0,1,1,0,1,1,0,0,0,0,1,1,1,1,1,1],
            [1,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1],
            [1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,1,0,0,1,1,1,1,1,1],
            [1,1,1,1,0,0,0,1,1,1,1,1,0,0,0,1,0,0,1,1,1,1,1,1],
            [1,1,1,1,0,0,0,1,1,1,1,0,0,0,1,1,0,0,1,1,1,1,1,1],
            [1,1,1,1,0,0,1,1,1,1,0,0,0,1,1,1,0,0,1,1,1,1,1,1],
            [1,1,1,1,0,0,0,1,1,0,0,0,1,1,1,1,0,0,1,1,1,1,1,1],
            [1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,0,0,1,1,1,1,1,1],
            [1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1]],\

            [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1],
             [1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1],
             [1,1,0,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1],
             [1,1,1,0,1,0,0,0,1,1,0,1,1,1,1,1,0,0,1,1,1,1,1,1],
             [1,1,1,1,0,0,0,1,1,0,0,0,1,1,1,1,0,0,1,1,1,1,1,1],
             [1,1,0,1,0,0,1,1,1,0,0,0,1,1,1,0,0,0,1,1,1,1,1,1],
             [1,1,1,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,1,1,1,1,1,1],
             [1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1],
             [1,1,1,1,0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,1,1,1,1,1],
             [1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]],\


            [[1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1],
             [1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1],
             [1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,1,1,1,1,1,1,1,1,1],
             [1,1,0,1,1,1,1,1,1,0,0,1,1,0,0,1,1,1,1,1,1,1,1,1],
             [1,1,1,0,1,1,1,1,0,0,1,1,1,0,0,1,1,1,1,1,1,1,1,1],
             [1,1,1,1,1,0,1,0,0,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1],
             [1,1,1,1,1,1,0,0,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1],
             [1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1],
             [1,1,1,1,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,1,1,1,1,1],
             [1,1,1,1,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1]],\

[[1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1],[1,1,1,1,1,1,1,1,1,0,0,1,1,1,0,0,0,1,1,1,1,1,1,1],[1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,1,1,1,1,1,1],[1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1,0,1,1,1,1],[1,1,1,1,0,0,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1],[1,1,1,1,0,0,1,1,0,0,1,0,1,1,1,1,0,0,1,1,1,1,1,1],[1,1,1,0,0,0,1,1,0,0,1,1,1,1,1,0,0,0,1,1,1,1,1,1],[1,1,1,1,0,0,1,1,0,0,0,1,1,1,0,0,0,1,1,1,1,1,1,1],[1,1,1,1,0,0,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1],[1,1,1,1,0,0,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1]],\
[[1,1,1,1,1,0,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1],[1,1,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1],[1,1,1,1,1,0,0,0,0,0,0,0,1,0,1,0,0,0,1,1,1,1,1,1],[1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,0,0,1,0,1,1,1,1],[1,1,1,1,0,0,0,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1],[1,1,1,1,0,0,1,1,0,0,1,1,1,0,1,0,0,0,1,1,1,1,1,1],[1,1,1,1,0,0,1,1,0,0,0,1,1,1,0,0,0,0,1,1,1,1,1,1],[1,1,1,1,0,0,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1],[1,1,1,1,0,0,0,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1],[1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]],\
[[1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],[1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,0,0,1,1,0,1,1,1],[1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1],[1,1,1,1,0,0,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1],[1,1,1,1,0,0,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1],[1,0,1,1,0,0,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1],[1,1,1,1,0,0,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1],[1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],[1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],[1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]],\
[[1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1],[1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1],[1,1,1,1,1,0,0,0,0,1,0,0,0,1,1,0,0,0,1,1,1,1,1,1],[1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,0,1,1,1,1],[1,1,1,1,0,0,0,1,0,0,0,1,1,1,1,1,0,0,1,1,1,1,1,1],[1,1,1,1,0,0,1,1,1,0,0,1,1,1,1,0,0,0,1,1,1,1,1,1],[1,1,1,1,0,0,1,1,1,0,0,0,1,1,0,0,0,0,1,1,1,1,1,1],[1,1,1,1,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1],[1,1,1,1,0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,1,1,1,1,1],[1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]],\
[[1,0,1,1,1,0,1,1,1,0,1,1,1,0,1,0,1,1,1,1,1,1,1,1],[0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1,1,1,1,1],[1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,1,1],[1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,1,1,1,0,1,1],[1,1,1,1,1,0,0,1,0,0,0,1,0,1,0,0,0,0,0,1,1,1,1,1],[1,1,1,1,0,0,1,0,1,0,0,0,1,1,0,0,0,0,1,0,1,1,1,1],[1,1,1,1,0,0,0,1,0,0,0,0,1,0,0,0,0,1,1,1,0,1,1,1],[1,1,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,1],[1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1],[1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1]]]


def searchDiff(src, index):
    sIm = Image.open(src)
    sIm = sIm.filter(ImageFilter.MedianFilter())
    enhancer = ImageEnhance.Contrast(sIm)
    sIm = enhancer.enhance(2)
    sPix = sIm.load()
    diff = 0
    token = 80
    for x in range(sIm.size[0]):
        for y in range(sIm.size[1]):
            if sPix[x, y][0] < token or sPix[x, y][1] < token or sPix[x, y][2] < token:
                if standCode[index][x][y] == 1:
                    diff = diff + 1
            else:
                if standCode[index][x][y] == 0:
                    diff = diff + 1
    return diff


def getVCode(img):
    # im = Image.open(img)
    im = img
    ret = ''
    diff = 0
    minDiff = 100
    maxDiff = 0
    value = -1
    for i in range(4):
        box = (4 + 11*i, 0, 4 + 11*i+10, 24)
        newIm = im.crop(box)
        outFile = "./tmp/%d.jpg" % i
        if newIm.mode != "RGB":
            newIm = newIm.convert("RGB")
        newIm.save(outFile)
        minDiff = 100
        maxDiff = 0
        value = -1
        for j in range(9):
            diff = searchDiff(outFile, j)
            if minDiff > diff:
                minDiff = diff
                value = j
            if diff > maxDiff:
                maxDiff = diff
        if value != -1:
            if maxDiff == minDiff:
                ret += 'X'
            else:
                ret += '%d' % value
        else:
            ret += 'X'
            pass
    return ret

if __name__ == "__main__":
    img = Image.open('CheckCode.gif')
    # img = Image.open('index.png')

    print getVCode(img)

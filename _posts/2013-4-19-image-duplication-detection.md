---
layout: post
title: "Image Duplication Detection"
category: programming
tags: [image, python]
---

In my [last post](/2013/04/event-based-html-parsing.html), I downloaded
thounsands of images from [Jiandan OOXX](http://jandan.net/ooxx). (What a cool
site!) When I was enjoying this amazing collection, I found there are many
duplicate images. I don't want my disk space wasted on duplicate images, so I
need to figure out a way to deal with them.

Detecting duplication images is totally different from detecting duplicate
normal files, because two same image may be in different formats, of different
dimensions, have different sizes. Hash values can't be relied to detect image
duplications, other image features should be taken into consideration.

First of all, I will introduce you a simple but effective method for detecting
image duplicates: [Perceptual Hash
Algorithm](http://www.ruanyifeng.com/blog/2011/07/principle_of_similar_image_search.html).
The basic idea to compute a fingerprint for each image and then compare the
fingerprints. If two fingerprints are the same or very close, the two images are
probably duplicate to each other.

I wrote a Python script to compare two image using this method (read the
reference above if you want to understand it).

{% highlight python %}
#!/usr/bin/python

import sys
from PIL import Image

def avhash(im):
    if not isinstance(im, Image.Image):
        im = Image.open(im)
    im = im.resize((8, 8), Image.ANTIALIAS).convert('L')
    avg = reduce(lambda x, y: x + y, im.getdata()) / 64.
    return reduce(lambda x, (y, z): x | (z << y),
                  enumerate(map(lambda i: 0 if i < avg else 1, im.getdata())),
                  0)

def hamming(h1, h2):
    h, d = 0, h1 ^ h2
    while d:
        h += 1
        d &= d - 1
    return h

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print "Usage: %s img1 img2" % sys.argv[0]
    else:
        img1 = sys.argv[1]
        img2 = sys.argv[2]
        hash1 = avhash(img1)
        hash2 = avhash(img2)
        dist = hamming(hash1, hash2)
        print "hash(%s) = %d\nhash(%s) = %d\nhamming distance = %d\nsimilarity = %d%%" % (img1, hash1, img2, hash2, dist, (64 - dist) * 100 / 64)
{% endhighlight %}

And I grab some pictures on the internet.

![](/image/image-dupe-samples.png)

They all have different formats, sizes and their pixels are slightly different
from each other, except `2.png` is an identical copy of `2.jpg`. The comparing
results:

{% highlight bash %}
$ ./imgcmp.py 1.jpg 2.jpg
hash(1.jpg) = 14933407633201104831
hash(2.jpg) = 14919930918911018815
hamming distance = 7
similarity = 89%

$ ./imgcmp.py 1.jpg 3.jpg
hash(1.jpg) = 14933407633201104831
hash(3.jpg) = 14933407633204774719
hamming distance = 3
similarity = 95%

$ ./imgcmp.py 2.jpg 3.jpg
hash(2.jpg) = 14919930918911018815
hash(3.jpg) = 14933407633204774719
hamming distance = 8
similarity = 87%

$ ./imgcmp.py 2.jpg 2.png
hash(2.jpg) = 14919930918911018815
hash(2.png) = 14919930918911018815
hamming distance = 0
similarity = 100%
{% endhighlight %}

Well, the results explain themselves.

Assume you have N images, firstly scan them and compute their fingerprints. If
you take 100% similarity as duplicate (which suggests duplications have
identical fingerprints), we can find all duplications in O (N) time. ([This
gist](https://gist.github.com/hzqtc/5431955) shows a possible solution.) If you
define duplication as a similarity threshold (such as 90%), finding all
duplications requires O (N * N) time (if you can improve this time bound, please
let me know).

Congratulations if you read here! You definitely have a potentiality to become
as ballache as me!

<!-- more end -->

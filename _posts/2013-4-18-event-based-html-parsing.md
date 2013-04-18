---
layout: post
title: "Event Based HTML Parsing with Python"
category: programming
tags: [html, parsing, python]
---

HTML parsing is a useful technique for crawlers. Three major techniques to parse
HTML are regular expression, tree-model based parsing and event based parsing.
Regular expression is universally applicable for all parsings, but it's tricky
and hard for other people to understand or even maintain.

Tree-model based parsing is powerful and popular, a lot of HTML/XML parsing
libraries construct an in-memory tree-like model to represent the structure of
the parsed HTML. The first drawback of this kind of parsing is obvious,
constructing tree-models in memory requires memory for the entire HTML even if
we only need a small part of it.  The second problem of tree-model based parsing
is the cost of CPU time. If a big HTML file is parsed and the in-memory model is
huge, a lot of CPU time is cost to build the model and travel in the model.

<!-- more start -->

Event based parsing is simple but efficient. The parser defines certain events
and the users implement event handles to retrieve information during parsing.
When the parsing engine encounter a start tag, a close tag and text within tags,
corresponding event handles get executed. In the event handle, context
information such as tag name, tag attributes and tag texts are all accessible.
However, information beyond the current tag such as information of the parent
tag and the children tags are not accessible.

The advantages of event based parsing are straightforward: only the information
of current tag is resident in the memory and there is no need to construct any
model.

[Python HTML Parser
Performance](http://blog.ianbicking.org/2008/03/30/python-html-parser-performance/)
provides detail performance benchmarks on parsing speed and memory usage of
different HTML parsers of Python. The results show clearly that
[HTMLParser](http://docs.python.org/2/library/htmlparser.html) (which is a
event-based parsing library for Python) has the smallest memory usage and is
also the second fastest parser.

I write a simple parser for [Jiandan OOXX](http://jandan.net/ooxx), which is a
photo gallery contributed by users, to demonstrate how to parse HTML with event
based parsers. If I want to download all photos in one of the pages, I need to
parse the HTML source file and get information of the photos such as image url
and image votes. By dig the HTML structure, we know that each photo corresponds
to a `<li>` element of `id="comment-*"`. The image's URL is the `src` attribute
of one of the `<img>` elements inside this `<li>` and the votes are the texts of
`<span>` elements of `id="cos_[un]support-*"`.

We only need to implement three event handles to retrieve the photos'
information: `handle_starttag`, `handle_endtag` and `handle_data`. We also
define two state variable: `withinPostLi` to identify whether the parsing is now
inside a `<li>` that we are interested in; `fetchData` to identify whether the
tag text is a support vote or an unsupport vote.

{% highlight python %}

class JDOOXXParser(HTMLParser.HTMLParser):

    def __init__(self):
        HTMLParser.HTMLParser.__init__(self)
        self.withinPostLi = False
        self.fetchData = None
        self.currentImage = OOXXImage()
        self.imageList = []

    def handle_starttag(self, tag, attrs):
        attrMap = dict(attrs)
        if self.withinPostLi == True:
            if tag == "img" and "class" not in attrMap and "src" in attrMap:
                self.currentImage.url = attrMap["src"]
            elif tag == "span" and "id" in attrMap and attrMap["id"].startswith("cos_support-"):
                self.fetchData = "oo"
            elif tag == "span" and "id" in attrMap and attrMap["id"].startswith("cos_unsupport-"):
                self.fetchData = "xx"

        if tag == "li" and "id" in attrMap and attrMap["id"].startswith("comment-"):
            self.withinPostLi = True

    def handle_endtag(self, tag):
        if tag == "li" and self.withinPostLi == True:
            self.withinPostLi = False
            self.imageList.append(self.currentImage)
            self.currentImage = OOXXImage()

    def handle_data(self, data):
        if self.fetchData == "oo":
            self.currentImage.oo = int(data)
            self.fetchData = None
        elif self.fetchData == "xx":
            self.currentImage.xx = int(data)
            self.fetchData = None

{% endhighlight %}

The parser takes the HTML as input and output the photos' informations. Full
parser example can be found at this
[gist](https://gist.github.com/hzqtc/5409775). An example run is:

{% highlight bash %}
$ curl -s http://jandan.net/ooxx/page-100 | ./jdooxx.py -o 50 -x 10
oo =  51, xx =   4, http://ww1.sinaimg.cn/mw600/5c9384d0jw1dn1e8ruuf7j.jpg
oo =  79, xx =   6, http://ww2.sinaimg.cn/mw600/789830acjw1dn1jt1cni0j.jpg
oo =  56, xx =   5, http://27.media.tumblr.com/tumblr_ltz6opLwd01qzs0yso1_500.jpg
{% endhighlight %}

<!-- more end -->

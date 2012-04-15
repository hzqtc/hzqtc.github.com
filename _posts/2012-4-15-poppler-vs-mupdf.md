---
layout: post
title: Poppler vs MuPDF
category: programming
tags: [pdf, poppler, mupdf]
---

I'm looking for a lightweight and fast PDF viewer recently. I tried some [Poppler](http://poppler.freedesktop.org/) based PDF viewers, but they are all very slow when opening large PDF documents. Then I found [MuPDF](http://mupdf.com/). MuPDF is a lightweight PDF library and viewer. It amazed me that it's extremly fast. I becomes interseted in finding out how faster MuPDF actually is than Poppler.

## Experiment Setup

The plan is rendering PDF pages using both libray and comparing the cost time. I use `pdfdraw-mupdf` which comes together with MuPDF package as the render program for MuPDF. I also wrote a small program to render PDF using Poppler. The program is slightly modified from an example in [cairo document](http://cairographics.org/renderpdf/). Both programs render a range of pages in a PDF file into PNG files.

The PDF file used in the experiment has more than 1500 pages. And both programs are invoked to render the following page ranges: 1-100, 101-300, 301-700, 701-1500. So 100, 200, 400, 800 different pages will be rendered each time.

## Experiment Result

Render time is simply obtain by the `time` command and measured in seconds.

{% highlight plain %}
#   poppler mupdf   p/100p  m/100p
100 13.5    8.49    13.5    8.49
200 31.21   16.88   15.61   8.44
400 59.15   30.41   14.79   7.6
800 111.03  64.23   13.88   8.03
{% endhighlight %}

![](/image/poppler_vs_mupdf.png)

The result shows that MuPDF is 95% faster than Poppler at most and 78% faster at average. Poppler uses about 14 seconds to render 100 pages while MuPDF only uses about 8 seconds.

## Conclusion

Poppler uses Cairo to save result to image files. I don't know which is the bottleneck: Poppler iteself or Cairo. Also notice that MuPDF has its own graphics library Fitz. On the other hand, MuPDF is not able to render to other formats other than image. Poppler, with cairo as backend, supports more output formats. Therefore, if you just just want a lightweight and fast PDF viewer, I think you should consider MuPDF. If you want more features, it's better to choose Poppler.

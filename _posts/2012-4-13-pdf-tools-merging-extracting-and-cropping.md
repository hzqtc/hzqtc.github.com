---
layout: post
title: "PDF Tools: Merging, Extracting and Cropping"
category: pdf
tags: [ghostscript, pdfcrop]
---

PDF manipulations such as merging, extracting and croping are the most ordinary things in eveyday life. But people feel difficult to do such jobs because of unawareness of some exordinary PDF tools. I'm gonna to introduce you a few PDF tools.

## Ghostscript

The first tool (or toolkit, more precisely) is [Ghostscript](http://www.ghostscript.com/). In Archlinux, simply use pacman to install it: `pacman -S ghostscript`.

Ghostscript is very powerful and complicated, PDF manipulation is only a small part of it. The main concept in Ghostscript toolkit is `DEVICE`, which instruct the output format. Fortunately, we need only know `pdfwrite` device to manipulate PDF.

## Merging and Extracting

The command line to merge PDF:

{% highlight bash %}
gs -sDEVICE=pdfwrite -dBATCH -dNOPAUSE -dQUIET -sOutputFile=out.pdf in1.pdf in2.pdf
{% endhighlight %}

`out.pdf` is the name of output PDF, and `inx.pdf` are input PDFs. And the command line to extract page x to page y from a PDF: 

{% highlight bash %}
gs -sDEVICE=pdfwrite -dBATCH -dNOPAUSE -dQUIET -dFirstPage=x -dLastPage=y -sOutputFile=out.pdf in.pdf
{% endhighlight %}

## Bounding Box

There is another interseting device in Ghostscipt: bbox. This device output the bounding box for each page in a PDF. The bounding box is the minium page size including all content in a page.

{% highlight bash %}
gs -sDEVICE=bbox -dBATCH -dNOPAUSE -dQUIET -dFirstPage=x -dLastPage=y in.pdf
{% endhighlight %}

## PDFCrop

The second tool is [PDFCrop](http://tug.ctan.org/pkg/pdfcrop), which is a perl script shipped within tex suites. It's different from [another PDFCrop](http://pdfcrop.sourceforge.net/). PDFCrop can cut the whitespace edge in PDF pages automatically. In default, PDFCrop use Ghostscript bbox device to determine the bounding box for each page and crop that page using the detected bounding box. However, it's possible to specify a bounding box for all pages instead of detect it every page. You may also set different bounding box for odd and even pages or add margins to each page. For more usage information, refer to `pdfcrop --help`.

## Cropping

To crop a PDF with PDFCrop:

{% highlight bash %}
pdfcrop original.pdf cropped.pdf
{% endhighlight %}

But there is a new problem: the cropped PDF has a different pagesize compared to the original one. We should resize the cropped PDF to its original pagesize. This is easy with Ghostscript:

{% highlight bash %}
gs -sDEVICE=pdfwrite -dBATCH -dNOPAUSE -dQUIET -sPAPERSIZE=a4 -dPDFFitPage -sOutputFile=resized.pdf cropped.pdf
{% endhighlight %}

In the above example, the pagesize of original PDF is assumed to A4. And the `-dPDFFitPage` option make sure the cropped PDF is resized instead of expanded.

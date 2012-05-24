---
layout: post
title: Play MP3 with libmpg123 and libao
category: programming
tags: [mp3, audio, libmpg123, libao]
---

I'm rewriting some of my python applications using C. One of them plays online mp3 audio. I used gstreamer to play mp3 and I'm considering switching to a more lightweight solution. Finally, I choose [libmpg123](http://www.mpg123.de/) and [libao](http://xiph.org/ao/). Libmpg123 is used to decode mp3 and libao is then used to make the sound.

![](/image/mp3.png)

Well, the coding part is rather easy. Initialize, allocate some resources, decode some bytes, play the decoded bytes, keep decoding until all done, clean up and shut down. The following sample code shows how to play a mp3 file give in commnd line arguments with libmpg123 and libao.

{% highlight c %}
#include <ao/ao.h>
#include <mpg123.h>

#define BITS 8

int main(int argc, char *argv[])
{
    mpg123_handle *mh;
    unsigned char *buffer;
    size_t buffer_size;
    size_t done;
    int err;

    int driver;
    ao_device *dev;

    ao_sample_format format;
    int channels, encoding;
    long rate;

    if(argc < 2)
        exit(0);

    /* initializations */
    ao_initialize();
    driver = ao_default_driver_id();
    mpg123_init();
    mh = mpg123_new(NULL, &err);
    buffer_size = mpg123_outblock(mh);
    buffer = (unsigned char*) malloc(buffer_size * sizeof(unsigned char));

    /* open the file and get the decoding format */
    mpg123_open(mh, argv[1]);
    mpg123_getformat(mh, &rate, &channels, &encoding);

    /* set the output format and open the output device */
    format.bits = mpg123_encsize(encoding) * BITS;
    format.rate = rate;
    format.channels = channels;
    format.byte_format = AO_FMT_NATIVE;
    format.matrix = 0;
    dev = ao_open_live(driver, &format, NULL);

    /* decode and play */
    while (mpg123_read(mh, buffer, buffer_size, &done) == MPG123_OK)
        ao_play(dev, buffer, done);

    /* clean up */
    free(buffer);
    ao_close(dev);
    mpg123_close(mh);
    mpg123_delete(mh);
    mpg123_exit();
    ao_shutdown();

    return 0;
}
{% endhighlight %}

Save the code as *play.c* and build it. Remember you must first install `libmpg123` and `libao`.

{% highlight bash %}
gcc -O2 -o play play.c -lmpg123 -lao
{% endhighlight %}

Run the programm with a mp3 file path in command line.

{% highlight bash %}
./play /path/to/file.mp3
{% endhighlight %}


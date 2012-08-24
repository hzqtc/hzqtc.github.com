---
layout: post
title: Play MP3 with libmpg123 and libao
category: programming
tags: [mp3, audio, libmpg123, libao]
---

I'm rewriting some of my python applications using C. One of them plays online mp3 audio. I used gstreamer to play mp3 and I'm considering switching to a more lightweight solution. Finally, I choose [libmpg123](http://www.mpg123.de/) and [libao](http://xiph.org/ao/). Libmpg123 is used to decode mp3 and libao is then used to make the sound.

<!-- more start -->

![](/image/mp3.png)

## Play local files

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

## Play URLs

It's a little complicated to play HTTP URLs because you can't pass a URL directly to `mpg123_open`. We should use `mpg123_open_feed` instead. We also use `libcurl` to read HTTP URLs and feed the received data for decoding using `mpg123_feed`. Then we use `mpg123_decode_frame` to try to decode a audio frame. Based on the return value of `mpg123_decode_frame`, we are able to decide the following situations: a frame is successfuly decoded, a new decoding format is encountered or more data is required.

{% highlight c %}
#include <curl/curl.h>
#include <mpg123.h>
#include <ao/ao.h>

#define BITS 8

mpg123_handle *mh = NULL;
ao_device *dev = NULL;

size_t play_stream(void *buffer, size_t size, size_t nmemb, void *userp)
{
    int err;
    off_t frame_offset;
    unsigned char *audio;
    size_t done;
    ao_sample_format format;
    int channels, encoding;
    long rate;

    mpg123_feed(mh, (const unsigned char*) buffer, size * nmemb);
    do {
        err = mpg123_decode_frame(mh, &frame_offset, &audio, &done);
        switch(err) {
            case MPG123_NEW_FORMAT:
                mpg123_getformat(mh, &rate, &channels, &encoding);
                format.bits = mpg123_encsize(encoding) * BITS;
                format.rate = rate;
                format.channels = channels;
                format.byte_format = AO_FMT_NATIVE;
                format.matrix = 0;
                dev = ao_open_live(ao_default_driver_id(), &format, NULL);
                break;
            case MPG123_OK:
                ao_play(dev, audio, done);
                break;
            case MPG123_NEED_MORE:
                break;
            default:
                break;
        }
    } while(done > 0);

    return size * nmemb;
}

int main(int argc, char *argv[])
{
    if(argc < 2)
        return 0;

    ao_initialize();
    
    mpg123_init();
    mh = mpg123_new(NULL, NULL);
    mpg123_open_feed(mh);

    CURL *curl = curl_easy_init();
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, play_stream);
    curl_easy_setopt(curl, CURLOPT_URL, argv[1]);
    curl_easy_perform(curl);
    curl_easy_cleanup(curl);

    mpg123_close(mh);
    mpg123_delete(mh);
    mpg123_exit();

    ao_close(dev);
    ao_shutdown();

    return 0;
}
{% endhighlight %}

Save the code as *playurl.c* and build it. Remember you must first install `libmpg123` `libao` and `libcurl`.

{% highlight bash %}
gcc -O2 -o playurl playurl.c -lmpg123 -lao -lcurl
{% endhighlight %}

Run the programm with a mp3 url in command line.

{% highlight bash %}
./playurl http://url.to/file.mp3
{% endhighlight %}

We use `libcurl` to open URL and `play_stream` is called to process the downloaded buffer. The major difference between local file version and URL version is we use different decoding interface. **Notice the `do...while` loop in `play_stream`, it can't be omitted because a piece of downloaded buffer may contains several frames to be decoded.**

<!-- more end -->

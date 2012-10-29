---
layout: post
title: "Mac Start Guide for Linuxers"
category: workspace
tags: [mac, linux]
---

I just got a late 2009 Macbook Air and I have been using it for a month. As an advanced Linux user, I found Mac OS X is very easy to use with the powerful unix command line tools. As a GUI user, I think Mac provide a consistent and decent user interface. I recommand all Linux users who is exhausted with the Linux desktops to give it a try. Here I want to give the Linuxers a start guide to Mac OS X.

<!-- more start -->

## Command Line Tools

I put command line tools first because Mac provides most Unix command line tools so Linux users can easily get adapted. But some tools in Mac is a little different, for example, `ls` support `-@` switch to display extended file attributes. You may also install original GNU `coreutils` with [Homebrew](http://mxcl.github.com/homebrew/). Homebrew is just like `makepkg` in Archlinux: ruby scripts contain instructions on building from source code and installing packags. Hundreds of tools and libraries you are familiar with in Linux can be found in Homebrew. It's a must-have tool for advanced users.

Sharing the POSIX standard, it's also very easy to get you programs written for Linux to work on Mac. In most cases, you do not need to change a single line of code, just rebuild and everything works just fine. Of course, I'm referring to command line programs since Mac has a very different GUI interface from GTK or QT in Linux.

## Applications

The first thing to mention is that to install an application in Mac is as easy as draging the icon to the `Application` folder. The application in Mac is just a `*.app` directory with all files and metafiles bundled inside. To uninstall an applicaton you just simply delete it. I'm going to list some application I'm using on Mac as well as their alternatives I use in Linux.

### Terminal vs. Xfce-terminal

The Mac built-in Terminal is a full-featured terminal emulator. It also has tabs, detects unfinished jobs on closing and shows current command in title. I think it's better than Xfce-terminal which I use in Linux.

### MacVim vs. GVim

MacVim is Vim with native Mac GUI, it's identical to GVim in Linux. All plugins and configurations work fine.

### Finder vs. Thunar

Finder is the file browser for Mac. Finder absolutely provides a better user interface than Linux file managers such as Thunar. By the way, Finder is also the only Application that you can't *Quit*.

### Firefox vs. Firefox

Nothing much to say, Firefox (with Vimperator) is my favourite browser and the only browser I use. Although Firefox uses too much memory in Mac, I would not switch to any other browsers until they got the same power as Vimperator.

### Transmission vs. Transmission-daemon

Transmission for Mac has a very elegant UI and it's a simple but powerful BT client. I use Transmission-daemon, which only has command line interface, in Linux.

### iChat vs. Pidgin

iChat is also Mac built-in. It supports less protocols than Pidgin but I wouldn't care because I only use Gtalk (Jabber).

### Mplayerx vs. Mplayer

Another identical application with native UI, works as well as in Linux.

### Preview vs. Mupdf

Another Mac built-in, full-featured image/pdf viewer. Mupdf can hardly be called as a pdf viewer, I think it's just a pdf displayer.

### Mpd vs. Mpd

iTunes sucks and I only use it to sync music to my iPod. I use Mpd on both Mac and Linux, it's extremely resource-saving and very suited to me since my MBA has only 2GB memory. I use Homebrew to install it: `brew install mpd mpc`. However, I can't find a good Mac client for Mpd. So I'm going to build one by myself.

Quite a lot of applications are the same or just a variant, thanks for these great cross-platform applications.

## Desktop Experience

Mac OS X provide a very easy-to-use GUI. The shortcuts for all applications are consistent, for example, `⌘-W` closes current window and `⌘-Q` quits current application. The global menubar is also the statusbar. Mac also provide multiple workspaces, switching between them using trackpad is cool. Full-screen applications will automatically takes an individual workspace. And the scrolling in Mac is smoothed with trackpad. Trackpad is amazing.

The widgets are beautiful and consistent, too. As far as I can see, the same application looks far more beautiful in Mac than in Linux.

<!-- more end -->

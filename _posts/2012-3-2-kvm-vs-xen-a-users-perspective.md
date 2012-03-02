---
layout: post
title: "KVM vs. XEN: A User's Perspective"
category: virtualization
tags: [kvm, xen]
---

I had been using [XEN](http://xen.org/) for more than a year but I turned to [KVM](http://www.linux-kvm.org/) recently. I use XEN and KVM only because I'm studying SR-IOV, a hypervisor-independent I/O virtualization techonology. I'm not a XEN or KVM hacker, I' just a **end-user**. I want to explain why I turned to KVM and compare the two open source hypervisors from a user's perspective.

## Basic Knowledge

XEN provides support to both para-virtualization and full-virtualization. Para-virtualization means the guest OS is modified so it's aware of running in a virtualized environment. On the contrast is full-virtualization which runs original guest OSes. But hardware suppot (Intel VT-x or AMD SVM) is required for full-virtulization so it's also called Hardware Virtual Machine (HVM). It's obvious that HVM is more convenient because it's transparent for users of the guest OS. In fact, the suitable situation for para-virtualization is quite limited.

KVM only works with HVMs.

## Runtime

KVM is simply a Linux kernel module and by inserting this module the Linux kernel is converted into a hypervisor. Guest OSes are the same as normal user processes on the host. Linux scheduler and memory management is inherited. All devices of the guests are emulated by a modified QEMU. [Virtio](http://www.linux-kvm.org/page/Virtio) is a para-virtualization I/O technology for Linux guest, which improves I/O performance significantly. Virtio includes a few driver modules for the guest.

XEN is much more complicated. XEN hypervisor runs on the hardware itself and guests are called domains. There is a special domain named "domain 0" which is the privileged domain. Domain 0 is always started when XEN starts. Domain 0 can be any Linux distribution with a XEN modified kernel.

## Type I or Type II

As you may know, hypervisors are devided into two types: type I and type II. A tpye I hypervisor runs on host hardware directly while a type II hypervisor runs as a part of a OS. XEN is obvious type I and Virtualbox is a typical example for type II. What about KVM? Some people say KVM is type II. Even the [Wikipedia](http://en.wikipedia.org/wiki/Hypervisor#Classification) says so. But I think KVM is type II because Linux kernel is converted into a hypervisor with KVM module. This hypervisor does run directly on host hardware.

## Install

KVM is very easy to install, it comes with the Linux kernel. The only "install thing" is to install a modified QEMU, usually a package named `qemu-kvm`.

XEN is much more harder. First of all, you need to install a Linux distribution. Then you should install xen and domain 0 kernel, so your Linux distribution is turned to domain 0. Trust me it's not as easy as it seems to be, especially when you are compiling from source.

## Performance

According to my experience, KVM and XEN HVM are almost equal on performance (CPU/Mem/IO). Detail data and figures are beyond this post.

## So Why KVM?

All I said above can be concluded in one line: *KVM is mush easier to use and the performance is as good as XEN*.


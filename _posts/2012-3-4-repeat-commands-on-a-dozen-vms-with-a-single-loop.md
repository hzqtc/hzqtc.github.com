---
layout: post
title: Repeat Commands on a Dozen VMs with a Single Loop
category: utility
tags: [ssh]
---

When I was playing with a dozen of identical VirtualMachines, I always need to repeat some commands on each of them. This is painful: open VNC (or SSH) of the VM, type some long and boring commands and repeat the same thing on another VM. Then I figure out a way to avoid repeat. Everybody hates *REPEAT*, right?

First of all, all these VMs must be able to connected via SSH. If you have problem on SSH to VMs, you need to setup a network bridge (refer to [my previous post](/2012/02/kvm-network-bridging.html) for more detail).

Next, copy your public key to each VM (If you don't have a public key yet, generate it with `ssh-keygen`). This step is necessary to login on VMs without typing a password. Assume there are ten VMs and their IP address are `192.168.1.10` to `192.168.1.19`. Run the following commands on the host:

{% highlight bash %}
for i in `seq 0 9`
do
    ssh-copy-id user@192.168.1.1$i
done
{% endhighlight %}

You will be asked for password for each VM only once. And it's time for a rest, let's review SSH. I don't know how many people know that `ssh` can has a optional `command` field. At least I didn't know it just a moment ago.

{% highlight bash %}
ssh [user@]hostname [command]
{% endhighlight %}

When `command` field is specified, it is executed on the remote host instead of a login shell. Repeating commands on all VMs will be as simple as write a loop. A typical example is restart httpd on all VMs and display status of httpd:

{% highlight bash %}
for i in `seq 0 9`
do
    echo "Processing VM$i"
    ssh user@192.168.1.1$i "rc.d restart httpd; rc.d list httpd"
done
{% endhighlight %}

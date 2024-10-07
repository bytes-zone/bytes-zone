+++
title = "CRDTs for tinyping"
date = 2024-10-07
+++

When I've been thinking about sync for tinyping, I've been using off-the-shelf CRDTs (mostly Automerge.) But thinking about it from very simple principles, I don't need all that. Tinyping can be broken down to:

1. A log of timestamps
2. Tags and other data for those timestamps
3. A few settings (like the lambda value for calculating the offsets.)

I think we can sync that data with:

1. A grow-only set for the timestamps (you never delete them, and they're implicitly sortable)
2. Last-write-wins registers for timestamps and extra data.
3. Last-write-wins registers for settings

<!-- more -->

That depends on being able to reliably say what the "last" write is, of course. I think a [hybrid logical clock](https://jaredforsyth.com/posts/hybrid-logical-clocks/) might be the right approach here.

The only thing I'm not really sure about is how to do syncing. Do we keep the latest clock of each node that we've seen on each device and then ask each other for operations newer than that? That seems like it'd be pretty straightforward, but I don't know if there are things I'm not considering here.

Anyway, I'm going to give it a try and report back!

+++
title = "getting back off the CI train"
description = "hosted services are sometimes OK, I guess"
date = 2024-02-20

[extra]
project = "thing-a-month (meta)"
+++

I got Woodpecker working, but the first job I did (a `nix build`) totally froze up the whole cluster for like an hour and a half, and didn't even complete successfully. Pretty yikes. Looking at this realistically, I don't want to buy the size nodes that I would need to do this properly, so it probably makes sense for me to use a hosted service (probably just a free one!) If I had a bunch of money to throw at this problem, though, I'd probably use Woodpecker. It was pretty nice!

<!-- more -->

After doing some investigation, it looks like I'm going to end up on GitHub actions for now. I don't *love* that—part of the reason I started self-hosting my own stuff was to get away from GitHub, but the price is right and it enables me to get going on things that I care about more than fiddling with CI runners.

Tradeoffs, as always: if I don't want to run my own thing, I have to put up with what someone else is willing to run. That seems annoying, but fine.

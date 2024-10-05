+++
title = "doing in a day what I could not in 6 months"
date = 2024-10-04
+++

I've been working on tinyping for quite a while now, in various forms. Six or seven months, in fact. I feel frustrated that I don't have anything usable to show for it. When I stopped doing thing-a-month, [I wrote](@/micro/stopping-thing-a-month.md):

> it turns out I'm pretty good at planning projects like this, but when I have such limited free time it's way too easy to overcommit.

That's still true! And unfortunately, removing the constraint of a month did not help. I have spent more time figuring out the local-first ecosystem than actually building something useful, and it's really starting to annoy me.[^1]

So I wonder: what do the ideas in tinyping look like I have to build them in an hour? A day? What does a different version of extreme constraint look like?

<!-- more -->

So I'm going to try that. A successful solution should:

- Notify someone that a new ping is ready to answer (but not tell them when the next one will be coming.)
- Let them assign a single tag to a ping (and optionally additional information like energy level)
- Make sure the distribution of pings is correct (`math.log(random.random()) / lambda * -1`)

Ideally, this should all happen in a stable way (e.g. reliably setting the next ping with PCR instead of using system randomness) but it's fine if it doesn't.

Just to prove I could do it quickly, I spent a little time (maybe two, three hours?) making a barebones version in Rust that just does the core part of the collection loop, nothing more. It lives at https://github.com/bytes-zone/beeps. You can download the binaries and try it, if you like (it always tries to invoke `say`, so the Windows and Linux binaries are a slight lie; get in touch if it matters to you.)

+++
title = "bold"
description = "a remote-first build system"
date = 2022-12-14

[extra]
when = "now"
+++

An attempt to get some of the things that interest me about large-scale monorepo build systems like [Bazel](https://bazel.build/) or [Buck](https://buck.build/), but without the learning curve or large footprint.
The main benefits I want are that Bold will run builds remotely by default, and all builds contribute to the cache.
It will be able to build locally too, of course, by running a local build node (local execution takes care of this for you, though)

This forces some decisions and tradeoffs:

- **tradeoff:** you have to trust all builders to produce valid outputs, and all clients to not submit malicious jobs
  - this is not super different from normal open-source CI situations, though, and in private code you already have to have a trust layer (e.g. a hiring process.)
- **tradeoff:** this makes incremental compilation harder. Where does the compilation cache live?
  - this might only seem bad and be fine in practice. We'll have to see.
  - workaround: in some cases, you may be able to pre-build and cache dependencies. If life gets especially hard, you could separate a large program into several compilation units and cache those (e.g. packages in whatever language you're using.)
- **implication:** if builds are remote by default, we need to share and cache files efficiently. A content-addressable store is reasonably easy to understand and implement, so we've got one of those.

There are more of these yet to come, I'm sure!

Bold is nowhere near ready to show off yet.
Watch this space!

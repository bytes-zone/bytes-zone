+++
title = "Local-First From Scratch, part 1"
date = 2024-12-17

[extra]
project = "Local-First From Scratch"
+++

Since around Thanksgiving, I've been working on the draft of a book I'm tentatively calling "Local-First from Scratch." The idea is basically to write [tinyping](@/projects/tinyping.md), but do it in book form.

<!-- more -->

One thing I had to decide right away was whether this would use some off-the-shell local-first library or if I was going to explain and implement everything from first principles. I chose the latter, which I think will make for a more interesting read, and has a nice side benefit that it doesn't tie the book to the libraries and frameworks that are popular (or exist!) today. Hopefully that will mean that it stays pretty evergreen!

This choice has also made me dive deeply into the theory behind CRDTs. I've found a lot of things that I just misunderstood on previous learning expeditions, just by following the little voice in my head that says "hey… is that right, actually?" I want to get things right so that I'm not misleading people, and that turns out to be a pretty powerful motivator for learning!

I hope that I can ship a first beta version to a small group of readers in the first couple of months of 2025. If you're interested, please get in touch!

Here's a basic outline:

1. **Introduction:** a similar pitch to what I just wrote above, but less meta.
2. **Foundations:** what we're building, why local-first, and what are CRDTs?
3. **Breaking Ground:** Implementing some basic CRDTs (and logical clocks)
4. **Building an App:** Modeling the data in our app based on the building blocks we just implemented.
5. **First Client:** Building a TUI to be able to use the app model we just made.
6. **Synchronization:** Building a server to synchronize data between replicas.
7. **Second Client:** Building a browser-based client using the same codebase and sync server, and extending the app model to support time reporting.
8. **Sync Revisited:** Making the sync protocol way more efficient by only sending the parts of the data that have changed.
9. **Conclusion:** What we've learned, what we could do next, and where to go from here.
9. **Appendix, Sequence CRDTs:** Extending our CRDT building blocks to support sequences.

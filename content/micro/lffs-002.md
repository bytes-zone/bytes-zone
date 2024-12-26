+++
title = "LFFS: Simplicity vs Efficiency"
date = 2024-12-26

[extra]
project = "Local-First From Scratch"
+++

I knew it was gonna happen, just knew it: I finally hit the first part of writing [the book](@/projects/local-first-from-scratch.md) where I have to make a choice between something being easy to describe and understand up front vs long-term efficiency or flexibility.

Let me explain.

<!-- more -->

When you have a state-based CRDT, you have a `merge` operation. The details don't _really_ matter for this explanation, but basically if `merge` is commutative, idempotent, and associative, you can make use it for a CRDT and syncing state is as simple as:

1. Exchanging states with a peer.
2. Both sides call `merge` to get the final state.

With a few more supporting details, that's easy to understand and explain! (Even easier because in the book the only peer is a sync server.)

However this sync protocol gives up efficiency for that simplicity: you have to send all the data back and forth over the network. _Most_ of the time, you're gonna be sending a bunch of duplicate data with a few changes, which means you're actually sending all the data _twice_.

You can improve efficiency by sending only the things that changed: if I've got a grow-only set, and I add `1` to it, I only send `1` to my peer. In fact, you can keep track of all the tiny pieces of data as separate instances of the CRDT, and only send the ones you care about. For example, the set `{1, 2, 3}` and the sets `{1}`, `{2}`, and `{3}` (when merged) represent the same data.

This implies that `merge` can be inverted. We'll call that operation `split`. Like `merge`, it needs to have a couple of properties:

1. `split` should produce irreducible CRDTs.
2. `merge`ing the results of `split` should give you the original state.

The literature I've read claims that you can `split` all CRDTs, and I haven't found any counterexamples yet!

That lets us be even more efficient. Our sync protocol can look like this:

1. Keep track of the changes you make but haven't sent to each peer, either as a single instance of the CRDT or as a list of `split` results.
2. Send only those changes during sync. (But `merge` them before sending, because that usually reduces the total byte size.)
3. When you receive changes, `split` what you get and remove any parts that you already knew about.
4. Add any new parts to the list of changes you send on to other peers (but not the peer you got them from.)

[Vitor Enes et al have a paper and blog post on this sync protocol if you want more details](https://vitorenes.org/post/2019/04/efficient-sync/).

Anyway, it seems like these protocols would be pretty easy to build up to (since `split` is just exposing a specific way of thinking about `merge`.) I'm having a hard time, though, because I need a way to store the CRDT bits earlier than I want to put the syncing details. Although, I suppose I could:

1. Store the whole replica state as a JSON blob locally.
2. Introduce the sync server and introduce `split` to deal with storage in Postgres there.
3. Implement the first sync protocol as a full state sync.
4. Improve to delta-state sync from there.

Might work, might not. I guess we'll see!

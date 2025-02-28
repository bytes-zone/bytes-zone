+++
title = "a dilemma, or is it a conundrum? Maybe it's a dilendrum!"
date = 2025-02-27

[extra]
project = "Local-First From Scratch"
+++

So I thought I had a pretty good thing going: in my last post, I documented some [early results from the time-tracking software that I wrote for _Local-First From Scratch_](@/micro/lffs-005.md). I thought I was on track for an easy conversion to prose, then an easy beta-reading, then becoming a thousandaire and retiring to my ~~private island~~ couch to drink a budget mojito or whatever.

But then… I committed to giving a talk to a local meetup group about implementing CRDTs in Rust.

"Simple!", I thought, "I can just apply the stuff I've already written to a new domain and it'll all work out."

Well… no, not so much.

<!-- more -->

It turns out that the time tracker, while valuable, can be represented almost entirely with extremely simple CRDTs. I think a last-write-wins register based on a hybrid logical clock is the most complex thing you need. That's not exactly CRDTs 101… but, it is like CRDTs 102.

This is not necessarily a bad thing, of course: it doesn't make the time tracker any less valuable _as software I use_, but it does mean that if you learn just enough to make it, then you have not learned enough to make something that acts like a normal CRUD app with records. Whoops! If I stop there, the book will not generalize to the problems that the reader actually might have to work through.

In this meetup talk, I found this out because I thought through implementing [TodoMVC](https://todomvc.com/) (really the table stakes of client-side CRUD apps.) This is specifically because in addition to completing or editing the description of todos, we can also archive completed todos from a key-value map.

If you know anything about CRDTs, you may have just gone "ahhh, Brian, I see your problem." If you don't, here's the deal: in order to store key removals efficiently, you have to store set removals efficiently (because the keys of a map are a set.) In order to store set removals efficiently, you need to use what some folks call an Observed Remove Set Without Tombstones (ORSWOT.) As the name implies, it doesn't store tombstones—which most other add/remove sets do!

Implementing an ORSWOT is not hard, _per se_, but it requires explaining a lot more of the mechanics of CRDTs than I had planned to in the book. In particular, now I need to explain vector clocks, dot context, dot kernels, etc.

Again, none of these are hard on their own, but taken together it's a lot of work that I haven't needed to do for the book as it's written so far.

So that leaves me needing a slightly more complex example for the book. And, I don't know… is TodoMVC interesting enough as an example to hold people's attention? Or, worse: does the fact that so much is required to make TodoMVC into a local-first syncable app mean that I'm implicitly telling folks "this seemingly-simple thing is actually super complex. Abandon hope, all ye who enter here."?

I think the way to thread the needle might be to make an app that's _nominally_ more complex than TodoMVC, but not so much as to make the implementation become unmanageable in the prose. Just something to say "oh yeah it's not so simple as TodoMVC… just a little more complex so we can see the full power of this thing." Maybe having projects as well as todos? Or dependencies? Or making a contact app with various forms of contact information? Or something else entirely?

I'm not sure yet. I'm leaning towards TodoMVC + some wrinkle, but if you have an opinion, then please email me. I'd love to hear it.

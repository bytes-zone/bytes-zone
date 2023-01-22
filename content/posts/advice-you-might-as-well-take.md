+++
title = "advice you might as well take"
date = 2023-01-22
description = "PAGNI, the opposite of YANGI"
+++

I've read some nice articles recently which I can sum up as “advice you might as well take.” This is stuff that's good to consider at the beginning of a project, or when you're about to add a feature to some existing software.

These articles run counter to YAGNI (You Ain't Gonna Need It), the software design principle that says you should only ever add things you'll be using right away. Many even call this out in their titles! One even addresses this by coining an alternative term, PAGNI (Probably Are Gonna Need It), so let's start with that one:

## PAGNIs: Probably Are Gonna Need Its
[PAGNIs - Probably Are Gonna Need Its](https://simonwillison.net/2021/Jul/1/pagnis/) by Simon Wilson. Makes a good rule for when to allow complexity in advance:

> When should you over-ride YAGNI? When the cost of adding something later is so dramatically expensive compared with the cost of adding it early on that it’s worth taking the risk. On when you know from experience that an initial investment will pay off many times over.

His PAGNIs: make kill-switches for mobile apps to force upgrades or contain security issues, have automated deployments and continuous integration, build pagination, and keep detailed API logs, including POST bodies.

## Preemptive Pluralization is Probably Not Evil
[Preemptive Pluralization is Probably Not Evil](https://www.swyx.io/preemptive-pluralization) by swyx. Summed up by this quote:

> **Before you write any code — ask if you could ever possibly want multiple kinds of the thing you are coding.** If yes, just do it. Now, not later.

Basically, if:

- it's a lot of effort to go from being able to handle zero things to being able to handle one thing
- AND, it's a similar amount of effort to go from one to many

Then it probably makes sense to go directly from zero to many if you think that'll ever be needed.

There's also [some interesting discussion on the C2 wiki](http://wiki.c2.com/?ZeroOneInfinityRule), including some times when it's good to avoid this.

Out of these pieces of advice, this is the one I've used the most. However, I'd recommend modeling out your system with something like [Alloy](@/posts/alloy.md) first and seeing what that gets you!

## You Might as Well Timestamp It
[You might as well timestamp it](https://changelog.com/posts/you-might-as-well-timestamp-it) by Jerod Santo. Summary: if you store boolean fields as nullable timestamps, then you have basically the same semantics but get the ability to say when the value went to “true” for free.

You do use a little more disk space, but not much, so you'll have to decide whether that's worth it. (At least in PostgreSQL, booleans are 1 byte while a timestamp is 8.) However, I would imagine that's fine for most uses.

## Probably Are Gonna Need It: Application Security Edition
[Probably Are Gonna Need It - Application Security Edition](https://jacobian.org/2021/jul/8/appsec-pagnis/) by Jacob Kaplan-Moss. Inspired by Simon Wilson's PAGNI post, but focused on security. There's too much good stuff in here to summarize, but some highlights for me were to always consider the “abusive ex” persona when you're designing your app and his thoughts on security admin interfaces.

## Summing Up
These articles show a ton of cases where it's worth breaking YAGNI. I appreciate this because, at a higher level, I think that oversimplifying our mental model of the software we're building can risk failure just as much as overcomplexity can. Even worse, by oversimplifying we can harm the people who use our software by failing to consider their safety as we're building (e.g. the “abusive ex” persona.)

I want to close with a quote I really love from Hillel Wayne's [Reject Simplicity, Embrace Complexity](https://buttondown.email/hillelwayne/archive/reject-simplicity-embrace-complexity/):

> Simplicity is good. We should write simple code. But complexity is _unavoidable_. We do a disservice to ourselves by pretending that any software can be simple _if we just try hard enough_. Instead, we should study the factors that lead to complex software. That way we can learn how to recognize, predict, and manage complexity in our systems. And then we can seek simplicity within that context. It won’t give us simple software, but it will help us write _simpler_ software. Nuance is better than mantras.
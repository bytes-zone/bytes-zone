+++
title = "tinyping and scrub moves"
date = 2024-05-13

[extra]
project = "tinyping"
+++

I spent this week doing two things:

- Working on design for tinyping
- Wondering if I'm playing scrub games by developing this idea

Let's take them in turn:

<!-- more -->

## Design for TinyPing

As far as design is concerned, I think I have two basic jobs-to-be-done with the app: trying to discover how you're spending your time, or trying to change the same. The design challenge comes in when you factor in that you can't actually _do_ those things until you've collected enough data, which takes at least a week of consistent data entry.

My basic idea to solve this is to show useful information as soon as I can—but that still might be too slow, so I might have to show un-useful information sooner. For this purpose:

- **Useful information** means being able to say things like "recently, you spent much more time on `meetings`. Do you want to dig into that?"
- **Un-useful information** might be more like "you've entered 23 pings"—there's really no insight about how to live your life there, but we can present it right away.

I might also be able to show locked versions of the more useful report types on a dashboard so that it's clear that entering more pings will unlock more stuff. I think that'd be pretty helpful, but I need to tune when it would be useful to unlock each report type!

## Scrub Moves

The meta-thing here is that I'm wondering if I'm making a scrub move by spending my time on tinyping at all. I'm not talking about TLC's version of a scrub here, but the one introduced in [_Are You Playing to Play, or Playing to Win?_ by Cedric Chin](https://commoncog.com/playing-to-play-playing-to-win/). Basically: a scrub plays a game according to their own stricter ruleset and complains about others winning in "cheap" ways that don't fit their ideal.

The specific thing that gives me doubt here is that tinyping, as an idea, is more useful to individuals instead of businesses. That might make it difficult for it to make enough income to justify ongoing development: in general, individuals are less willing to pay and churn more easily, especially if their financial situation changes. This is well-known and shows up often on lists of beginner business mistakes you should avoid—but here I am working on something that falls exactly in that category!

The thing that could move this from "beginner mistake" to "scrub move" is that I've been justifying continuing to work on it "because I want it to exist." That's fine if _if it works_, but if tinyping immediately has high costs to run or is not useful at all, then I'm wasting a lot of time building it.

Then why am I continuing? Because I think there are two ways to avoid being a scrub despite the appearance of scrubbiness:

1. improve at the game despite your restricted rules
2. don't complain if you lose

My hedge against the first is that I'm working on transferable skills while building tinyping. For example, [elm-duet](@/projects/elm-duet.md) is useful for projects outside this one. I'm also thinking hard about how to design a tricky interaction, which I hope leads to some wisdom about how to solve cart-before-the-horse product design problems in general.

Against the second, I suppose I've just got to have a good attitude, or not worry too much if tinyping doesn't take off as a product. (Although that's not far off from "commit less" which could also sink it!)

At any rate, I'm going to continue down the path of trying to make this work this week. It's likely to be another low-code week because I'll be working on design, but I'd rather spend a couple weeks on planning then waste them on implementing the wrong things!

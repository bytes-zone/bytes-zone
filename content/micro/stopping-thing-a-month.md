+++
title = "Stopping thing-a-month"
date = 2024-05-06

[extra]
project = "thing-a-month"
+++

I'm going to have to stop doing thing-a-month. I really love it as an idea, but it's not working out so well for me:

- it turns out I'm pretty good at planning projects like this, but when I have such limited free time it's way too easy to overcommit.
- trying to figure out how to build a business around a tiny idea in a month is a bit much.
- doing that *and writing about it* is even more work.

Taken together, it basically means I'm overcommitting, then having to be accountable for it in public. Not a great combination for me mentally; I'm avoiding building things that I want and that I think sound fun to make!

So something's gotta change.

<!-- more -->

Instead, I think I'm going to drop the thing-a-month commitment and instead commit to writing weekly updates here. I've noticed it's better for me to be able to commit to steady progress than big epic effort. (That's probably true of a lot of people, but I think we're conditioned by storytelling to think that the epic efforts are the better choice.)

Anyway.

Here's what I've been working on:

- I really love the idea of tinyping and I'd like it to exist in some form in the world.
  - As a reminder, there are a few apps that do this already (see a list at [Beeminder's page about this](https://doc.beeminder.com/tagtime)) but none of them sync the data anywhere, making it harder to get pings during the time when you're doing what you're doing. In the interests of making the data entry easier, I'm trying to solve this problem by using [automerge](https://automerge.org/) as the storage layer (which also makes it local-first software!)
- Because of some trouble I had keeping types straight between Elm and TypeScript (as well as similar pains I had at work) I started making something I'm calling elm-duet. It accepts an interop schema using [JSON Type Definitions](https://jsontypedef.com/) and generates both the Elm and TypeScript code. I spent most of April working on this, and it's almost ready for release. It has some ergonomic issues in the generated code, but it's definitely a step up already.

The plan going into this week is to (re)write the README for elm-duet and get that released. It's not the most polished piece of software yet, but I think it's worth getting out there as an idea. We'll see where we end up next Monday!

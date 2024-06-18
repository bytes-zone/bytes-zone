+++
title = "The Value of a Model is More Making than Having"
date = 2023-01-09

[extra]
project = "learning Alloy"
+++

After making a bunch of models in [Alloy](@/posts/alloy.md), I'm curious if formal modeling is more useful as a thing to do (a process) or a thing to create (an artifact.)

## Making / Process

On the modeling-as-a-process side, I've had good luck taking the time to carefully model a system and asking domain experts how the model is wrong. In those cases, I tend to get one of two responses:

- “Oh, we take care of that case with X” (which means I need to change my model)
- “Uh-oh, we hadn't thought of that” (which means we might need to fix bugs or make other changes to the system in question)

For example, I recently modeled an upcoming feature my team would be working on and found several problems (in this case, actions we hadn't disallowed that would violate our assumptions about what data would be shown on the page.) I brought those to the folks in charge of the spec, and it turned out they had considered several—but not all—of them and that they had already decided that the consequences were acceptable. I'm still glad I did it, though, since it gave me a much better sense of what we were building and the consequences of our approach.

I've also found it useful to sit down with other people and have a conversation _using_ formal modeling; the model acts as a conversation partner to keep us from assuming different things about the world and point out problems in our thinking. This has even been useful when one or more of the humans involved hasn't known about formal modeling in advance because I can explain stuff on the fly. For example, as I wrote [previously](@/posts/alloy.md):

> For example, at work we were building a feature with inline commenting (like Google Docs.) We started by modeling Google Docs' comments and it turned out that each comment had something like 32 unique states. We realized this was going to be way too much for our use case, and simplified it down to 4. We probably could have had this realization without using Alloy, but it made the conversation much simpler—the designer and I sat down and looked at the visualizations, then kept saying "but for us, states X and Y would be the same…" until we arrived at a simpler model. It was really nice, and only took about an hour and a half of modeling to come up with a solution that satisfied all our requirements!

This is basically “[lightweight formal methods](https://en.wikipedia.org/wiki/Formal_methods#Lightweight_formal_methods)”—we're not out to solve the Byzantine generals problem or whatever, but just to make sure there aren't any big issues we hadn't thought of or flaws we can't live with.

## Having / Artifact

On the models-as-artifacts side, I've had some success, but less than modeling-as-a-process.

To start, I've tried to turn Alloy and TLA+ models into documentation. Alloy's ability to generate examples and its literate markdown support is amazing, but both still require the reader to have some basic familiarity with Alloy's syntax and how to interpret the visualizations.

This can work really well for tutorials and explorations, though: [modeling database tables in Alloy](@/posts/modeling-database-tables-in-alloy.md) was originally written as a literate Alloy file (and still lives in my notes in a form that Alloy could pick up and run.) At work, we now have a few documentation files explaining different features and referencing a common tutorial I wrote for background. It works alright, although I'm not sure how many people have read them (but I have sent links to folks who wanted a refresher on the features, which seems to have worked.)

Beyond documentation of fairly static features, the model and the actual system almost always diverge. People add features and fix bugs in ways that violate the assumptions or assertions of the model, at which point the model is making strong claims that don't match up with real life.

The weird thing, though, is that **this is something you want**. It's not useful to specify your model all the way down to the level of your code. It can be distracting to have random states changing that don't matter for the thing you're trying to assert about the model. [The map is not the territory](https://en.wikipedia.org/wiki/Map%E2%80%93territory_relation), after all! For example, your real-life HTTP service always has to deal with network problems, but your model might not need to. It depends on what you're trying to figure out about the system, and that might change over time as you make models of different parts of the system!

## So which is it?

Based on my experiences with formal modeling tools, I think the process of creating a model is more valuable than the thing you produce. I've seen fewer drawbacks to approaching modeling as a process or as a communication tool without worrying about preserving the model for the long term.

However, my opinion here may change as I practice more. I've already produced a few models-as-documentation for stabler and longer-lived parts of systems at work, and those have been helpful to introduce people to the concepts involved in an isolated way. Maybe trying to find more ways that models have long-term value will change my mind here!

---

Thank you to Ezzeri Esa and Miccah Castorina at [the Recurse Center](https://recurse.com) for reviewing a draft of this post!

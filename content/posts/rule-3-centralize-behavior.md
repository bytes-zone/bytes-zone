+++
title = "Rule 3: Centralize Behavior"
date = 2021-07-06
description = "Behavior attractors!"
+++

Last week, we talked about [clarifying intent](@/posts/rule-2-clarify-your-intent.md) as part of the [four rules of simple design series](@/posts/my-take-on-the-four-rules-of-simple-design.md).
This week, we're on to rule 3: **centralize behavior.**

Imagine you're working on project for a school, trying to make sure that the site addresses users appropriately: students should be addressed casually ("Hello, Adrian!") while teachers should be addressed more formally ("Your teacher, Dr. Beans".) Imagine that this has been done, but a little bit at a time and in different ways, so that these forms of address are implemented in different and inconsistent ways across the site. That makes what seems like a simple change much more difficult!

In order to make this change tractable, you might create a function or method that takes a `User` or `Role` domain concept and returns the right string form, then change each call site across the whole project to use that. A big project, sure, but a pretty reasonable approach! This demonstrates our third rule: **centralize behavior**.

This is similar in spirit to the ideas behind Don't Repeat Yourself. In that context, "repetition" isn't talking about the written form of code so much as authority over defining the behaviors and ideas in the system. A similar concept comes up in Once and Only Once: define each concept in your system in exactly one place, and don't split up that authority!

## What Happens If You Ignore This

Like in the scenario above, ignoring this rule results in hard-to-change code which needs lots of extra effort to modify successfully. Did you get all the little pieces? Better hope so!

Problem is, it's often hard to see this happening—the name change I described above feels a bit contrived because it's easy to see, but template systems in web frameworks will push you away from specifying one-off logic and towards reusable functions or methods. I've seen this come up more often in serialization and validation logic: places where it's very tempting to just dig into some internal data structure instead of defining behavior where the code lives.

One question to ask is "who should be responsible for this behavior?" In the long term, it's nice to answer this by writing behavior attractors.

## Behavior Attractors

Behavior attractors (a term coined by Corey Haines in his book [Understanding the 4 Rules of Simple Design](https://leanpub.com/4rulesofsimpledesign)) are places in your code where it becomes natural to put related code, like water flowing downhill. This gives you a natural way to centralize behavior to keep your system simple and easy to understand.

Let's look at an example! _Understanding the 4 rules of Simple Design_ uses Conway's Game of Life throughout, so let's just steal the example Haines uses to explain this: how do we figure out the neighbors of a cell? When you're implementing the Game of Life, you might end up writing `Cell.neighbors` in the course of answering "is this cell alive or dead in the next cycle?" However, this is not necessarily the best way to implement this, because the concept of a neighbor really depends on the topology of the grid. "Neighbor" means something different for 2- versus 3-dimensional grids, not to mention things like hyperbolic geometry. That suggests that "are these cells neighbors" should be defined by the coordinate system, but you might not come to this realization if you're just passing around 2-dimensional coordinates like `(x, y)`.

The behavior attractor solution is to move those coordinates to a central definition (say, `2DCoord`) and implement the `neighbors` function/method there instead. That means you might end up with `2DCoord(1, 1).neighbors` instead of `Cell.at(1, 1).neighbors`. You get a clearer separation of concerns: a `2DCoord` can clearly define neighbors in a way that a `Cell` shouldn't be responsible for. The behavior attractor made this possible, and will make your life easier the next time you need to ask a question about the coordinate system too!

If you find that you don't have a good place to put some code, _especially_ if you find yourself just putting it close to the place you need it, consider writing a behavior attractor!

+++
title = "The Four Rules of Simple Design: In Conclusion"
date = 2021-08-25
description = "How to apply the rules, and an invitation to make your own."
+++

OK, it's been a couple of weeks since I published [Rule 4: Code for Now](@/posts/rule-4-code-for-now.md), and I've had some interesting feedback!

The biggest thing first: how do you apply these?
Surely you don't just go down the list one at a time, right?
Well, no, I view it more like like a state machine: you enter at [Rule 1: Simplify When the Program Works](@/posts/rule-1-simplify-when-the-program-works.md) and move from there back and forth between [Rule 2: Clarify Your Intent](@/posts/rule-2-clarify-your-intent.md) and [Rule 3: Centralize Behavior](@/posts/rule-3-centralize-behavior.md).
Once you think you're more-or-less done, you check your work with [Rule 4: Code for Now](@/posts/rule-4-code-for-now.md).
When you don't have anywhere else to go—that is, you don't see an opportunity to apply any of the rules—you call it good and move on to the next thing you need to do that day!

That's not the only way to apply the rules, of course, but it's one that I've found works pretty well for me.
J.B. Rainsberger applies the original rules something like this as well: see his post [The Four Elements of Simple Design](https://blog.jbrains.ca/permalink/the-four-elements-of-simple-design) for more, in particular his [axioms of modular design](https://blog.jbrains.ca/permalink/the-four-elements-of-simple-design#the-two-elements-of-simple-design).

Of course, it's not the only way by a long shot! One of my [colleagues at NoRedInk](http://www.mike.is/) pointed out that he'd like to rearrange these rules:

1. Code for now
2. Simplify when the program works
3. Clarify intent
4. Centralize behavior

That could certainly work too! It's up to you how you apply these, if you want to apply them at all.

There's also some tension between the rules. For example, in [Rule 3: Centralize Behavior](@/posts/rule-3-centralize-behavior.md) I talked a lot about making a `Point2d` class.
But… is that structure really _necessary_?
Couldn't it violate [Rule 4: Code for Now](@/posts/rule-4-code-for-now.md)?
How do you decide which to apply?
In the end, you've either got to choose randomly or find a tiebreaker: for example, you could use [Sandi Metz' Rules For Developers](https://thoughtbot.com/blog/sandi-metz-rules-for-developers), which emphasize very small classes.
In that context, building a `Point2d` may or may not be OK depending on how close your class is to 100 lines.

Personally, I've usually gone the other way over the time: I've randomly chosen to prioritize rules randomly based on the situation at hand.
However, since part of the appeal of this whole exercise is that they allow us to reduce guessing about the future, I'm going to continue to explore situations where there seem to be holes or conflicts!

And, to that end: if you read through the original sources (or mine) and are inspired to make your own remix of the four rules, I'd love to read it!
Please send me your takes!
Let's build on each other's work to discover how to make better software.

Thanks for reading!

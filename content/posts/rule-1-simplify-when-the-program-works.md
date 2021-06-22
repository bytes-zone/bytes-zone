+++
title = "Rule 1: Simplify When the Program Works"
date = 2021-06-22
description = "How not to spend all your time refactoring."
+++

Last week, I introduced [My Take on the Four Rules of Simple Design](@/posts/my-take-on-the-four-rules-of-simple-design.md).
To sum up, I've found Kent Beck's four rules of simple design really interesting to think about, and I wanted to come up with my own formulation!

This week, we meet the first rule: **simplify when the program works.**
It's similar to the original first rule ("runs all the tests"), but with a broader reach.
So in addition to passing tests we might include things like:

- Is it possible to get the program into an illegal or "impossible" state by using it?
- Do the user-facing parts of the program look the way that the designer intended?
- Is the program accessible to all kinds of users?
  For example, can the program be operated using only a keyboard?
  Only a mouse?
  A screen reader?
  (Broadly, Is the program [Perceivable, Operable, Understandable, and Robust](https://www.w3.org/WAI/WCAG21/Understanding/intro#understanding-the-four-principles-of-accessibility)?
- Has QA tested this?
  What did they think?

Some of those might not apply to your project, and some of them have really long iteration times, but that's actually part of the point: if you find that your program is broken in some way, it probably makes sense to fix it before trying to make it faster or organize the code better.
Unit tests are just one way of looking at this, although certainly an attractive one since they can be automated.

## What Happens If You Ignore This?

What happens if you start simplifying the code before the program works?

Well, when I've ignored this advice, I notice I tend to start ripping out useful code or changing things in ways that don't make sense.
I end up totally muddling my code with unrelated changes, and despite all the effort the program *still* doesn't work right.
Eventually, I've maybe made something kinda-sorta like the change I tried to make, but it's way harder for my team to review.

In my experience, I need to be in one of two modes: making changes to make the program work, or making changes to make the code simpler.
"Simplify when the program works" has been helpful for me in recognizing when I need to switch!

## Avoiding Perfectionism

But what happens if the vagueness in this rule works against you?
For example, you can pile so many things on to "works" that it becomes "perfect."
Setting an unattainable standard means never shipping, and we'd like to at least ship *some day*, so let's try to avoid perfectionism, right?

One way around this is to change your relationship to your standards, at least temporarily.
Something doesn't have to be *perfect* to be *working*.
For example, maybe messy code is fine *for now*, or maybe it's OK for some tests to fail&mdash;just for a bit&mdash;while you work on accessibility in the UI.

Said differently, we can take on tech debt to avoid perfectionism.

We usually want to avoid that, and you might have some "yuck!" reaction to reading it, but there are places where it makes sense.
I think [Yvonne Lam](https://twitter.com/yvonnezlam) really nailed it with [her concept of tech debt as housework](https://twitter.com/yvonnezlam/status/1376631868972433408), specifically:

> The thing with tech debt is that in order to have a useful discussion, you need to be able to talk about \*who\* is affected and how -- who is going to be woken up, be pulled off other work, be unable to perform some critical function, etc. You can't hide risk and have that talk.
> 
> &mdash; [Yvonne Lam on Twitter](https://twitter.com/yvonnezlam/status/1376631868972433408)

Let's apply that: who is going to be affected by changing your standards, and how?
This will be different in different settings, so asking these questions with your team makes a lot of sense.

As an example, I care a lot about accessibility. 
I don't want to ship software that prevents people from using assistive technology like screen readers.
In my company's case, our users are kids learning to write better.
I really care about not messing that up!

My team shares that value, so when we found out in a recent project that we'd have to choose between having more complicated view code versus shipping a program that was inaccessible to screen readers, we chose the complex code.
We know we're going to have to clean up the code sometime, but for now we're OK with maintaining some slightly complicated code to make sure we're accommodating everyone's needs.

Because we'd already had the conversation about what values we wanted our code to embody, we were able to make a choice that lined up with those values.
Even though the software wasn't perfect, I think we made the right tradeoff.

Point is: talk with your team about this!
Every project, team, and person has a different set of values, so trying to nail down what "works" means can highlight differences in how we think about the things we're building.

## Make The Change Easy

Another way to apply this rule is to "make the change easy, then make the easy change."
([Coincidentally, another Kent Beck-ism](https://twitter.com/kentbeck/status/250733358307500032).)
In other words, when you go to your code to make a change, consider refactoring towards simpler code *first* instead of waiting until after you're done.

It might seem like this is incompatible with the rule&mdash;after all, if you're planning to make a change you already know the program doesn't work according to the specification&mdash;but we often have to do some cleanup in order to make the change possible!
For the purposes of this rule, "works" can also mean "is amenable to change!"

## Conclusion

So, to sum up:

- "Simplify when the program works" depends a lot on what you mean by "works."
  (It also depends on what you mean by "simplify", but that's what the other rules are for&mdash;coming soon!)
- This rule can be helpful as a signal to switch from writing-code-to-make-the-program-work mode to clarifying-code-for-future-us mode.
- Set a high bar, but no so high that you can't ever ship.

See you next week for rule 2: clarify your intent.

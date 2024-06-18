+++
title = "Rule 2: Clarify Your Intent"
date = 2021-06-29
description = "Names, comments, and constructors."
+++

Last week, we talked about [simplifying when the program works](@/posts/rule-1-simplify-when-the-program-works.md) as part of the [four rules of simple design series](@/posts/my-take-on-the-four-rules-of-simple-design.md).

This week, rule two: **clarify your intent.**

The original four rules prioritize clarity of communication[^four-rules-are-about-communication]. For example, Beck's formulation says "states every intention important to the programmer." Fowler tightens that up to "reveals intent", and Rainsberger refines it further to "improve names." But _what_ intent are we trying to communicate clearly? Here are a few things you might want to consider:

- What's this thing for?
- How are these two things related?
- Why is this code doing things _this way_ instead of _that way_?
- Please don't do _this thing_ if you also do _that thing_.
- Which part of this is core to the program, and which is just supporting structure?
- Where does the stuff you send here end up? Or, where is this thing getting stuff from?

You can communicate these things in a lot of ways, but I want to talk about three: names, comments, and constructors.

## Names

Say you have a method called `process_data`[^process-data-inspiration]. Both of those words are really vague! What if we made them better? What's `process`? What's `data`?

Maybe you look at the method body and find out it downloads a CSV of accounts and selects all the ones the sales team has identified as likely to buy a premium license. So in this case, `process` would be incorrect—it's `get` or `download`. And it's not just any old `data`, it's `clients`, specially ones on the threshold of upgrading.

So, while there are more ways you could improve this (e.g. separating the downloading from the data processing), renaming it to `get_threshold_clients` already makes it way easier to understand your code: imagine seeing `process_data` vs `get_threshold_clients` at a call site. Which would you prefer when reading later?

There's a lot to think about when choosing a good name, so instead of saying more, I'm just going to link some things I've found helpful: [_Naming Things in Elm_ by Ally McKnight](https://2018.elm-conf.us/schedule/ally-kelly-mcknight), [_Picking better names for variables, functions, and projects_ by Tom MacWright](https://macwright.com/2021/02/17/the-naming-of-things.html), [_What's in a Name? Anti-Patterns to Hard Problem_ by Katrina Owen](https://www.sitepoint.com/whats-in-a-name-anti-patterns-to-a-hard-problem/), and [_"Naming Things" is a Poor Name for Naming Things_ by Hillel Wayne](https://buttondown.email/hillelwayne/archive/naming-things-is-a-poor-name-for-naming-things/).

## Comments

Another thing you could do to clarify your intent is to explicitly write it down in a comment. There's the constant debate on "what" comments vs "why" comments, of course—[here's Hillel Wayne again on why you need both](https://buttondown.email/hillelwayne/archive/comment-the-why-and-the-what/)—but in either form, the best comments give the reader insight into what was going on and what you needed when you wrote your code.

I like to write long documentation comments framed like "Hello, future us! I hope you're having great day. Here's what's up." I've found those to be helpful, both when my coworkers review the code and when we revisit it months later while trying to do something else. Having little hints of intention scattered throughout the code helps remember things we need to keep in mind. Plus, like trying to find a good name, documenting why something exists can often help us realize some other refactor that could help us do what we're doing better!

## Constructors

In addition to names and comments, you can often clarify your intent in by making certain circumstances impossible by construction. As a trivial example, you might know that a value can sometimes be null, so you represent it as an optional type. Or, if you know you'll always have at least one item, you can use a non-empty list to hold the data. I've found this to be a lot easier in ML-family languages like Haskell or Elm, but you can do it in object-oriented languages as well.

There are tons of talks and examples of this online if you search for things like "make illegal states unrepresentable". I like [Richard Feldman's 2016 talk _Make Impossible States Impossible_](https://www.youtube.com/watch?v=IcgmSRJHu_8).

## What Happens If You Ignore This?

If you don't clarify your intent when coding, you end up in situations where you have to re-establish context. In names, that might mean having to jump to the definition to figure out what's actually happening. In the case of comments, that might mean having to spend a long time looking through the code in order to find the shape of the program's core algorithm. In constructors, it means the same but trying to figure out if something should be possible or not.

If you don't clarify intent, you'll also miss out on great refactoring opportunities: in the `get_threshold_clients` example above, we might see that we want to separate getting the raw data and applying our precise filtering rules. That makes the code more modular (and more testable!) but we might not have seen it if we didn't stop to clarify intent.

## Conclusion

In summary, remember that code is read many more times than it's written. Keeping that in mind can go a long way to making things better for your coworkers (or just you, 6 months from now.) There are lot of ways to do this—way more than we can go over here—but you can get a long way by focusing on names, comments, and constructors.

[^four-rules-are-about-communication]: In fact, I think the entirety of the four rules is secretly about communication: write tests to communicate, remove duplication to make sure you're not saying the same thing twice, remove any unnecessary distractions, and here where we're being pretty explicit about intention!
[^process-data-inspiration]: Example inspired by Corey Haines' [_Understanding the Four Rules of Simple Design_](https://leanpub.com/4rulesofsimpledesign)

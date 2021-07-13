+++
title = "My Take on the Four Rules of Simple Design"
date = 2021-06-15
description = "A new series about designing simple systems."
+++

I've been thinking about how to write better tests recently, and I happened on Kent Beck's four rules for simple design.
In a nutshell, these rules were meant to give objective criteria for the question "is this code simple?"
The original formulation goes like this: a piece of code can be said to be simple if it...

> 1. Runs all the tests.
> 2. Has no duplicated logic. Be wary of hidden duplication like parallel class hierarchies
> 3. States every intention important to the programmer.
> 4. Has the fewest possible classes and methods.
>
> — [Kent Beck, *Extreme Programming Explained: Embrace Change*](https://www.google.com/books/edition/Extreme_Programming_Explained/G8EL4H4vf7UC?hl=en&gbpv=1&pg=PA57&printsec=frontcover)

In practice, I really like that while the intention may have been to make an objective metric for simplicity, people tend to treat these rules as *imperfect but useful*.
That is, they give us a way to judge if a piece of code is better or worse than another one.
This turns out to be a helpful way of judging internal quality of a piece of software&mdash;and improving that is why we write tests and refactor code in the first place!

I think this usefulness has made these rules surprisingly uncontroversial (at least to me, based on how much I know we programmers like bikeshedding!)
The most controversial topic, in fact, seems to be which order to apply rules 2 and 3 in.

In reading about this, I collected a bunch of interpretations of the four rules from various authors:

| Rule | [Kent Beck][kb]                                     | [Martin Fowler][mf] | [J.B. Rainsberger][jbr] | [Corey Haines][ch]   |
|------|:----------------------------------------------------|:--------------------|:------------------------|:---------------------|
| 1.   | Runs all the tests.                                 | Passes the tests    | Passes its tests        | Tests Pass           |
| 2.   | Has no duplicated logic. [&hellip;]                 | No duplication      | Minimizes Duplication   | No Duplication (DRY) |
| 3.   | States every intention important to the programmer. | Reveals intention   | Maximizes clarity       | Expresses Intent     |
| 4.   | Has the fewest possible classes and methods.        | Fewest elements     | Has fewer elements      | Small                |

[kb]: https://www.google.com/books/edition/Extreme_Programming_Explained/G8EL4H4vf7UC?hl=en&gbpv=1&pg=PA57&printsec=frontcover
[mf]: https://www.martinfowler.com/bliki/BeckDesignRules.html
[jbr]: https://blog.jbrains.ca/permalink/the-four-elements-of-simple-design
[ch]: https://leanpub.com/4rulesofsimpledesign

(n.b. I switched rules 2 and 3 in Fowler's and Haines' formulations for reading consistency.
Based on these author's writings, I think it's fine in this context.)

I have enjoyed applying these rules to my own code, but in the spirit of "what I cannot create, I do not understand," I thought it'd be fun to try and make my own formulation.
In doing this, I'd like to avoid simply paraphrasing the four rules&mdash;I want to be able to explain what makes code simple to someone who has never heard of this concept.
That means being able to make a reasonable argument for each point, as well as talking about the consequences of leaving them off.

I originally thought that'd be one post, but then I did a bunch of research to make sure I wasn't just making stuff up and it turned out super long.
So here's what we're going to do: over the next month, I'll be publishing one post per week about a new rule.
When I do that, I'll come back to this post and link them up.
If you're here after July 2021, welcome!
Get started by clicking the links below.
Otherwise, you can sign up to be notified about new posts by putting your email in the box at the bottom of the post.

1. [Simplify When the Program Works](@/posts/rule-1-simplify-when-the-program-works.md) (June 22)
2. [Clarify Your Intent](@/posts/rule-2-clarify-your-intent.md) (June 29)
3. [Centralize Behavior](@/posts/rule-3-centralize-behavior.md) (July 6)
4. [Code for Now](@/posts/rule-4-code-for-now.md) (July 13)

Afterwards, I'll probably publish a conclusion including reader feedback in late July.
I'd love to hear from you as you're reading these things; you can email me at [brian@brianthicks.com](mailto:brian@brianthicks.com).

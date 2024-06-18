+++
title = "Rule 4: Code for Now"
date = 2021-07-13
description = "Stop guessing you'll need stuff later!"
+++

Last week, we talked about [centralizing behavior](@/posts/rule-3-centralize-behavior.md) as part of the [four rules of simple design series](@/posts/my-take-on-the-four-rules-of-simple-design.md).

This week, the final rule: **code for now**.
This is about focusing on building the smallest thing that can possibly work.

Another way to put it: are you writing code because you're guessing that you'll need something later?
Stop it!

This shows up most commonly when building larger pieces of program structure.
In my experience:

- In object-oriented languages like Python and Ruby, it can look like deep class hierarchies and composition by mixins or inheritance.
- In Haskell, it can look like lots of custom typeclasses or adding high-complexity features like lenses or monad transformer stacks.
- In Elm, it can look like factoring out every little piece of state into a separate model/update/view triple, or splitting things into smaller and smaller modules.

In summary: don't add structure to code before you need it.
(And if we're being honest, this rule is not far from "You Aren't Gonna Need It" in different clothes.)

## What Happens If You Ignore This?

Have you ever seen [FizzBuzzEnterpriseEdition](https://github.com/EnterpriseQualityCoding/FizzBuzzEnterpriseEdition)?
That.

## But Where Do I Put Code?

Removing unnecessary structure can cause some confusion when you want to add some functionality but there's no obvious place for it.
In that case: add structure, because you need it _now_.
The point of the rule is to avoid guessing about what you'll need in the future, not to avoid all kinds of structure.
This rule is also the catch-all at the end of the four rules.
You shouldn't need to invoke it often.
If you don't know where to put code, make sure you're [centralizing behavior](@/posts/rule-3-centralize-behavior.md) or [clarifying your intent](@/posts/rule-2-clarify-your-intent.md).

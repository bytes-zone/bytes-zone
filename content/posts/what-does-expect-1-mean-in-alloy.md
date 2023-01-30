+++
title = "What does expect 1 mean in Alloy?"
date = 2023-01-30
description = "spoiler: it's for testing Alloy itself."

[extra]
project = "learning Alloy"
+++

When you open up [Alloy](@/posts/alloy.md), the default `run` in the menu is “Run Default for 4 but 4 int, 4 seq expect 1.” I know what “for 4” means (up to 4 of every `sig`) and `but 4 int` means (4 bits worth of integers) but I don't know what “expect 1” means!

Let's look in [the spec](http://alloytools.org/spec.html)… nothing! It shows the “run X” and “for Y” and “but Z SigName” but not “expect.” 🤔

OK, [on to the Alloy forums, then](https://alloytools.discourse.group/t/what-does-expect-1-mean/308). Daniel Jackson says it allows you to say how many results you expect. You used to be able to expect an arbitrary number, but that didn't turn out to be useful, and now you can just say “1” (for some results) or “0” (for no results.) It's useful for testing regressions when developing Alloy itself.

I was able to use `expect 0` to produce a spec that fails, as expected:

```alloy
fact {
  some u: univ | u not in univ
}

run {} for 4 expect 0
```

(In English: “I want you to check that the set of all sets does not contain itself.” This is not possible in Alloy's set semantics.)

When evaluating this, Alloy says, “No instance found. Predicate may be inconsistent, as expected.” Note the “inconsistent”, meaning “you've created a conflict in your expectations.” If I switch it to `expect 1`, it says “Predicate may be inconsistent, contrary to expectation.”
+++
title = "Should Elm files be long or short?"
date = 2021-01-03
draft = true
+++

[the Elm Guide page on app Structure](https://guide.elm-lang.org/webapps/structure.html) says:

> [Don't] "Prefer shorter files."
> In JavaScript, the longer your file is, the more likely you have some sneaky mutation that will cause a really difficult bug.
> But in Elm, that is not possible!
> Your file can be 2000 lines long and that still cannot happen.

I'm not 100% sure about this advice, which came up in an [Elm Discourse thread](https://discourse.elm-lang.org/t/should-i-prefer-big-elm-files/6687) this weekend.
I thought this was a really fun question, so I wanted to share my answer a little wider.

So, personally, I don't really agree with that part of the docs.
I've worked in codebases with short files and longer files, and it hasn't been my experience that either style was more or less prone to mutation bugs.
That makes me think that **file length is not the problem, mutation is.**
And mutation is not a problem in Elm&mdash;it's just not allowed in the language at all!

So: should Elm files be longer than JavaScript files?
Not necessarily!
But they also shouldn't necessarily be shorter, either!
They **may** be longer as a consequence of the things I'm gonna say below, but that's a consequence only&mdash;not a goal!

Now, with that out of the way, we can get to the more interesting question: what *is* the right file length?
I think to answer that you've gotta answer "what is a file for?"
In Elm, that's encapsulation: we can choose to expose or hide things in modules, put different functions in different modules, et cetera.
We can choose where to put boundaries around our abstractions to prevent our design constraints from being violated.

I think that means **the right file length is the one where your encapsulation works to prevent bugs**, either by preventing encapsulation-violating behavior or making your code easy enough to understand that you can verify it's doing the right thing.
That doesn't mean long files or short files, but correct-for-the-situation files.

I realize that this basically boils down to "it depends", which I know is a bit unsatisfying.
Sorry!
Maybe it will help if I share some assorted things I use to know if a module needs to be broken up (or not):

- **Yes, split if:** there's a function that should not be able to access internals of a data structure, but which can because it lives in the same module.
  (Of course, the opposite is true too... if there's a function that needs to be able to access internals but *can't* the module boundary may be in the wrong place!)
- **Yes, split if:** there are two independent data structures in the same module.
  One smell here is if I have to write `fooToString` for the main one and `barToString` as well, and `foo` and `bar` are independently valuable, it may be time to split them into their own modules.
- **No, don't split if:** there is just "too much code" in a file.
  I've split apps into `Model.elm`, `Update.elm`, `View.elm` before and almost always regretted it.
  Even if it's a little tricky to navigate a long file, it's way better than having to perform module gymnastics to prevent import loops etc.

All that said: like the rest of that page in the guide, I would encourage people to write long files and then break them up instead of making tiny files before it's actually necessary.
I've been using Elm for something like half a decade now and the only reliable way I've found to put module boundaries in the right places is to wait and see what the right place *is*.
I suppose that means I am, in effect, advocating for long files over short ones but again: that's a consequence, not a goal!

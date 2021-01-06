+++
title = "Should Elm files be long or short?"
date = 2021-01-11
draft = true
+++

[the Elm Guide page on app Structure](https://guide.elm-lang.org/webapps/structure.html) says:

> [Don't] Prefer shorter files.
> In JavaScript, the longer your file is, the more likely you have some sneaky mutation that will cause a really difficult bug.
> But in Elm, that is not possible!
> Your file can be 2000 lines long and that still cannot happen.

Someone [asked about this on the Elm Discourse](https://discourse.elm-lang.org/t/should-i-prefer-big-elm-files/6687) recently, wondering if this advice meant they should prefer longer Elm files over shorter ones.
I thought this was a really interesting question!
I answered on Discourse, but I also want to clean up my answer to share a little wider.
Here goes!

So, personally, I don't really agree with that part of the docs.
I've worked in codebases with short files and longer files, and it didn't seem like either style was more or less prone to mutation bugs.
That makes me think that **file length is not the problem, mutation is.**
And mutation is not a problem in Elm&mdash;it's just not allowed in the language at all, regardless of file length!

What does that mean for how we write Elm?
Should Elm files be longer or shorter than JavaScript files?
Well, neither really!
If we accept that file length is not strongly correlated with this kind of bug, it doesn't matter!
Elm files **may** be longer as a consequence of the things I'm gonna say below, but that's a consequence only&mdash;not a goal!

Now, with that out of the way, we can get to the more interesting question: what *is* the right file length?
I think to answer that we need to figure out what a module is actually good for.
In Elm, I use modules for two reasons:

1. **encapsulation:** hiding or exposing bits of the implementation to make a cohesive API.
2. **namespacing:** defining things like `toString` under different name spaces.

The second is *kiiiinda* a consequence of the first, so I think we can squint and ignore it.
So for our purposes, I'm asserting that files are for encapsulation.
That means **the right file length is the one where your encapsulation works to prevent bugs**, either by preventing encapsulation-violating behavior or making your code easy enough to understand that you can verify it's doing the right thing.
That doesn't mean long files or short files, but correct-for-the-situation files.

I realize that this basically boils down to "it depends", which I know is a bit unsatisfying.
Sorry!
Maybe it will help if I share some assorted things I use to know if a module needs to be broken up (or not):

- **Yes, split if:** there's a function that should not be able to access internals of a data structure, but which can because it lives in the same module.
  Of course, the opposite is true too... if there's a function that needs to be able to access internals but *can't* the module boundary may be in the wrong place!
- **Yes, split if:** there are two independent data structures in the same module.
  One smell here is if I have to write `fooToString` and `barToString` in the same module, and `foo` and `bar` are independently valuable, it may be time to give at least one a new home.
  The opposite ("join if&hellip;") looks the same as the previous item: if you split a single data structure into two modules, you'll frequently need to share too many internals and so should move everything into one file.
- **No, don't split if:** there is just "too much code" in a file.
  I've split apps into `Model.elm`, `Update.elm`, `View.elm` and almost always regretted it.
  Even if it's a little tricky to navigate a long file, it's way better than having to perform module gymnastics to prevent import loops.

All that said: like the rest of that page in the guide, I would encourage people to write long files and then break them up instead of making tiny files before it's actually necessary.
I've been using Elm for something like half a decade now and the only reliable way I've found to put module boundaries in the right places is to wait and see what the right place *is*.
I suppose that means I am, in effect, advocating for long files over short ones but again: that's a consequence, not a goal!

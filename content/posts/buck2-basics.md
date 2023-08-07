+++
title = "buck2 basics"
description = "A very crashy crash course on Buck 2"
date = 2023-08-07
+++

I just finished an experiment with [Buck 2](https://buck2.build) at work. We didn't end up using it, but it was more for organizational reasons than technical ones. I'll be watching the project to see if it would make sense to use in the future!

One thing that held me back during the early part of the experiment was not having enough learning material around the basics. That makes sense: it's a pretty new project (at least in this iteration) and there are a *lot* of concepts to learn.

So instead of teaching things from first principles, I want to run head-first into getting something simple set up. We won't have any more functionality than we could get with some simple `make` rules, but since [the person who does the work does the learning](https://bytes.zone/posts/learning-requires-effort/) I hope this will be helpful! That said, keep in mind that I'm no expert—just some person who learned enough to get stuff done!

<aside>

I'm going to assume you have buck2 available on your `PATH`. If you don't, download it from [the `latest` tag on the facebook/buck2 repo](https://github.com/facebook/buck2/releases/tag/latest). Once you do that, you can run `buck2 init --git` to get a basic project set up for the rest of this post.

</aside>

## The Simplest Possible Rule

We'll start off with the simplest possible thing: a file that says "Hello, World!" We'll use a `genrule` for this, which lets you say what shell commands to run to produce some file. In the root `BUCK` file, write this:

```python
genrule(
  name = "some-target",
  out = "target-file",
  cmd = "echo 'Hello, World!' > $OUT",
)
```

That configures a target named `some-target` that you can build with `buck2 build //:some-target`. If you add `--show-output` to that, it'll tell you where the file is, and if you `cat buck-out/v2/gen/root/213ed1b7ab869379/__some-target__/out/target-file` (or whatever path Buck gives you) it out it'll say "Hello, World!" First build done. Yay!

So what do all the parts in that rule mean?

- `genrule(…)` is the rule you're calling. I think "gen" here is short for "generic" (or maybe "generate"?) Anyway, it's the simplest thing that the build system can possibly do.
- `name` defines how you'll refer to this target from other rules or from the CLI. See [the target pattern docs](https://buck2.build/docs/concepts/target_pattern/), which also explain why you refer to this as `//:some-target`.
- `out` is the file that will be produced by the rule
- `cmd` is the command that will be run to produce the file. `$OUT` looks like an environment variable reference, but as far as I can tell Buck is actually interpolating it into the string before calling the command. [The docs for `genrule` have some examples of other variables you can use](https://buck2.build/docs/api/rules/#genrule).

## More!

Next, let's chain two rules together. Here's another rule in the same file:

```python
genrule(
  name = "yelling-target",
  out = "target-file",
  cmd = "tr '[:lower:]' '[:upper:]' < $(location :some-target) > $OUT",
)
```

The new thing here is `$(location ...)`, which interpolates the location of some the output of the named target into the command line.

> [!aside]
> I had a hard time finding out if there was anything else like `location` that I could use. It turns out that the call there is actually a lookup for the "location" attribute on the target inside Buck's build graph. That means different rules will produce different things! But generally speaking, `location` will work for files in general and `executable` will work for files that you need to run.

Now if you build everything and go look at the output (using `--show-output`), you will get a new file that says "HELLO, WORLD!". If you change the original rule, the new one will get built too.

So with these two rules (plus the thing in `toolchain`), you can:

- Run `buck2 build //...` to build both targets
- Run `buck2 build //:some-target` to build only the "Hello, World!" file.
- Run `buck2 build //:yelling-target` to build the "HELLO, WORLD!" file, which will build `:some-target` as well, if necessary.

Try changing things around (for example by changing the message) and seeing what happens. You can also run `buck clean` to remove the targets to get a fresh build.

Next time, we'll talk about moving these from `genrule`s into a library that we can import and call.

+++
title = "moving genrules to library rules"
date = 2023-08-14
description = ""
+++

In [buck2 basics](@/posts/buck2-basics.md), we made two rules:

```python
genrule(
  name = "some-target",
  out = "target-file",
  cmd = "echo 'Hello, World!' > $OUT",
)

genrule(
  name = "yelling-target",
  out = "target-file",
  cmd = "tr '[:lower:]' '[:upper:]' < $(location :some-target) > $OUT",
)
```

Let's lift these to named rules so that we have a nicer API and don't mix the commands with the parameters. Let's make a couple rules to `say` and `yell` (to implement `some-target` and `yelling-target`, respectively.) Open a new file `talking.bzl` and put this in it:

```python
def _say_impl(ctx: "context"):
    return [DefaultInfo()]

say = rule(
    impl = _say_impl,
    attrs = {
        "message": attrs.string(),
        "out": attrs.string(default = "out"),
    },
)
```

This won't do anything yet, but it's about the minimum possible rule that lets us do this back in `BUCK`. I've rendered this as a diff so you can see the before and after:

```diff
+load(":talking.bzl", "say")

-genrule(
-  name = "some-target",
-  out = "target-file",
-  cmd = "echo 'Hello, World!' > $OUT",
-)
+say(
+  name = "some-target",
+  message = "Hello, World!",
+)

 genrule(
   name = "yelling-target",
   out = "target-file",
   cmd = "tr '[:lower:]' '[:upper:]' < $(location :some-target) > $OUT",
 )
```

Now we have `:some-target` redefined as a call to `say`, so let's implement it:

```diff
 def _say_impl(ctx: "context"):
+    out = ctx.actions.declare_output(ctx.attrs.out)
+
+    ctx.actions.write(out, ctx.attrs.message)
+
-    return [DefaultInfo()]
+    return [DefaultInfo(default_output = out)]

 say = rule(
     impl = _say_impl,
     attrs = {
         "message": attrs.string(),
         "out": attrs.string(default = "out"),
     },
 )
```

OK! Here's what's happening there:

- we're declaring an output file named whatever we passed in in `ctx.attrs.out`. We didn't specify that in `BUCK` so it's the default value, which we called "out". Importantly, whenever we declare an output we have to "bind" it by using it in an action before the end of the implementation.
- So, next, we write the message to that out file. That binds the output.
- Then finally, we say that that output is our default output.

At this point, if you run `buck2 build //:yelling-target` it'll produce the same output. We changed how we're building the file, but the build graph as a whole produces the same thing. I really like this property; it means I can improve parts of the build graph in isolation without worrying too much about upstream or downstream dependencies.

Anyway, let's do the same thing to `:yelling-target` now by making a `yell` rule:

```python
def _yell_impl(ctx: "context"):
    out = ctx.actions.declare_output(ctx.attrs.out)

    ctx.actions.run(
        [
            "bash",
            "-c",
            "tr '[:lower:]' '[:upper:]' < $1 > $2",
            "--",
            ctx.attrs.src,
            out.as_output(),
        ],
        category = "yell",
    )

    return [DefaultInfo(default_output = out)]

yell = rule(
  impl = _yell_impl,
  attrs = {
      "src": attrs.source(),
      "out": attrs.string(default = "out"),
  },
)
```

We have some more stuff happening here:

- We're calling a `bash` script to get the shell redirection working correctly. I write a lot of little bash scripts like this when making Buck rules. There are probably better ways to do this, but it works fine for what we're doing here.
- When we pass `out` to the args of our script, we call `.as_output()` on it. That lets Buck know that we're binding the output in that command.
- We're requiring `attrs.source()` in `src`, which tells Buck that we're expecting some already-existing input file.

Now in `BUCK`, we can modify our rules like so:

```diff
-load(":talking.bzl", "say")
+load(":talking.bzl", "say", "yell")

 say(
   name = "some-target",
   message = "Hello, World!",
 )

-genrule(
-  name = "yelling-target",
-  out = "target-file",
-  cmd = "tr '[:lower:]' '[:upper:]' < $(location :some-target) > $OUT",
-)
+yell(
+  name = "yelling-target",
+  src = ":some-target",
+)
```

Since `src` is a `source`, we provide the [target pattern](https://buck2.build/docs/concepts/target_pattern/) of the input file we want. That means our build graph is unchanged once again!

And we're done! Now we can call `buck2 build //:yelling-target`, same as before. Tada!

Anyway, that's all I have for Buck stuff—like I said in [buck2 basics](@/posts/buck2-basics.md), I'll be watching the project to see when I can use it again!

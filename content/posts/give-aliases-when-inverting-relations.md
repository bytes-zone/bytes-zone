+++
title = "give aliases when inverting relations"
date = 2023-02-27
description = "using Alloy's functions to clarify intent"

[extra]
project = "learning Alloy"
+++

Say you're using [Alloy](@/projects/learning-alloy.md) to model some tree structure. For example, a file system with directories and files:

```alloy
abstract sig Node {
  parent: lone Node,
}

sig File, Directory extends Node {}

fact "a node cannot be its own parent" {
  no n: Node | n in n.^parent
}

fact "there is only one root node" {
  one n: Node | no n.parent
}
```

This gives us nice file system objects that always terminate in a single node and without any recursive shenanigans, like this one:

![an Alloy diagram showing two directories, each containing one file. One directory also contains the other.](/images/filesystem-two-dirs-two-files.png)

However, the model currently implicitly allows this that we don't want to include based on our mental model of the filesystem. For example, files that have other files as their parent:

![an Alloy diagram showing a file containing to other files](/images/filesystem-parenting-files.png)

That doesn't work: a directory can have children, but a file needs to have contents instead (e.g., images, text, etc.) So let's disallow that! We'll do that by adding a new fact like “files shouldn't have any children.” We *could* do that by saying this:

```alloy
fact "files shouldn't have any children" {
  no File.~parent
}
```

(In case you haven't encountered the `~` operator before, it just flips the relation. That makes it child-to-parent instead of parent-to-child. More about this in [fields as sets](@/posts/fields-as-sets.md))

Alloy can work fine with this, but in my opinion, using `~` like this makes the intent of the spec less clear. I always have to think about what the `~` is changing, even if I wrote the code not ten minutes before! Fortunately, we can clarify this by making an alias with a `fun` and then define our `fact` in those terms instead:

```alloy
fun children: Node -> Node {
  ~parent
}

fact "files shouldn't have any children" {
  no File.children
}
```

This seems much clearer to me; the assertion we're making reads almost exactly how we'd write it in English. I like that a lot! It makes communicating about the spec easier, both for me and for anyone else who ends up reading it.

In general, I'm finding that I really like to use `fun`s to clarify my intent, or to put a durable label on some form of node. Doing this requires a little mindset shift from writing `pred`s or `fact`s, since `fun`s have to yield a subset of data instead of a boolean, but in my experience it results in higher-quality communication!

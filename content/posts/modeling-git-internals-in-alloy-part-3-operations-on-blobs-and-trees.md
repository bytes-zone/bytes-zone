+++
title = "Modeling Git Internals in Alloy, Part 3: Operations on Blobs and Trees"
date = 2023-04-24
description = "Understanding Git better by using lightweight formal methods"

[extra]
project = "learning Alloy"
+++

In the last two posts, we've modeled Git's internal data structures in [Alloy](@/posts/alloy.md). First, we handled [blobs and trees](@/posts/modeling-git-internals-in-alloy-part-1-blobs-and-trees.md), then [commits and tags](@/posts/modeling-git-internals-in-alloy-part-2-commits-and-tags.md). During all that, we introduced some `fact`s—things that Alloy will accept as true, regardless of whether those assumptions hold in real life. Today, we'll model some Git operations to see if those facts actually hold! In particular, we'll look at:

- `hash-object` to get a `Blob`
- `update-index` and `write-tree` to get a `Tree`

To do that, we're going to have to introduce changes over time to our model. In Alloy, this means two things:

1. Marking the parts of our model that can change.
2. Defining transitions between one state and the next.

Once we do that, we can make assertions about time, for example that something is always or never true, or becomes true eventually given some other condition.

Let's begin by redefining `Blob` to be able to change over time. To do that, we just prepend `var` to its definition:

```alloy
var sig Blob {}
```

If we run this, we get new goodies in the instance viewer:

![The Alloy instance viewer, a macOS window with a row of buttons at the top like "New Init" or "New Fork". Below the controls is a timeline that shows distinct states. In this instance, there is only one state repeated twice.](/images/blob-over-time-in-the-instance-viewer.png)

On the left, we have time step 0—the initial state of the instance. On the right, we have the next step. Alloy will always show at least two time steps, and in this case Alloy also shows us that the last step repeats forever (by showing a looping arrow over the second step.)

Where we had “New” before to get a new instance, we now click “New Init”—that'll get us another starting state for the model. We can also scrub back and forth on the timeline by clicking the left and right arrow buttons. If you click “New Fork”, Alloy will make something new happen starting from the second visible step (the one on the right.) I'd encourage you to load up Alloy and play around with this some—it'll look totally random right now, but that's just because we're not controlling how `Blob` changes at all right now, so Alloy allows it to change in arbitrary ways.

## Adding Processes

This model isn't super useful yet, since we don't actually say *how* blobs can change over time. Let's add some structure so we can define that!

To start with, we need to define an initial state. Seems fine to start with the same thing Git does: an empty repo with no objects.

```alloy
pred init {
  no Blob
}
```

We'd normally use a predicate to check if a condition holds, and that's the same here except with the addition of time. Said another way, at any time that `init` is true, there will be no `Blob`s. We'll place this `init` at a precise moment in time (namely, the first time step) very soon here.

From there, one reasonable thing to do is to do nothing. We'll need a step like this for most models, since Alloy needs to be able to say “… and then nothing ever happens again for the rest of time.” This is traditionally called a stutter step:

```alloy
pred stutter {
  Blob' = Blob
}
```

We get a new bit of syntax here: saying `'` after something means you're referring to that thing in the next time step. So `Blob' = Blob` (which I pronounce “blob prime equals blob”) means that `Blob` will stay exactly the same whenever the `stutter` predicate is true.

Now let's combine these! Right now, we can keep the system the same across time by saying “init is true at the beginning, and then stutter is true forever.” We'd do that with another predicate that traces those events through time:

```alloy
pred traces {
  init
  always stutter
}
```

This introduces another new piece of syntax: `always` means “from this point going forward, this condition is always true.” In other words, we're saying “at the current time step, `init` is true. Going forward, `stutter` is always true.” Effectively, that means that we start with no blobs and never add any.

Finally, we tell Alloy that it should assume that the `traces` predicate is always true:

```
fact { traces }
```

Now if we evaluate the model, we see that it has exactly zero blobs forever:

![The Alloy instance viewer showing a totally uninhabited instance that does not change over time.](/images/no-blobs-in-the-instance-viewer.png)

If we click “New Init” now, we get the usual “there are no more instances” message:

![a dialog box saying "There are no more satisfying instances. Note: due to symmetry breaking and other optimizations, some equivalent solutions may have been omitted."](/images/no-more-satisfying-instances.png)

## Hashing Objects

Now we have a blank canvas and can start adding operations. Let's start as we did in [part 1](@/posts/modeling-git-internals-in-alloy-part-1-blobs-and-trees.md) with `git hash-object`. As a refresher, this command takes some content, hashes it, and stores it according to the hash. You can invoke it like this:

```
$ echo 'Hello, Alloy!' | git hash-object -w --stdin
39528abd81b13b2731d47f86206351a61f1e6484
```

In Alloy, that looks like adding a new predicate:

```alloy
pred hashObject {
  one Blob' - Blob
}
```

Since we only care about the presence of the blobs and not their content, it's sufficient to say, “there is one (and only one) blob in the next state that doesn't appear in the previous state.”

Next, we'll tell `traces` that `hashObject` is one of the things that can be true at any time step:

```alloy
pred traces {
  init
  always {
    stutter
    or hashObject
  }
}
```

Just to reiterate what this means, we're now saying “`init` is true at the start. Forever after, either `stutter` or `hashObject` is true.”

If it helps, you can kind of think of this as saying “`init` is true at the start; afterward, either `stutter` or `hashObject` *can happen*.” However, this is not strictly accurate: Alloy has no concept of events happening, only conditions which happen to be true at any given time.

If you execute this spec, you can now see blobs coming into existence between time steps (you may need to click “New Fork” to get this to happen.)

![The Alloy instance viewer showing the creation of a single new blob.](/images/one-blob-in-the-instance-viewer.png)

## Adding to the Index

To finish up, we're going to create trees. As a reminder, this is two operations:

1. Adding a blob to the index at a certain path
2. Creating the tree from the index

On the command line, this looks like this:

```
$ git update-index --add --cacheinfo 100644 \
  39528abd81b13b2731d47f86206351a61f1e6484 hello-alloy.txt

$ git write-tree
3ee29075f260c5eebd8b9480b6464a7612668dde
```

To model this in Alloy, we'll need to model the index as well as trees. First, the index:

```alloy
one sig Repo {
  var index: set Blob + Tree,
}
```

(This is `one sig` because there can only be one repo in our model. We've assumed there was one implicitly—we wouldn't have been able to add blobs otherwise—it's just explicit now.)

We'll also need to add trees:

```alloy
var sig Tree {
  var children: set Blob + Tree,
}
```

Like `Blob`, `Tree` is `var`: we can create new trees from an index. But unlike `Blob`, `Tree` has children. These are also marked `var`, despite an individual tree's contents never changing, because we need to be able to change the mapping of trees to blobs over time.

Before we can add any events on these, we'll need to define what they look like initially, and say that they never change in the stutter step:

```diff
 pred init {
   no Blob
+  no Tree
+  no children
 }
 
 pred stutter {
   Blob' = Blob
+  Tree' = Tree
+  children' = children
+  index' = index
 }
```

We could have omitted `no children` in `init` because there really can't be any trees or blobs present in `children` if there are no trees or blobs in the whole system, but I find it's better to be explicit.

We'll also need to add similar lines as a frame condition in `hashObject`:

```diff
 pred hashObject {
   one Blob' - Blob
+
+  // frame
+  Tree' = Tree
+  children' = children
+  index' = index
 }
```

We need to do this because of the behavior we observed at first: if we don't control the next state of every varying thing in our model, Alloy allows it to change in arbitrary ways. This can be annoying, but so far I've found it's something I can get over in order to get the useful stuff Alloy can do.

But now that we have that done, we can add blobs and trees to the index:

```alloy
pred updateIndex[bt: Blob + Tree] {
  index' = index + Repo->bt

  // frame
  Blob' = Blob
  Tree' = Tree
  children' = children
}
```

Our action here is saying “the next version of `stage` is the old version plus the addition of `bt`.” We haven't seen `->` before in this post; it means “all of `Repo` maps to all of `bt`.” It so happens that we have only one thing in each of those sets, so this is effectively saying “add the mapping of repo-to-bt to the index.”

<aside>

If you want a firmer technical term, `->` gives you the *Cartesian product* of the two sides. That means `{a, b}->{1, 2}` would be `{a->1, a->2, b->1, b->2}`

</aside>

Now that we have an index, let's take care of `write-tree`:

```alloy
pred writeTree {
  one t: Tree' - Tree {
    Tree' = Tree + t
    children' = children + t->Repo.index
  }

  // frame
  Blob' = Blob
  index' = index
}
```

A couple of details here:

- We're dancing around a little by saying “I want one tree in `Tree'` that doesn't exist in `Tree`, and then that `Tree'` is only changed by that new tree.” I feel this is a little awkward but it's the best way I can find to get exactly one new thing. If you're an Alloy expert reading this and know a better way to do this, I'd really appreciate it if you could let me know!
- Since `->` maps *all* of the left- and right-hand sides, this time we're saying “our new tree has all the things currently in the index.”

With that taken care of, we need to unstage the items afterward. One final action:

```alloy
pred resetIndex {
  no index'

  // frame
  Blob' = Blob
  Tree' = Tree
  children' = children
}
```

Now, finally, we can add these predicates to the list of conditions that Alloy will consider at every time step:

```diff
 pred traces {
   init
   always {
     stutter
     or hashObject
+    or (one bt: Blob + Tree | updateIndex[bt])
+    or writeTree
+    or resetIndex
   }
 }
```

At this point, I'd usually show some instances from the visualizer and ask if we thought they were reasonable, but that gets harder to do as you add more ways for the system to change. Instead, we're going to jump right into…

## Making Assertions

Remember how we had this `fact` back in the static version of the model?

```alloy
fact "trees cannot refer to themselves" {
  no t: Tree | t in t.^children
}
```

We added this because it didn't look like it was in the design of Git for trees to refer to themselves (that is, appear in their own children, grandchildren, etc.) Well, now that we're modeling operations instead of the data structures alone, we can ask Alloy to think about all the state transitions in the system and tell us whether that's allowed:

```
check TreesCannotReferToThemselves {
  always (no t: Tree | t in t.^children)
}
```

Remembering that `always` means “true at this time and forever after”, we're asking it to check if there's any series of time steps where a tree can appear in its own `children`.

Alloy can't find a counterexample for this—yay! Here's what that looks like:

```
Executing "Check TreesCannotReferToThemselves"
   Solver=minisatprover(jni) Steps=1..10 Bitwidth=4 MaxSeq=4 SkolemDepth=1 Symmetry=20 Mode=batch
   1..10 steps. 27665 vars. 1790 primary vars. 67627 clauses. 275ms.
   No counterexample found. Assertion may be valid. 45ms.
   . contains 9 top-level formulas. 10ms.
```

Let's also check that the content of trees cannot change with any of our operations. This is as much a unit test of our modeling as it is a property of Git:

```alloy
check TreesAreImmutable {
  always (all t: Tree | always t.children = t.children')
}
```

And again, no counterexample found.

Finally, let's do something a little trickier. We said it should be OK for files to have the same children—we assume that they'll have different filenames. We can ask Alloy to generate this as a counterexample, just to make sure it's possible. To do this, we make the opposite assertion (that two distinct trees can't have the same children):

```alloy
check NoDuplicateTrees {
  always (no disjoint t1, t2: Tree | t1.children = t2.children)
}
```

We get a counterexample, but not the one we wanted: it turns out that in our model you can call `write-tree` over and over and get a new tree each time. If you do that in a real repo you'll just the same tree over and over.

We could deal with this in a few ways:

- We could add a guard condition to `writeTree` so that it cannot be true if more than one empty tree would be produced. **BUT** in real life, Git allows you to call `write-tree` at any time.
- We could add a precondition to `traces` to do the same, **BUT** that models someone just never does the wrong thing, so I'd rather assume that anything can be called at any time.
- We could add a `fact` about empty trees, **but** every fact we have introduces assumptions to our model.

In this case, I think adding a `fact` is worth it, since we don't represent the behavior of empty trees accurately now and introducing a fact helps with accuracy. Here's how we do it:

```alloy
fact "there can only be one empty tree" {
  always lone t: Tree | no t.children
}
```

This hinges on `lone` enforcing that there will be zero or one `Tree`s matching this description. We could also say `no disjoint t1, t2: Tree | no t1.children and no t2.children`, but that's a bit of a mouthful.

With the addition of the fact, though, I only see the kinds of traces in the instance viewer that I was expecting. For example:

1. Start off with nothing:

   ![An instance with only the repo.](/images/git-trace-0.png)

2. hash an object:

   ![An instance with the repo and a single blob.](/images/git-trace-1.png)

3. stage the object:

   ![The previous instance, but with the blob staged.](/images/git-trace-2.png)

4. write a tree:

   ![The previous instance, but with a tree pointing to the blob. The tree is labeled "no duplicate trees t2"](/images/git-trace-3.png)

5. without resetting, write another tree:

   ![The previous instance, with an additional tree pointing to the blob. The tree is labeled "no duplicate trees t1"](/images/git-trace-4.png)

I think we're good at this point! Just to recap, today we've modeled:

1. blobs and `hash-object`
2. the plumbing we need to make trees—a repo, the index, staging, and resetting
3. trees and `write-tree`

Next time we'll go a bit further by adding commits. Stay tuned!

Before I leave you, though, here's the complete model from this post. It's quite a bit longer than other ones we've worked with, but it's also doing way more:

```alloy
var sig Blob {}

pred hashObject {
  one Blob' - Blob

  // frame
  Tree' = Tree
  children' = children
  index' = index
}

var sig Tree {
  var children: set Blob + Tree,
}

fact "there can only be one empty tree" {
  always lone t: Tree | no t.children
}

one sig Repo {
  var index: set Blob + Tree,
}

pred updateIndex[bt: Blob + Tree] {
  index' = index + Repo->bt

  // frame
  Blob' = Blob
  Tree' = Tree
  children' = children
}

pred writeTree {
  one t: Tree' - Tree {
    Tree' = Tree + t
    children' = children + t->Repo.index
  }

  // frame
  Blob' = Blob
  index' = index
}

pred resetIndex {
  no index'

  // frame
  Blob' = Blob
  Tree' = Tree
  children' = children
}

pred init {
  no Blob
  no Tree
  no children
}
 
pred stutter {
  Blob' = Blob
  Tree' = Tree
  children' = children
  index' = index
}

pred traces {
  init
  always {
    stutter
    or hashObject
    or (one bt: Blob + Tree | updateIndex[bt])
    or writeTree
    or resetIndex
  }
}

fact { traces }

check TreesCannotReferToThemselves {
  always (no t: Tree | t in t.^children)
}

check TreesAreImmutable {
  always (all t: Tree | always t.children = t.children')
}

check NoDuplicateTrees {
  always (no disjoint t1, t2: Tree | t1.children = t2.children)
}
```

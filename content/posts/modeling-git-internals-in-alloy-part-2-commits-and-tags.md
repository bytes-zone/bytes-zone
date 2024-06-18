+++
title = "Modeling Git Internals in Alloy, Part 2: Commits and Tags"
date = 2023-04-10
description = "Understanding Git better by using lightweight formal methods"

[extra]
project = "learning Alloy"
+++

[Last week](@/posts/modeling-git-internals-in-alloy-part-1-blobs-and-trees.md), we started modeling Git's internals in [Alloy](@/posts/alloy.md). We added blobs (to store content) and trees (to organize it into a filesystem.) We ended up with this model:

```alloy
abstract sig Object {}

sig Blob extends Object {}

sig Tree extends Object {
  children: set Object
}

fact "trees cannot refer to themselves" {
  no t: Tree | t in t.^children
}
```

… which produces instances that look like this:

![an Alloy instance showing a tree containing another tree and a blob. The child tree contains a second blob.](/images/normal-trees-and-blobs.png)

Today, we're going to add commits and tags to this model!

## Commits

Going back to [the _Git Internals - Git Objects_ chapter of the Git book](https://book.git-scm.com/book/en/v2/Git-Internals-Git-Objects), we can take a tree hash we produced in the last post and make a commit with `git commit-tree`:

```
$ git commit-tree 3ee29075 -m 'Commit message'
8cc0d4f4ddfde6efa9a8fced667d4d51574a36ec
```

We can add more commits (and history) by repeating this command, but specifying a parent ID for each subsequent commit.

```
$ git commit-tree 3ee29075 -m 'Second commit' -p 8cc0d4
bc8d9d27a206d0e933be3e445c82cbef09da54d1

$ git commit-tree 3ee29075 -m 'Third commit' -p bc8d9d
844bcca25118c27b0322aacd49edb73d8fac827f
```

Then we can view the lineage of the most recent commit with `git log`:

```
$ git log 844bcc
commit 844bcca25118c27b0322aacd49edb73d8fac827f
Author: Brian Hicks <brian@brianthicks.com>
Date:   Fri Mar 3 12:36:14 2023 -0600

    Third commit

commit bc8d9d27a206d0e933be3e445c82cbef09da54d1
Author: Brian Hicks <brian@brianthicks.com>
Date:   Fri Mar 3 12:35:49 2023 -0600

    Second commit

commit 8cc0d4f4ddfde6efa9a8fced667d4d51574a36ec
Author: Brian Hicks <brian@brianthicks.com>
Date:   Fri Mar 3 12:32:37 2023 -0600

    Commit message
```

But… would it work to commit a blob hash, or does it only work with tree? The book doesn't say, so I tried, and it looks like the hash you pass in as the first argument to git commit-tree must be a tree. If you try to make a commit based on a blob, git won't let you:

```
$ git cat-file -p 3ee29075
100644 blob 39528abd81b13b2731d47f86206351a61f1e6484    hello-alloy.txt
100644 blob 9b4b40c2bca67e781930105fa190b9b90235cfe5    hello-blob.txt

$ git cat-file -p 39528a
Hello, Alloy!

$ git commit-tree 39528a -m 'Can you commit a blob?'
fatal: 39528abd81b13b2731d47f86206351a61f1e6484 is not a valid 'tree' object
```

So it looks like a commit has to have a tree, a message, and zero or more parents (you can have more than one; this is how merge commits work.) All this is confirmed by `man git-commit-tree`! We'll leave messages out of our model because they don't matter for any properties we might care about, but otherwise we'll add this to our model:

```alloy
sig Commit extends Object {
  parent: set Commit,
  tree: one Tree,
}
```

### Finding mismatches between Git's model and ours

Let's look at the instances Alloy produces and see if we think any of that feels off. To start, we get relatively normal-looking instances, such as two commits with the same tree:

![An Alloy instance showing two commits referencing the same tree.](/images/two-commits-pointing-to-the-same-tree.png)

But we also get some wilder instances. For example, it looks like our model allows trees to have commits as children:

![An Alloy instance showing a tree with a commit as a child.](/images/tree-with-commit-child.png)

I'm not sure whether that'd be allowed, but it's easy to verify by asking Git to add a commit to the staging area:

```
$ git update-index --add --cacheinfo 100644 \
  8cc0d4 commits-are-stageable.txt
fatal: git update-index: --cacheinfo cannot add 8cc0d4
```

Nope, doesn't work. That's fine. We'll just update our definition of `Tree` to say that they can't have commits as children. Since we're dealing with sets here, we can write “all objects besides commits” as `Object - Commit`, which makes the new definition of `Tree` look like this:

```alloy
sig Tree extends Object {
  children: set Object - Commit
}
```

That's not all the weirdness taken care of, though: we also get commits which are their own parents, or cycles of commits who are each other's parents:

![An Alloy instance showing a commit which has itself as a parent.](/images/commits-who-are-their-own-parents.png)

Like last time, this is _technically_ possible: if you can find just the right content for the commit messages and trees, you could conceivably get a commit to refer to itself. Like before, though, this is likely to break git in some awful ways (segfaults!) If we were modeling Git to try to find bugs or security vulnerabilities, I'd say we should allow this. But, as before, we're trying to learn how this is _supposed_ to work, so let's disallow it in the same way we disallowed trees being their own parent:

```alloy
fact "commits can't be their own parent" {
  no c: Commit | c in c.^parent
}
```

## Tags

With commits done, we have only one more object type to model: the tag. Tags are like commits, but instead of pointing to a tree and parent they point to a commit, and you can move them later (as opposed to everything else we've seen so far, which is immutable.) Here's how we'd model that:

```alloy
sig Tag extends Object {
  commit: one Commit,
}
```

Running the model like this shows that we've implicitly allowed trees to contain tags (because now `Object - Commit` includes `Tag`) which we didn't mean. We _could_ say `Object - Commit - Tag`, but at this point I think it'd be better to rephrase `Tree.children` to contain only what we want:

```alloy
sig Tree extends Object {
  children: set Blob + Tree,
}
```

Now we can get tags on commits. Yay!

![An Alloy instance showing a tag attached to a commit.](/images/tagged-commit.png)

We've now reached the end of the first part of our Git-modeling journey: we have all the objects! (There are also refs, though, which work like tags but aren't stored with the git objects. You can read more about those in [the Git Internals - Git References chapter of the Git book](https://book.git-scm.com/book/en/v2/Git-Internals-Git-References).)

Here's the model we're finishing with:

```alloy
abstract sig Object {}

sig Blob extends Object {}

sig Tree extends Object {
  children: set Blob + Tree,
}

fact "trees cannot refer to themselves" {
  no t: Tree | t in t.^children
}

sig Commit extends Object {
  parent: set Commit,
  tree: one Tree,
}

fact "commits can't be their own parent" {
  no c: Commit | c in c.^parent
}

sig Tag extends Object {
  commit: one Commit,
}
```

From here, our next step is to model the operations we can take on this model to check if the properties we wrote earlier actually hold when we use Git's commands. Stay tuned!

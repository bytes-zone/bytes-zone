+++
title = "fields as sets"
date = 2023-02-13

[extra]
project = "learning Alloy"
+++

Today, let's look at how relationships between `sig`s in [Alloy](@/projects/learning-alloy.md) work.

Say, for example, you're modeling database tables ([as I have previously](@/posts/modeling-database-tables-in-alloy.md)) and want to represent the relationship between people and their favorite flavor of ice cream:

```alloy
sig Person {
  favoriteIceCream: lone Flavor,
}

sig Flavor {}
```

You can ask Alloy for examples of this, and it will show you a bunch of different ways `Person` and `Flavor` can be related. For example, here's an instance where there are three distinct people who each like a different flavor:

![an Alloy instance describing three people, each with a distinct favorite ice cream flavor. The people and flavors are not connected otherwise.](/images/three-people-three-flavors.png)

The `favoriteIceCream` relationship here can be used in a bunch of interesting ways. For example, if we want to assert (contrary to our use of `lone`) that everybody has a favorite ice cream flavor, we'd do it like this:

```
check NobodyDoesntLikeIceCream {
  all p: Person | some p.favoriteIceCream
}
```

Alloy finds a counterexample for this (since we used `lone`, which means some people don't have a favorite flavor of ice cream), but it demonstrates the first usage of the relation: looking up fields as if they were methods or attribute accesses in an object-oriented language. `x.fieldName` will always work basically like you might have already intuited.

Relations can do more than this, though, since they're actually secretly sets of tuples. If you load up the instance above in Alloy and examine it in the table view, you'll see that it's defined something like this:

| `this/Person` | `favoriteIceCream` |
| ------------- | ------------------ |
| `Person$0`    | `Flavor$2`         |
| `Person$1`    | `Flavor$1`         |
| `Person$2`    | `Flavor$2`         |

This looks suspiciously like a table in a database, right? Well, good news: it basically works that way too!

What `.` does under the hood is essentially equivalent to a SQL join: it selects rows matching a pattern on the left and gives you access to the equivalent rows on the right.

The cool thing about `.` is that it can do this with a set in either position. Even though it *looks like* you're using a single value with `p.favoriteIceCream`, `p` is actually a subset of people—it just happens to be one with only one member.

So what other sets can you do this to? Well, if we add a `children` field like this:

```
sig Person {
  children: set Person,
  favoriteIceCream: lone Flavor,
}
```

We could look at some parent `p` and get the ice cream flavors they'd need to buy for their children with `p.children.favoriteIceCream`, or their grandchildren with `p.children.children.favoriteIceCream`. Chaining works in the way you'd expect, except with set semantics instead of having to do loops or list comprehensions.

We could also get the set of reachable ice cream flavors by using the whole set of `Person` on the left: `Person.favoriteIceCream`. We could also get the sad, lonely flavors that nobody loves with `Flavor - Person.favoriteIceCream`.

That's not all you can do, though. The `~` operator flips a relation around: if `favoriteIceCream` is a mapping from `Person` to `Flavor`, `~favoriteIceCream` is one from `Flavor` to `Person`. We can then do the same tricks as above. For example, we can find out who doesn't like ice cream at all by doing `Person - Flavor.~favoriteIceCream` (since that will be all the people, minus the people who have a favorite ice cream set.)

For me, realizing that basically everything is a set, and that `~` and `.` worked set-wise unlocked a lot of uses for Alloy that I hadn't considered before. I hope reading this helped you, too!

By the way, we haven't even gone over all the interesting things you can do: [Hillel Wayne's documentation site](https://alloy.readthedocs.io) has a big section on [sets and relations](https://alloy.readthedocs.io/en/latest/language/sets-and-relations.html#sets-and-relations) that's worth a read if you'd like to learn more.
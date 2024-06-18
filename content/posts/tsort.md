+++
title = "tsort"
date = 2023-09-25
summary = "topological ordering for fun and profit"
+++

On the command line, you can use `tsort` to sort a graph into a list (a topological ordering.) Say you have this chart showing what you need to get dressed:

![A graph of dependency relationships among pieces of clothing. It shows you need an undershirt to put on a shirt, shirt to put on a tie, underwear to put on pants, pants to put on a belt, and socks to put on shoes.](/images/tsort-clothes.png)

You can write all those arrows down in a file as dependencies (in order of "X blocks Y," for example "Shirt blocks Tie," "Socks block Shoes.")

```
Shirt Tie
Undershirt Shirt
Shirt Belt
Pants Belt
Underwear Pants
Socks Shoes
Pants Shoes
```

If you pass that to `tsort` you get this, one order in which you could put on clothes to get dressed:

```
Socks
Undershirt
Underwear
Shirt
Pants
Tie
Shoes
Belt
```

It kinda suggests lanes of parallelism, too. For example, you could hypothetically put socks, undershirt, and underwear at the same time. Granted, you'd have to have some machine like in Wallace and Gromit in _The Wrong Trousers_, but that turned out so well for them! 😆

On a more serious note, I've used this to order tasks in projects in [Linear](https://linear.app). Combined with blocker relationships, it makes it clear to everyone which tasks should go first.

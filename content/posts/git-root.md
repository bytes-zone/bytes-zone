+++
title = "git root"
date = 2020-09-10
description = "getting back to the root of a project quickly"
+++

I sometimes find myself in a situation where I've `cd`'d several levels into a project and don't remember exactly where I am, but I want to get back to the project root for my next command.
This doesn't come up for me _alllll_ the time, but the last time it did I decided to do something about it.

<!-- more -->

To cut this short: if you run `git rev-parse --show-toplevel`, `git` will print out the location you cloned the repo.
In other words, if you run `git clone https://git-host.com/user/project.git ~/code/project`, that command will return `~/code/project`.

So I've just added that to my aliases: `root = "rev-parse --show-toplevel"`.
Now I can do `git root` or `cd $(git root)`.
That makes this problem much less annoying for me!

Someone pointed out to me that I can probably also add an alias in my shell like `alias cdroot='cd $(git root)'` to make this even easier, but I haven't felt the need for that as urgently yet.

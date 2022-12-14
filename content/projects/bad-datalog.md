+++
title = "bad-datalog"
description = "a datalog in Elm"
date = 2020-08-06
updated = 2022-06-14

[extra]
when = "past"
+++

In 2020, I got really interested in Datalog implemenations after reading Pete Vilter's [Codebase as Database: Turning the IDE Inside Out with Datalog](https://petevilter.me/post/datalog-typechecking/).
I did a bunch of reading about different ways to make a Datalog.

Eventually [Jamie Brandon](https://www.scattered-thoughts.net/) advised me to make a miniature relational database and lower (raise?) the datalog layer to it.
That approach got me way further than I had gotten before!
It ended up being released to the public (though not on the Elm package site) as [bad-datalog](https://git.bytes.zone/brian/bad-datalog), which you can play with at [datalog.bytes.zone](https://datalog.bytes.zone/).

I'm really glad I did this project; I learned a lot about the things that databases have to do to plan and execute a query, and got some experience with a fun relational language in the bargain.
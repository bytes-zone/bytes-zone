+++
title = "elm-csv"
description = "a CSV parser"
date = 2021-01-19
updated = 2021-11-23

[extra]
when = "past"
+++

In early 2021, I was working on a page at [NoRedInk](https://noredink.com) that let our curriculum team import big batches of updates to premade assignments for teachers to use.
The page was taking _for-ev-er_ to work since the CSV parser we were using at the time was fairly slow.
I decided to fix it that!

I ended up publishing the resulting code as [BrianHicks/elm-csv](https://github.com/BrianHicks/elm-csv), a CSV decoding package that works like Elm's [JSON decoders](https://package.elm-lang.org/packages/elm/json/latest/).
It's super fast—there's a lot of hand-rolled character-wise parsing work to thank for that—and at the time of publishing was the only CSV package for Elm that didn't force you to separate character parsing from interpretation.

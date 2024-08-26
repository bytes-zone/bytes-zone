+++
title = "elm-duet"
description = "type syncing between Elm and TypeScript"
date = 2024-04-01
updated = 2024-05-07

[extra]
when = "past"
+++

While building tinyping, I had a lot of trouble syncing complex types between Elm and TypeScript, so I started building elm-duet.
It takes a [JSON Type Definition](https://jsontypedef.com/) schema and generates both Elm and TypeScript type definitions so the system can be type-checked end-to-end.

You can get source and binary releases for many platforms at [BrianHicks/elm-duet](https://github.com/BrianHicks/elm-duet).

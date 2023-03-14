+++
title = "aligning Markdown tables in Helix"
description = "multiple cursors for the win!"
date = 2023-03-13
+++

One of the things I like most about using [Helix](https://helix-editor.com/) (and [Kakoune](https://kakoune.org/), when I used it before) is the multiple cursor support. I use them whenever I can! Today, I want to share how Helix solves a common task: formatting a Markdown table.

When I first write Markdown tables, they tend to look like this (with some data from [this LEGO Database on Kaggle](https://www.kaggle.com/datasets/rtatman/lego-database?select=parts.csv).) Ragged-right formatting and just enough syntax for a parser to tell the headers from the rows:

```markdown
| ID | Name | Category ID |
|-|-|-|
| 11092 | Gorilla Fist | 27 |
| 11212 | Plate 3 x 3 | 14 |
| 11209 | Tyre 21 x 9.9 | 29 |
| 11640pr0003 | ELECTRIC GUITAR SHAFT Ø3.2 NO. 3 | 27 |
```

This looks fine when rendered, but it's somewhat annoying in the source. In other editors I've used, you either need to do the alignment by hand (tedious!) or use some plugin. In Helix and Kakoune, doing this is fairly simple: you just need to combine some editing primitives.

Bottom-line-up-front, the key sequence is `mips\|<ret>&`. But that looks just like line noise, so let's break it down:

First, I hit `mip` to select the whole paragraph, then select pipes (`s\|<ret>`.) That gives me one selection per pipe character:

![screenshot of Helix, in which each pipe character from the code sample above is selected by a rectangular cursor.](/images/one-selection-per-character-in-a-markdown-table.png)

Then I hit `&`, the “align selections” operator, which gets me the final alignment:

```markdown
| ID          | Name                             | Category ID |
|-            |-                                 |-            |
| 11092       | Gorilla Fist                     | 27          |
| 11212       | Plate 3 x 3                      | 14          |
| 11209       | Tyre 21 x 9.9                    | 29          |
| 11640pr0003 | ELECTRIC GUITAR SHAFT Ø3.2 NO. 3 | 27          |
```

This still renders just fine, but it's a little nicer reading experience to have the line separating the headers from the body rows full of hyphens. That one's easy too: after dismissing the selections with `,`, you can navigate to the row, hit `x` to select the whole line, then `s` to select characters, enter space as the section, and `r-` to replace all the selections with hyphens. Now it's a perfectly nice Markdown table that's very pleasant to read in the source:

```markdown
| ID          | Name                             | Category ID |
|-------------|----------------------------------|-------------|
| 11092       | Gorilla Fist                     | 27          |
| 11212       | Plate 3 x 3                      | 14          |
| 11209       | Tyre 21 x 9.9                    | 29          |
| 11640pr0003 | ELECTRIC GUITAR SHAFT Ø3.2 NO. 3 | 27          |
```
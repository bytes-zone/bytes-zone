+++
title = "Scope in the TH element"
description = "Making more accessible tables"
date = 2022-12-19
+++

The `<th>` (table head) element in HTML accepts a `scope` attribute. [According to MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/th#attr-scope), it can be one of these:

- `row` and `col`, which means that the header relates to all the cells of the group (row or column, respectively) in which it's found
- `rowgroup` and `colgroup`, which specifies a group of rows or columns. I'm not sure how to make a group like this, though!

`<th scope="row">` can be really useful for accessibility. Say you have a table like this:

| Name             | Text-to-speech enabled | Edit student |
|:---------------- |:----------------------:|:------------:|
| Valencia Flowers | yes                    | `<button>`   |
| Romeo Harrison   | no                     | `<button>`   |

If the "name" cells are `<th scope="row">`, screen readers can contextualize "yes" or "no" and the edit button when navigating between rows in a non-name column. For example, one might say something like "text-to-speech enabled, Valencia Flowers, row, yes."
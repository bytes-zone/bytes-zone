+++
title = "sticky table headers with bottom borders"
date = 2023-11-13
description = "CSS! So full of fun!"
+++

Say you have a table like this:

```html
<table>
  <thead>
    <tr>
      <th>Column 1</th>
      <th>Column 2</th>
      <th>Column 3</th>
    </tr>
  </thead>
  <tbody>
    <!-- ... -->
  </tbody>
</table>
```

You might try to separate the header from the body like this:

```css
table.fancy > thead > tr {
  border-bottom: 1px solid #ccc;
}
```

That works, but what if you want the `<thead>` element to have [`position: sticky`](https://developer.mozilla.org/en-US/docs/Web/CSS/position#values) too? If you used a border, the border will keep scrolling while the header sticks. Oh no!

I got around this by using `box-shadow` instead. It works, despite feeling a little hacky:

```css
table.fancy > thead > tr {
  box-shadow: inset 0px -1px #ccc;
}
```

Except that Safari won't display the shadow below the header. More hacks required! Apply the shadow to all the cells inside it:

```css
table.fancy > thead td {
  box-shadow: inset 0 -1px #ccc;
}
```

This feels even hackier than the original fix, but it works fine in all the browsers that I tested!

+++
title = "tree-grepper"
description = "search by AST nodes instead of strings"
date = 2021-08-31
+++

A while ago I wanted to extract all the imports and module names from all the Elm files in a project to build an import graph.
The code I wrote ended up working fine, but it was also pretty messy... tons of big regular expressions to make sure I got all the corner cases and places you could put whitespace in declarations.
I thought there probably was a better way, especially since I had just learned about [tree-sitter](https://tree-sitter.github.io/tree-sitter/).I also wanted to learn some Rust, so... well, sounds like a fun little project!

Fast forward about a year and I just released [`tree-grepper` 2.0.0](https://github.com/BrianHicks/tree-grepper)!
It lets you search very quickly across large projects full of diverse filetypes, using tree-sitter parsers and search queries.

The big benefit here is that it's easy to expand: tree-sitter is getting really popular, what with language servers and [Neovim extensions](https://neovim.io/doc/treesitter/) and everything, so it's pretty likely that someone has already built a parser that we can just add in the future!
Currently tree-grepper lets you search Elm, Haskell, JavaScript, Ruby, Rust, and TypeScript, but it's pretty easy to add more, and [the README has a step-by-step guide](https://github.com/BrianHicks/tree-grepper#supported-languages).

## Extracting An Import Graph

So, let me show off what it can do a little bit by implementing the parsing task I set out to do originally!

Tree-sitter implements an [s-expression query API](https://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries) which tree-grepper exposes directly.
We'll use that to query for all the imports in [NoRedInk/noredink-ui](https://github.com/noredink/noredink-ui):

```bash
$ tree-grepper --query elm '(import_clause)' | head -n 5
./styleguide-app/Category.elm:18:0:query:import Sort exposing (Sorter)
./styleguide-app/Main.elm:2:0:query:import Accessibility.Styled as Html exposing (Html, img, text)
./styleguide-app/Main.elm:3:0:query:import Browser exposing (Document, UrlRequest(..))
./styleguide-app/Main.elm:4:0:query:import Browser.Dom
./styleguide-app/Main.elm:5:0:query:import Browser.Navigation exposing (Key)
```

What we're doing here is asking `tree-grepper` to give us all the `import_clause` nodes it finds in `elm` files (I'll tell you how to find the names of nodes later.)
Each match gets printed as a single line of text (well, maybe multiple if the node is on multiple lines!) along with the exact position in the source file.

We don't want *all that*, though, so let's just try and get the module name:

```bash
$ tree-grepper --query elm '(import_clause (upper_case_qid)@import)' | head -n 5
./styleguide-app/Category.elm:18:7:import:Sort
./styleguide-app/Main.elm:2:7:import:Accessibility.Styled
./styleguide-app/Main.elm:3:7:import:Browser
./styleguide-app/Main.elm:4:7:import:Browser.Dom
./styleguide-app/Main.elm:5:7:import:Browser.Navigation
```

So now we're asking for `upper_case_qid` nodes inside `import_clause`s.
If we tag the nodes we care about (by naming them after an `@`), `tree-grepper` will only output the parts we tagged.

So far, so good!
But how about module names too?
Easy: just add another `--query`!

```bash
$ tree-grepper \
    --query elm '(import_clause (upper_case_qid)@import)' \
    --query elm '(module_declaration (upper_case_qid)@module)' \
    | head -n 5
./styleguide-app/Category.elm:0:7:module:Category
./styleguide-app/Category.elm:18:7:import:Sort
./styleguide-app/Main.elm:0:7:module:Main
./styleguide-app/Main.elm:2:7:import:Accessibility.Styled
./styleguide-app/Main.elm:3:7:import:Browser
```

This follows the same pattern: we want a named child of some random node in the file, and `tree-grepper` manages walking the tree and gives it to us.

## JavaScript Imports

What about JS `import` clauses?
We can mix different languages as easily as we mix different queries, but let's simplify down to show more features:

```bash
$ tree-grepper --query javascript '(import_statement (string (string_fragment)@import) .)'
./lib/TextArea/V4.js:0:31:import:../CustomElement
```

This is the end of a `import * as Foo from "Bar"` clause.
The `.` at the end is an anchor.
It just tells tree-sitter "I care that the thing I'm matching is the last child of its parent node!"

We're also matching a string fragment out of the string we require.
This lets us remove any quoting characters so we get `../CustomElement` out instead of `'../CustomElement'`.

## JavaScript Requires

Finally, let's get `require` calls (something we have far more of in this code):

```bash
$ tree-grepper --query javascript '(call_expression (identifier)@_fn (arguments . (string (string_fragment)@require) .) (#eq? @_fn require))' | head -n 5
./styleguide-app/manifest.js:0:8:require:../lib/index.js
./script/percy-tests.js:0:28:require:@percy/script
./script/axe-puppeteer.js:3:26:require:puppeteer
./script/axe-puppeteer.js:4:24:require:axe-core
./script/axe-puppeteer.js:5:36:require:url
```

This is quite the query!
Let's break it up over multiple lines and talk about it:

```lisp
(call_expression
  (identifier)@_fn
  (arguments . (string (string_fragment)@require) .)
  (#eq? @_fn require))
```

`(call_expression (identifier) (arguments))` is a function or method call, in our case `require("url")`.
However, without anchors or specifying the arguments we're not saying anything about the contents.
In this case, we want only a single string, so we specify that as `(arguments . (string (string_fragment)@require) .)`.

Finally, we don't want just *any* function with a single string argument; we only want `require` statements.
Tree-sitter exposes a couple of matcher functions (`#eq?` for string equality and `#match?` for regular expressions) to select the things we want here, but they work on matches.
That's OK, though, we can extract the identifier by tagging it as `@_fn`.
(The leading underscore here tells `tree-grepper` to omit matches with this name from the output.)
We give our match and a bare word matching what we want (`require`) to `#eq?` and we're done!
Now we only get things that look like `require('axe-core')`, and pull out the `axe-core` string!

## Putting It All Together

Of course, we can do this all at once, smashing all our queries together in one giant `tree-grepper` invocation.

```bash
$ tree-grepper \
    --query elm '(import_clause (upper_case_qid)@import)' \
    --query elm '(module_declaration (upper_case_qid)@module)' \
    --query javascript '(import_statement (string (string_fragment)@import) .)' \
    --query javascript '(call_expression (identifier)@_fn (arguments . (string (string_fragment)@require) .) (#eq? @_fn require))' \
    | head -n 5
./styleguide-app/Category.elm:0:7:module:Category
./styleguide-app/Category.elm:18:7:import:Sort
./styleguide-app/Main.elm:0:7:module:Main
./styleguide-app/Main.elm:2:7:import:Accessibility.Styled
./styleguide-app/Main.elm:3:7:import:Browser
```

That works for any amount of queries you'd care to throw at it!
In fact, it's more efficient to run this way since it only has to walk the filesystem and parse files once!

You can also get more information by specifying the format: the `json` and `pretty-json` formats have match end locations as well as starts, and they include the node names returned.
You can use that to get an overview of all the node names in a grammar:

```bash
$ echo 'console.log("Hello, World!")' > hello.js
$ tree-grepper --query javascript '(_)' --format pretty-json hello.js
[
  {
    "file": "hello.js",
    "file_type": "javascript",
    "matches": [
      {
        "kind": "program",
        "name": "query",
        "text": "console.log(\"Hello, World!\")\n",
        "start": {
          "row": 0,
          "column": 0
        },
        "end": {
          "row": 1,
          "column": 0
        }
      },
      ... snip ...
    ]
  }
]
```

I've actually had to shorten that significantly because it's so long!
If you'd like to see some full output, check the ["all_{language}.snap" snapshot test files in the tree-grepper repo](https://github.com/BrianHicks/tree-grepper/tree/main/src/snapshots).

I really enjoyed writing this tool and learning more about tree-sitter, and I hope you find it useful!
Tree-grepper is packaged using Nix, so if you have that you can just install it like `nix-env -if https://github.com/BrianHicks/tree-grepper/archive/refs/heads/main.tar.gz`.
You can also get the source and instructions for contributing at [github.com/BrianHicks/tree-grepper](https://github.com/BrianHicks/tree-grepper).

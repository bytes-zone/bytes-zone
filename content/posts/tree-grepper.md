+++
title = "tree-grepper"
description = "search by AST nodes instead of strings"
date = 2021-08-31

[extra]
featured = true
+++

A while ago I wanted to build an import graph from all the frontend code at NoRedInk to build some developer tools.
The code I wrote ended up working fine, but it was also pretty messy&hellip; tons of big regular expressions to make sure I got all the corner cases and whitespace allowed in the syntax.
I thought there probably was a better way, especially since I had just learned about [tree-sitter](https://tree-sitter.github.io/tree-sitter/).
I also wanted to learn some Rust, so&hellip; well, it sounded like a fun little project!

Fast forward about a year and I just released [`tree-grepper` 2.0.0](https://github.com/BrianHicks/tree-grepper)!
It lets you search very quickly across large projects full of diverse filetypes, using tree-sitter grammars and search queries.

The big benefit here is that it's easy to expand: tree-sitter is getting really popular, what with language servers and [Neovim extensions](https://neovim.io/doc/treesitter/) and everything, so it's pretty likely that someone has already built a parser that we can just add!
Currently tree-grepper lets you search Elm, Haskell, JavaScript, Ruby, Rust, and TypeScript, but it's pretty easy to add more, and [the README has a step-by-step guide](https://github.com/BrianHicks/tree-grepper#supported-languages).

Tree-grepper is focused only on search: it doesn't do linting (like [semgrep](https://semgrep.dev)) or AST-based refactoring (like [comby](https://comby.dev/).)
You can get structured match data out of it, but any further processing is another tool's responsibility.
This let me cut down on scope significantly, and optimize for searching alone.
Hooray for the Unix philosophy!

## Extracting An Import Graph

Let me show off what it can do a little bit by implementing the parsing task I set out to do originally!

Tree-sitter implements an [s-expression query API](https://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries) which tree-grepper exposes directly.
We'll use that to query for all the imports in [NoRedInk/noredink-ui](https://github.com/noredink/noredink-ui):

```bash
$ tree-grepper --query elm '(import_clause)' | head -n 5
./styleguide-app/Category.elm:18:1:query:import Sort exposing (Sorter)
./styleguide-app/Main.elm:3:1:query:import Accessibility.Styled as Html exposing (Html, img, text)
./styleguide-app/Main.elm:4:1:query:import Browser exposing (Document, UrlRequest(..))
./styleguide-app/Main.elm:5:1:query:import Browser.Dom
./styleguide-app/Main.elm:6:1:query:import Browser.Navigation exposing (Key)
```

What we're doing here is asking `tree-grepper` to give us all the `import_clause` nodes it finds in `elm` files (I'll tell you how to find out how this is called an `import_clause` later.)
Each match gets printed as a line of text along with the exact position in the source file.

We don't want the entire match, though, just the module name (the part after `import` but before `as` or `exposing`).
Let's try and get just the module name:

```bash
$ tree-grepper --query elm '(import_clause (upper_case_qid)@import)' | head -n 5
./styleguide-app/Category.elm:18:7:import:Sort
./styleguide-app/Main.elm:3:8:import:Accessibility.Styled
./styleguide-app/Main.elm:4:8:import:Browser
./styleguide-app/Main.elm:5:8:import:Browser.Dom
./styleguide-app/Main.elm:6:8:import:Browser.Navigation
```

So now we're asking for `upper_case_qid` nodes inside `import_clause`s.
If we tag the nodes we care about (by naming them after an `@`), `tree-grepper` will only output the parts we tagged.

So far, so good!
But how about `module Foo exposing (..)` at the tops of files, too?
Easy: just add another `--query`!

```bash
$ tree-grepper \
    --query elm '(module_declaration (upper_case_qid)@module)' \
    --query elm '(import_clause (upper_case_qid)@import)' \
    | head -n 5
./styleguide-app/Category.elm:1:8:module:Category
./styleguide-app/Category.elm:19:8:import:Sort
./styleguide-app/Main.elm:1:8:module:Main
./styleguide-app/Main.elm:3:8:import:Accessibility.Styled
./styleguide-app/Main.elm:4:8:import:Browser
```

This follows the same pattern: we want a named child of another named node in the file, and `tree-grepper` manages walking the tree to give it to us.

## JavaScript Imports

What about JavaScript `import` clauses?
We can mix different languages as easily as we mix different queries, but let's do one at a time for simplicity's sake:

```bash
$ tree-grepper --query javascript '(import_statement (string (string_fragment)@import) .)'
./lib/TextArea/V4.js:1:31:import:../CustomElement
```

This is the end of a `import * as Foo from "Bar"` clause.
The `.` at the end is an anchor: it tells tree-sitter that we care that the thing we're matching is the last child of its parent node.
You can also put a `.` right after the node name to match on the first node only, or on both sides to enforce that you are matching the only node.

We're also matching a string fragment out of the string we require.
This lets us remove any quoting characters so we get `../CustomElement` out instead of `'../CustomElement'`.
We could also put anchors here to make sure we're not getting any interpolated strings, but I haven't needed to do that yet so we're not here either.

## JavaScript Requires

Finally, let's get `require` calls:

```bash
$ tree-grepper --query javascript '(call_expression (identifier)@_fn (arguments . (string (string_fragment)@require) .) (#eq? @_fn require))' | head -n 5
./styleguide-app/manifest.js:1:8:require:../lib/index.js
./script/percy-tests.js:1:29:require:@percy/script
./script/axe-puppeteer.js:4:27:require:puppeteer
./script/axe-puppeteer.js:5:25:require:axe-core
./script/axe-puppeteer.js:6:37:require:url
```

This is quite the query!
Let's break it up over multiple lines to talk about it:

```lisp
(call_expression
  (identifier)@_fn
  (arguments . (string (string_fragment)@require) .)
  (#eq? @_fn require))
```

`(call_expression (identifier) (arguments))` is a function or method call, in our case `require("url")`.
However, without anchors or specifying the arguments we're not saying anything about the contents, just that it's a call.
In this case, we care that the arguments are only a single string, so we specify that as `(arguments . (string (string_fragment)@require) .)`.

Finally, we don't want *just any* function with a single string argument; we only want `require` statements.
Tree-sitter exposes a couple of matcher functions (`#eq?` for string equality and `#match?` for regular expressions) to select the things we want here.
To use them, we name the node we care about (here `@_fn` with a leading underscore to tell tree-grepper to drop it from the output,) then give the match to `#eq?` along with a bare word (`require`) to check for equality.
Now we only match nodes that look like `require('axe-core')`, but only pull out the inner `axe-core` string that we care about!

## Putting It All Together

Of course, we can do this all at once, smashing all our queries together in one giant `tree-grepper` invocation.

```bash
$ tree-grepper \
    --query elm '(import_clause (upper_case_qid)@import)' \
    --query elm '(module_declaration (upper_case_qid)@module)' \
    --query javascript '(import_statement (string (string_fragment)@import) .)' \
    --query javascript '(call_expression (identifier)@_fn (arguments . (string (string_fragment)@require) .) (#eq? @_fn require))' \
    | head -n 5
./styleguide-app/Category.elm:1:8:module:Category
./styleguide-app/Category.elm:19:8:import:Sort
./styleguide-app/Main.elm:1:8:module:Main
./styleguide-app/Main.elm:3:8:import:Accessibility.Styled
./styleguide-app/Main.elm:4:8:import:Browser
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
          "row": 1,
          "column": 1
        },
        "end": {
          "row": 2,
          "column": 1
        }
      },
      ... snip ...
    ]
  }
]
```

I've actually had to shorten that significantly because it's so long!
If you'd like to see some full output, check the [`all_{language}.snap` snapshot test files in the tree-grepper repo](https://github.com/BrianHicks/tree-grepper/tree/main/src/snapshots).

I really enjoyed writing this tool and learning more about tree-sitter, and I hope you find it useful!
You can also get the source and instructions for contributing at [github.com/BrianHicks/tree-grepper](https://github.com/BrianHicks/tree-grepper).

Tree-grepper is packaged using Nix, so if you have that you can just install it like `nix-env -if https://github.com/BrianHicks/tree-grepper/archive/refs/heads/main.tar.gz`.
If you have Nix flakes enabled, you can also run `nix shell github:BrianHicks/tree-grepper` to get a shell with `tree-grepper` already available.

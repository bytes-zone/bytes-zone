+++
title = "nix-script"
date = 2021-02-23
draft = true
+++

I like writing quick little scripts to avoid having to remember how to do things.
Most of the time I start in bash, thinking the task won't be too complicated... but then before I know it I'm having to reread the bash man pages to figure out how arrays work for the thousandth time.

So really, I'd rather write scripts in a language that offers some more safety and programmer ergonomics.
We're trying to learn Haskell at work, so maybe that could work?

Let's see a hello world:

```haskell
#!/usr/bin/env runghc

main :: IO ()
main = putStrLn "Hello, World!"
```

That seems pretty reasonable, and only takes like 300ms to compile and run.
But that's not as fast as a bash script, plus I have to use Haskell's standard prelude instead of something safer like [relude](https://kowainik.github.io/projects/relude) or [nri-prelude](http://hackage.haskell.org/package/nri-prelude).

It's reasonable to solve this, though: I can just use `nix-shell` to get a `ghc` with packages.

```haskell
#!/usr/bin/env nix-shell
#!nix-shell -i runghc -p "(pkgs.haskellPackages.ghcWithPackages (ps: [ ps.text ]))"

{-# LANGUAGE OverloadedStrings #-}

import Data.Text.IO

main :: IO ()
main = Data.Text.IO.putStrLn "Hello, World!"
```

Well, that works, but now run time has ballooned to over 2 seconds!
Eep!

Enter `nix-script`!
It transparently manages a compilation and nix-shell cache for scripts, and lets you specify dependencies and build commands inline using more shebangs!

That means the example above can be rewritten like so:

```haskell
#!/usr/bin/env nix-script
#!buildInputs (pkgs.haskellPackages.ghcWithPackages (ps: [ ps.text ]))
#!build ghc -O -o $OUT_FILE $SCRIPT_FILE

{-# LANGUAGE OverloadedStrings #-}

import Data.Text.IO

main :: IO ()
main = Data.Text.IO.putStrLn "Hello, World!"
```

The first time you run that, it'll compile the script to a binary and run it.
That takes about two seconds on my machine.

The second time you run it, we'll just use the compiled binary.
That takes 30ms or so for me!
Big improvement!

But it's really not that fun to have to figure out that `#!build` line every time, and I always forget how to call `pkgs.haskellPackages.ghcWithPackages` correctly... so there's also a wrapper script called `nix-script-haskell` that makes this nicer:

```haskell
#!/usr/bin/env nix-script-haskell
#!haskellPackages text

{-# LANGUAGE OverloadedStrings #-}

import Data.Text.IO

main :: IO ()
main = Data.Text.IO.putStrLn "Hello, World!"
```

And, in addition to the speed boost, we can depend on any package in the nix ecosystem!
For example, here's how you'd add and call `jq`:

```haskell
#!/usr/bin/env nix-script-haskell
#!runtimeInputs jq

import System.Process

main :: IO ()
main = do
  formatted <-
    readProcess
      "jq"
      ["--color-output", "."]
      "{\"name\": \"Atlas\", \"species\": \"kitty cat\"}"
  putStr formatted
```

It's also pretty easy to create more wrapping interpreters, so we also ship one for bash (even though it's not compiled, we can cache the nix environment with your exact dependencies!)

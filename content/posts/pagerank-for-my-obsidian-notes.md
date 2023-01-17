+++
title = "pagerank for my Obsidian notes"
date = 2023-01-17
description = "Analyzing my Obsidian vault to find the most connected notes."
+++

I recently learned a little more about how the [Pagerank](https://en.wikipedia.org/wiki/PageRank) algorithm works. I thought it was cool, and it made me wonder what the ranks for my [Obsidian](https://obsidian.md) vault looked like, so I built a little tool. It's fairly simple: it just parses `[[links]]` out of the vault with a regex and then uses the [simple-pagerank](https://crates.io/crates/simple-pagerank) crate for Rust to calculate the ranking.

For my vault, the most centrally connected node is my employer. It's the top node by quite a lot (with a score of 4.9), followed by the town where I live (2.0), then members of my family (around 2) and notes on projects I'm doing and tools I use (around 1.) This makes a lot of sense to me; I primarily use Obsidian as a way to keep a work log and write about things related to that, [as I wrote about previously](@/posts/digital-gardening-in-obsidian.md).

If you'd like to try this for yourself, you can get the code at [bytes.zone/brian/obsidian-pagerank](https://git.bytes.zone/brian/obsidian-pagerank), although you'll need to have either [Nix](https://nixos.org) or [Rust](https://www.rust-lang.org/) installed in advance. If you decide to try it, let me know if you find anything interesting!

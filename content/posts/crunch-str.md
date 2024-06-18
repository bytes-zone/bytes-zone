+++
title = "crunch_str"
date = 2023-09-11
description = "mk strs shrt, lik ths"
+++

When writing [montage](@content/montage.md) I wanted to have a little view of my current task up in the task bar with [xbar](https://xbarapp.com/). The GraphQL API made quick work of that—I just asked for the current session and printed it to stdout. Xbar can pick that up and display it, no problem. It looks like this right now as I write this:

![a macOS status bar item saying "write about crunch_str in Montage"](/images/montage-xbar.png)

That's all well and good, but sometimes my sessions have longer names like "scrub active projects and promote inactive ones" or even longer for tickets at work. Then it takes up way too much room on the screen and pushes other stuff I want in the status bar off the screen. That's annoying! I want it to use, like… 40–50 characters, _max_.

At this point a reasonable person would just truncate the session name to the first 40 characters or whatever and add an ellipsis. But I don't want to be reasonable! I want this to be offbeat and fun!

I got to thinking about more fun ways to shorten these strings. It's safe to assume I _kinda_ know what the task says, so could I make the task shorter by removing letters from the string that weren't essential to understanding? What if…

1. if I know a shorter version of a word, I just substitute it. For example, I can use "&" instead of "and" or "7" instead of "seven." Since this is for me, text speak is also fine: "u" for "you", "y" for "why", etc.
2. if a word has double letters, remove 'em! "Occurrence" becomes "ocurence."
3. drop vowels from the middle of words. That transforms "ocurence" into "ocrnc"
4. drop consonants from the middle of words. "ocrnc" becomes "ornc", "onc", "oc" over time
5. if a word has two letters left, make it acronym-y. "oc" is now "O"

This does make the words unintelligible pretty fast, though, so I shorten longer words first (reasoning that a longer word has more chance to remain legible if shortened.)

This works pretty well! There's the odd session that gets crunched into nonsense, but clicking the status in my task bar shows the full version of the session so it's fine.

It's delightful, too! For example, I had a short session today to fix something in my neovim setup. The task "fix alternative test thing for our particular test layout" crunchified down to "fix arntv test thing 4 r ptclr test lout." Useful as a reminder, but inscrutable if you don't know what the session was about in the first place. Just the level of weirdness I was looking for!

All that said, I implemented this whole thing as a Rust crate in the Montage workspace. I can't imagine other uses for it, but it's reusable if you want to shorten strings in a silly way yourself! You can get it at [git.bytes.zone](https://git.bytes.zone/brian/montage/src/branch/main/crunch_str/src/lib.rs). Like the rest of [montage](@/posts/montage.md), it's licensed BSD 3-Clause. Have fun!

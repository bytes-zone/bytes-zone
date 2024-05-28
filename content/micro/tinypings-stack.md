+++
title = "tinyping's stack"
date = 2024-05-28

[extra]
project = "tinyping"
+++

Hey! It's been a couple weeks. The big piece of progress is on tinyping: I've gotten unstuck by making different technical choices. Instead of using Elm for this, I'm using XState, Automerge, Tailwind CSS, and Svelte. This has forced me to learn some new things, which was a byproduct I wanted! Here are my impressions of each:

- **[XState](https://xstate.js.org):** I'm using version 5, which moved focus from state charts to an actor model. I'm fine with that; I love both of those models. I've been having a little trouble pinning down exactly what I want the models to be in XState, but they feel pretty solid once I get there. <!-- more -->
- **[Automerge](https://automerge.org):** Works fine. Stores data, syncs data. Only two problems: first, it's not clear how to do schema migrations. There was some work on that in [Cambria](https://github.com/inkandswitch/cambria-automerge) but it seems stalled. The bigger problem is that the core logic of the library is distributed as a WASM blob, and it's 1.8 megabytes. OOF. I love the ideas around this but I might switch to a different library just to get away from enormous bundled assets like that. (To be fair, the Automerge team is aware of this and it's being worked on.)
- **[Tailwind](https://tailwindcss.com/):** I've seen people raving about this, and finally decided to give it a try. It's… weird. I'm having to look up a bunch of new ways to do things I'm used to, and it makes my markup feel very visually noisy. The resulting CSS is reasonably-sized, though. I grabbed [Tailwind UI](https://tailwindui.com/) to get access to well-written components to copy in and learn from.
- **[Svelte](https://svelte.dev/):** I'm just using Svelte (not SvelteKit) and it's been… fine, I guess. I've hit a number of places where I expected a value to be subscribed and then it wasn't, so I thought that logic was not working when it was actually the UI just stalled. It seems like the upcoming Svelte 5 might have a better way to do this with [runes](https://svelte.dev/blog/runes). It might make sense for me to switch to React, though: I don't need a lot of routing for this app but I'd like to eventually have an app running on phones, which looks like it might be tricky with Svelte.

Anyway, I've been enjoying working on this and have also had a few ideas about how to solve the onboarding questions I wrote about a couple weeks ago. I'll see about fleshing those out in writing as I get there!

As a little nice note: we reached the end of the school year and I'm looking forward to other people being in the house during the day again!

+++
title = "montage"
date = 2023-08-21
description = "the dystopia I chose"
+++

I've liked the concept of the [Pomodoro technique](https://francescocirillo.com/products/the-pomodoro-technique) (basically 25 minute work and 5 minutes rest on a loop through the day) for a long time. I get a lot out of it! Problem is, I'd like to use an app for this but nothing I've tried has been "sticky" enough for me to use long-term… they all have some drawback or other I don't want to live with. So like any good software person, I made my own! Long story short, you can get it at [git.bytes.zone/brian/montage](https://git.bytes.zone/brian/montage). Here's what makes it different:

- Other apps I've used assume they can take over for your todo list or daily log. Montage only asks that I label my sessions for status and reporting.
- Other apps are "polite" with easily-ignorable chimes. Montage gets in my face by yelling at me with the system text-to-speech commands every two seconds when the timer is up. I showed this to a colleague, who described it as "dystopian", but it's the dystopia I chose!
- Most other apps I've used don't expose a nice API for session control or reporting, but Montage is built around [a GraphQL API](https://git.bytes.zone/brian/montage/src/commit/dc8749ef12604347d9e57a348e8fb8c97cef9e53/montage_client/schema.graphql) and uses that for everything—there's nothing the CLI does that you can't get out of it as JSON.

By exposing a proper API, I was also able to build an [OmniFocus](https://www.omnigroup.com/omnifocus) extension so that I can just click "start task" in the app to start something. I was also able to build an [xbar](https://xbarapp.com/) extension that shows my current task (or break) in the status bar. I get reports with a purpose-made command in the CLI that produces Markdown for me to copy into [Obsidian](https://obsidian.md/). But again, it's just talking to the API so I have the flexibility to produce information about my workdays in any format I want.

I'm pretty happy with Montage so far, and I also have plenty of ideas for more things it should do! For example, it doesn't have any opinion on how long you should work before being reminded to take a break. I'm planning to build that in as a configurable thing in "vex" (the subcommand that talks to me with TTS.) I'd also like [Raycast](https://www.raycast.com/) and Obsidian extensions. At some point it may also make sense to build a GUI or an app, but for now I'm not too bothered by occasionally having to open up the SQLite database for some manual changes.

Anyway, like it says in [the README](https://git.bytes.zone/brian/montage/src/branch/main/README.md), go ahead and give this a shot if it seems interesting to you and you're OK with being called "Brian" by a computer every 25 minutes!

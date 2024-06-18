+++
title = "Trying and Failing to Implement Artificial Ignorance"
date = 2023-09-18
summary = "Artificial ignorance seems nice but OH BOY that's a lot of events"
+++

I like the ideas behind [artificial ignorance](https://ranum.com/security/computer_security/papers/ai/index.html). Summed up:

1. You can't know all the "bad" events that can happen in a system. Modern attackers have basically unlimited kinds of attacks.
2. You _can_ know all the unexceptional, boring events that could happen. That list might go on for a long time, but it'll end at _some_ point.

System logs tend to contain all the events, so removing the unexceptional events should leave you with just the "interesting" ones. _Hypothetically_ you could make yourself a big regex and then use `grep` and other shell tools to look over the logs and email yourself interesting events. This won't catch just security events, either: you'll get warnings about bad configurations, disk space, etc. You'll refine this over time, too—new unexceptional events will happen over time and you’ll add them to the list. Doing this means you’ll only ever see novel things you need to deal with.

I find this idea compelling. It seems analogous to running a linter on code: you get things you would not have caught otherwise that might have caused problems later. Saves time and stress, right?

Except, when I tried to apply this I ran into problems. Basically, the sticking point shows up when creating the list: it grows and grows and ends up too long to manage. Having to create and maintain a list of all the things I don't care about makes for too much work, even after turning down log levels wherever I could. Over the past couple of months, I've put probably 5 or 6 hours into sitting down with `journalctl` dumps and writing regex. Too much! I give up!

I can't seem to shake the idea, though… I just like the payoff too much!

That time cost has to come down, though… maybe approaching the task a different way? Maybe it would help to take this service-by-service or day-by-day instead of looking at a whole system for a whole month? Or maybe I just need to accept that some services will always produce an unreasonable amount of logs (looking at you, Gitea) and give up on them totally? Surely I can find a way forward!

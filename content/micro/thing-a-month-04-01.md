+++
title = "tinyping month 2"
date = 2024-04-01

[extra]
project = "thing-a-month (awareness)"
+++

Let's talk about tinyping. The thing-a-month project is meant to be a thing a month, full stop. But sometimes life gets in the way: between illness and a long-scheduled and much-needed vacation, I didn't have the time I needed to do a good job on tinyping in March.

But I really think it's a good idea, and not such a big one. It's also pretty close to being usable! So this month I'm going to double down on it, breaking my own rules about the "things" only taking a month.

So here's a quick status report, and where I hope to get to in April:

<!-- more -->

- Ping caculation can be distributed among multiple clients in a reliable way, which should keep the right distribution from the two posts in early March ([1](@./thing-a-month-03-01.md), [2](@./thing-a-month-03-02.md))
- Style is... really not there yet.
- Neither is reporting.
- You also can't sync data anywhere, which is especially bad on mobile (and *especially* on mobile Safari, which will delete stuff in IndexedDB after only 7 days of inactivity if you don't pin the app to the home screen.)
- Nothing is deployed anywhere.

So here are the goals for April:

1. Get reporting working. This is a core thing—there's not much point entering the data if we can't get the results.
2. Get notifications on new pings. This is almost done, and just needs a little push to get it over the line.
3. Get some semblance of style. It's *really* rough right now, and nothing I'd want to show someone else.
4. Get syncing to a server, at least for backup. I might have to drop encryption to get this done in April; that's OK.

And the things I'm *not* going to do (unless I miraculously get the above done):

- Multiple tags per ping
- Bulk editing
- Integration into other systems
- Any kind of native or mobile app

My work's cut out for me; let's go!

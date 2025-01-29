+++
title = "some time tracking results"
date = 2025-01-29

[extra]
project = "Local-First From Scratch"
+++

A while back I wrote ([post 1](@/micro/thing-a-month-03-01.md), [post 2](@/micro/thing-a-month-03-02.md)) about how TagTime (and the then-called TinyPing) analyze time by assuming that each ping is worth 45 minutes, then getting a daily average and a 95% confidence interval. This can give you a pretty good idea of how you're spending your time, but I only did it for a simulated person with a perfect schedule.

If you haven't read about this before, here's the basic idea:

1. The system randomly asks you what you're doing.
2. It biases that random choice in a way that the long-term average time between pings is 45 minutes (or whatever you like)
3. Eventually, you can get an idea of what a "normal" day looks like by doing a little math.

Anyway, let's do the analysis now that I've got a bit over a month of data.

<!-- more -->

What you'll see below:

- The "tag" is what I'm doing. This is a dot-separated hierarchy (e.g. `work.meeting.standup`.) For analysis, I split that into three tags (`work`, `work.meeting`, and `work.meeting.standup`) so I can see the proportions in differen categories.
- The average daily time is the percentage representation of the tag in the data set times the number of minutes in the day. (E.g. if I had 100 pings, 30 of which were tagged `sleep`, I'd have `30 / 100 * 1440` to get 432 minutes, or 7h12m.)
- The margin of error is a 95% confidence interval of the average daily time, rounded to the nearest minute.

In this data, I've censored a few things—either because they felt too personal to share in a space like this or because they reveal the contents of work projects—but otherwise I've checked this against other accurate sources I have (e.g. my watch for sleep tracking) and it all seems to be accurate!

So, here are the top places I've been spending my time recently:

| Tag | Average Daily Time ± Margin of Error |
|-|-|
| Unknown | 7h17m ± 43m |
| `sleep` | 6h58 ± 43m |
| `work` | 2h56m ± 31m |
| `beeps` | 48m ± 17m |
| `tv` | 28m ± 13m |
| `lunch` | 25m ± 12m |
| `work.meeting` | 24m ± 12m |
| `breakfast` | 16m ± 10m |
| `k8s` | 14m ± 9m |
| `coffee` | 12m ± 9m |
| `driving` | 9m ± 8m |
| `dishes` | 8m ± 7m |

There are a lot of improvements I could make here. For example, I've had a lot of time off recently due to holidays. If I applied that insight and re-analyzed `work` for only weekdays I worked, I'm sure I'd get more like 7.5 to 8 hours per day. Overall, though, I'm pretty happy with this level of insight!

If you'd like to try this for yourself, [you can get the source or pre-built binaries on GitHub](https://github.com/bytes-zone/beeps).

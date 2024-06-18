+++
title = "what's between two pings?"
date = 2024-03-05T13:00:00-06:00

[extra]
project = "thing-a-month (awareness)"
+++

I got to thinking about how pings work in this system ([last post](@/micro/thing-a-month-03-01.md) and realized an optimization. Right now I'm treating them as though they're all the same size—that's safe because of the law of large numbers, remember—but they're not all the same size! Time varies between pings.

<!-- more -->

Say you have these pings with these tags:

| Time  | Tag    |
| ----- | ------ |
| 8:00  | work   |
| 9:00  | work   |
| 9:30  | coffee |
| 10:30 | work   |

Assuming we're comfortable with this small sample as being representative of what you actually did, you can say with confidence that between 8:00 and 9:00 you were working. But sometime (vaguely) between 9:00 and 9:30 you transitioned to making coffee, and sometime (vaguely) between 9:30 and 10:30 you transitioned back to working.

If we treat every ping as equal, assuming λ is 1 hour, this will be reported as 3 hours (± 0.85 hours) working and one hour (± 0.85 hours) getting coffee. That's pretty good—or at least enough to get a sense of how you're spending your time.

But what if we take advantage of the fact that pings _aren't_ exactly hourly? We'd have to take care of the vagueness of when you transitioned. In the absence of other data, we might just take the time halfway between two pings as the transition time. So that means that our times look like this:

| Time  | Tag    | Duration                                          |
| ----- | ------ | ------------------------------------------------- |
| 8:00  | work   | 0:30 (halfway to 9)                               |
| 9:00  | work   | 0:45 (halfway back to 8 plus halfway to 9:30)     |
| 9:30  | coffee | 0:45 (halfway back to 9:30 plus halfway to 10:30) |
| 10:30 | work   | 0:30 (halfway back to 9:30)                       |

This makes it look like we have less time, though: we now have 2.5 hours tracked instead of 4. This is probably not a problem in real life: we can take pings continuously and tag any that aren't answered as "afk." If we really need to, it's probably safe to double the duration of the first and last ping, giving us a total of 3.5 hours in this sample.

But does it give us better insight into our life? Let's see. Doing this by hand:

| Tag    | Ping as hour | Ping as halfway between |
| ------ | ------------ | ----------------------- |
| work   | 3h ± 0.85h   | 2.75h ± 0.82h           |
| coffee | 1h ± 0.85h   | 0.75h ± 0.82h           |

It feels weird to me that the error bar goes below zero for coffee now. I definitely didn't spend _no_ time on it, much less negative time. But let's pretend that getting coffee took 15 minutes and the remainder of the 4 hours was spent working: both of these systems produce a perfectly acceptable answer to the question of "where did my day go?"

Given that, I think the first version of this system should assume that pings are `1 hour / λ` or similar instead of trying to get fancy. The transformation is not _that_ hard (I'll attach a Python script below that can evaluate [the same data I generated in the last post](@/micro/thing-a-month-03-01.md)) so it would hypothetically be feasible to change if it looked like there was a big advantage to doing so. Although I want to be careful to avoid giving precise-but-fuzzy numbers, though: sticking with a rougher-grained unit as a base unit probably makes a ton of sense for setting expectations… you wouldn't want to bill a client on data from this system, for example!

All this talk of coffee has made me want some. brb.

```python
#!/usr/bin/env python3
import argparse
import collections
from datetime import datetime, timedelta
import json
import math
import sys


class Ping:
    def __init__(self, at, tag, duration):
        self.at = at
        self.tag = tag
        self.duration = duration

    @classmethod
    def from_json(cls, obj):
        return cls(datetime.fromisoformat(obj['at']), obj['tag'], timedelta(0))

    def __repr__(self):
        return f"<Ping at={self.at.isoformat()} tag={repr(self.tag)}, duration={str(self.duration)}>"


def main(args):
    pings = [Ping.from_json(obj) for obj in json.load(sys.stdin)]

    for (i, ping) in enumerate(pings):
        if i == 0:
            continue

        before = pings[i-1]

        halfway = (ping.at - before.at) / 2
        ping.duration += halfway
        before.duration += halfway

    total_seconds = sum((ping.duration.total_seconds() for ping in pings))
    print(f"From {timedelta(seconds=total_seconds)} hours tracked...\n")

    total_seconds_by_tag = collections.Counter()
    for ping in pings:
        total_seconds_by_tag[ping.tag] += ping.duration.total_seconds()

    for (tag, tag_total) in total_seconds_by_tag.most_common():
        proportion = tag_total / total_seconds
        other_ping_proportion = 1 - proportion
        sem = math.sqrt(proportion * other_ping_proportion / len(pings))
        plus_minus = sem * total_seconds

        print(f"{tag}\t{tag_total/60/60:.2f} hours\tplus or minus {plus_minus/60/60:.2f} hours")


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-l', type=float, default=1)

    main(parser.parse_args())
```

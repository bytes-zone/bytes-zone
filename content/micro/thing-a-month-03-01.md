+++
title = "messing around with statistics"
date = 2024-03-05T07:00:00-06:00

[extra]
project = "thing-a-month (awareness)"
+++

The basic idea behind TagTime is:

1. Choose how often you want to be asked what you're up to. This constant is called λ. Let's assume that `λ = 1` for now, which will mean "once per hour." If you wanted to be asked every 30 minutes (on average) you could set this to 2.
2. Schedule pings (instances of being asked what you're doing) into the future following a Poisson distribution (which means the time between pings follows an exponential distribution with an average of λ.) <!-- more -->
	- It seems like the way to do this might be to generate a random value between 0 and 1 and plug it in like so: `math.log(random.random()) / lambda * -1`
3. Since you know the time between pings averages out to λ, you perform analysis as if each ping was worth λ time (so if it's 1, and that means 1 per hour, that means each ping is worth one hour.)

I'm going to try this out and see how it works, just to test my understanding of the math. I'm going to write a Python program simulating someone with a very simple and strict schedule. Specifically:

| What | Start | End |
| ---- | ---- | ---- |
| Sleep | 10:00pm | 6:00am |
| Morning Activities | 6am | 7:30am |
| Commute | 7:30am | 8:00am |
| Work | 8:00am | 12:00pm |
| Lunch | 12:00pm | 1:00pm |
| Work | 1:00pm | 2:30pm |
| Afternoon Coffee | 2:30pm | 2:36pm |
| Work | 2:36pm | 5:00pm |
| Commute | 5:00pm | 5:30pm |
| Evening Activities | 5:30pm | 10:00pm |
Some points of interest:

- Lots of the schedule doesn't fall exactly on hour boundaries.
- A few of the activities are shorter than an hour.
- One activity is tiny! Making coffee every day takes 6 minutes exactly (one tenth of an hour.)

I'm doing that to see how much data this system actually needs to capture smaller changes in activity throughout the day.

Here's a Python script that can generate pings according to this schedule:

```python
#!/usr/bin/env python3
import argparse
from datetime import datetime, timedelta
import json
import math
import random
import sys


def tag(ping):
    time = (ping.hour, ping.minute)

    if time >= (22, 0) or time < (6, 0): # 8 hours
        return 'sleep'
    elif time >= (6, 0) and time < (7, 30): # 1.5 hours
        return 'morning'
    elif time >= (7, 30) and time < (8, 0): # 0.5 hours
        return 'commute'
    elif time >= (8, 0) and time < (12, 0): # 4 hours
        return 'work'
    elif time >= (12, 0) and time < (13, 0): # 1 hour
        return 'lunch'
    elif time >= (13, 0) and time < (14, 30): # 1.5 hours
        return 'work'
    elif time >= (14, 30) and time < (14, 36): # 0.1 hours
        return 'coffee'
    elif time >= (14, 36) and time < (17, 0): # 2.4 hours
        return 'work'
    elif time >= (17, 0) and time < (17, 30): # 0.5 hours
        return 'commute'
    elif time >= (17, 30) and time < (22, 0): # 4.5 hours
        return 'evening'
    else:
        return None


def main(args):
    entries = []

    next_ping = datetime.now()
    end = next_ping + timedelta(days = args.days)

    while next_ping <= end:
        entries.append({ "at": next_ping.isoformat(), "tag": tag(next_ping) })

        next_gap = math.log(random.random()) / args.l * -1
        next_ping += timedelta(hours = next_gap)

    json.dump(entries, sys.stdout, indent=2)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('days', type=int)
    parser.add_argument('-l', type=float, default='1')

    main(parser.parse_args())
```

Next we assume that each ping is `1 / λ` hours and calculate both the total time for all the pings. That total time comes out pretty close to what I'd expect: for a week, I'd expect 168 pings if there's an average of one an hour and I'm getting like 173, 141, 167, 148, etc.

We sum up the total time per tag, then find out the standard error from the mean for each tag to get a range. Here's the Python code that slurps up the `stdout` of the last script:

```python
#!/usr/bin/env python3
import argparse
import collections
from datetime import datetime
import json
import math
import sys


class Ping:
    def __init__(self, at, tag):
        self.at = at
        self.tag = tag

    @classmethod
    def from_json(cls, obj):
        return cls(datetime.fromisoformat(obj['at']), obj['tag'])

    def __repr__(self):
        return f"<Ping at={repr(self.at)} tag={repr(self.tag)}>"


def main(args):
    pings = [Ping.from_json(obj) for obj in json.load(sys.stdin)]

    total_hours = len(pings) * (1 / args.l)
    print(f"From {total_hours} hours tracked...\n")

    total_hours_by_tag = collections.Counter()
    for ping in pings:
        total_hours_by_tag[ping.tag] += 1 / args.l

    for (tag, tag_total) in total_hours_by_tag.most_common():
        proportion = tag_total / total_hours
        other_ping_proportion = 1 - proportion
        sem = math.sqrt(proportion * other_ping_proportion / total_hours)

        print(f"{tag}\t{tag_total} hours\tplus or minus {sem * total_hours:.2f} hours")


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-l', type=float, default=1)

    main(parser.parse_args())
```

That outputs things like this:

```
From 158.0 hours tracked...

sleep	56.0 hours	plus or minus 6.01 hours
work	45.0 hours	plus or minus 5.67 hours
evening	26.0 hours	plus or minus 4.66 hours
morning	12.0 hours	plus or minus 3.33 hours
commute	10.0 hours	plus or minus 3.06 hours
lunch	9.0 hours	plus or minus 2.91 hours
```

Or this:

```
From 193.0 hours tracked...

sleep	67.0 hours	plus or minus 6.61 hours
work	58.0 hours	plus or minus 6.37 hours
evening	40.0 hours	plus or minus 5.63 hours
morning	13.0 hours	plus or minus 3.48 hours
lunch	7.0 hours	plus or minus 2.60 hours
commute	6.0 hours	plus or minus 2.41 hours
coffee	2.0 hours	plus or minus 1.41 hours
```

These are reasonably accurate! For any 7-day period, here's how the "actual" time compared to the statistics:

| Tag | Actual | Sample 1 | Sample 2 |
| ---- | ---: | ---: | ---: |
| sleep | 56h | ✅ 56 ± 6.01 | ✅ 67 ± 6.61 |
| work | 55.3h | ❌ 45 ±  5.67 | ✅ 58 ±  6.37 |
| evening | 31.5h | ❌ 26 ±  4.66 | ❌ 40  ± 5.63 |
| morning | 10.5h | ✅ 12 ±  3.33 | ✅ 13 ± 3.48 |
| commute | 7h | ✅ 10 ± 3.06 | ✅ 6 ± 2.41 |
| lunch | 7h | ✅ 9 ± 2.91 |  ✅ 7 ± 2.60 |
| coffee | 0.7h | ❌ did not capture | ✅ 2 ± 1.41 |
I put a ✅ when the range covers the actual value and an ❌ when it doesn't. As you can see, these samples get in the ballpark but the ranges don't always cover the actual values. However, these would definitely be good enough to get a sense of how you're spending your life as a whole, so maybe it's OK!

I wonder, though, if it gets more accurate if you sample more frequently. An average of a half hour seems like it'd get annoying (because of the exponential distribution, some pings would be very close together) but I wonder about 45 minutes. Let's try. That's a λ of 1⅓. Here's the results:

| Tag | Actual | Sample 1 | Sample 2 |
| ---- | ---: | ---: | ---: |
| sleep | 56h | ✅ 60.75 ±   6.3 | ✅ 61.5 ±  6.14 |
| work | 55.3h | ✅ 59.25 ± 6.26 | ❌ 48.75 ±  5.81 |
| evening | 31.5h | ✅ 27 ± 4.78 | ✅ 29.25 ± 4.89 |
| morning | 10.5h | ✅ 10.5 ± 3.14 | ❌ 4.5 ± 2.09 |
| commute | 7h | ✅ 6.75 ± 2.55 | ✅ 8.25 ±  2.8 |
| lunch | 7h | ✅ 9 ±  2.92 | ✅ 6.75 ±  2.54 |
| coffee | 0.7h | ✅ 1.5 ± 1.22 | ❌ did not capture |
That seems about the same. The ranges don't feel like they're that much smaller to me. Maybe half an hour really would be better?

| Tag | Actual | Sample 1 | Sample 2 |
| ---- | ---: | ---: | ---: |
| sleep | 56h | ✅ 54 ± 6.04 | ✅ 52.5 ±  5.98 |
| work | 55.3h | ✅ 52 ± 5.98 | ✅ 49.5 ± 5.89 |
| evening | 31.5h | ✅ 33.5 ± 5.17 | ✅ 34 ± 5.2 |
| morning | 10.5h | ✅ 10 ± 3.07 | ✅ 14 ± 3.58 |
| commute | 7h | ✅ 7 ±  2.59 | ✅ 7 ± 2.59 |
| lunch | 7h | ✅ 8 ±  2.76 | ✅ 7 ±  2.59 |
| coffee | 0.7h | ✅ 1.5 ± 1.22 | ✅ 1 ± 1 |
Those two samples happen to be all green, but some of them *barely* squeaked in. I still think a λ of 30 minutes would be far too annoying, so I'm going to leave it out.

Next I'm going to go and see if this is the same stuff that the Perl version of TagTime *actually* uses, and then maybe repeat this analysis!

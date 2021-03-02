+++
title = "Trying (and Failing) to Speed Up String.startsWith"
date = 2021-03-01
+++

When I was optimizing [elm-csv](@/posts/elm-csv-package-and-talk.md), I noticed that Elm's `String.startsWith` is implemented using JavaScript's `indexOf` method.
It looks something like this:

```javascript
function startsWith(haystack, needle) {
  return haystack.indexOf(needle) === 0
}
```

This strikes me as inefficient!
Doesn't that mean that if `haystack` doesn't begin with `needle`, it'll still look through the whole string?
That seems to waste a lot of cycles on work after we already know the result.

After thinking about it for a little bit, I imagined a faster way:

```javascript
function startsWith(haystack, needle) {
  return haystack.slice(0, needle.length) === needle
}
```

But, I didn't know for sure if it would be faster, so I started measuring things.
After a few benchmarks things were looking promising!
I found that `String.prototype.slice` and `String.prototype.length` operate in more-or-less constant time, and that `===`, while not constant-time, is heavily optimized.

*Hypothetically*, I thought, this means that a `slice`-based implementation of `startsWith` could run much quicker than scanning through the whole string with `indexOf`.

## Chrome Uses Actual Magic in Their Strings

But just to make sure my intuition about `indexOf` being slow was correct, I decided to benchmark that as well.
Specifically, I decided to benchmark how long browsers took to find a single character in a string that doesn't contain the character:

```javascript
"abc".repeat(size).indexOf("d")
```

I expected that every time I multiplied `size` by 10, I should see roughly a 10x slowdown in operations per second.
But then…

| Browser              |     1 "abc" |             10 "abc"s |            100 "abc"s |          1,000 "abc"s |
|----------------------|------------:|----------------------:|----------------------:|----------------------:|
| Chrome 88.0.4324.182 | 866,026,834 | 869,256,882           | 858,563,862           | 865,370,315           |
| Firefox 85.0         |  43,557,275 |  44,947,174           |  41,059,919  (-8.65%) |  16,831,928 (-59.01%) |
| Safari 14.0.1        |  49,240,581 |  34,661,639 (-29.61%) |   7,162,615 (-79.01%) |     877,449 (-87.75%) |

Chrome has… NO REAL SLOWDOWN?
WHAT?
This data suggests that Chrome can find a substring in any length string in constant time.
How is that even possible?

At this point, I felt pretty out of my depth, and decided I needed to ask my friend [Luke Westby, Real-Life Computer Genius™](https://github.com/lukewestby), what was going on.
He knew right where to look and figured out that [Chrome has a special optimization for single-character search strings in `indexOf`](https://github.com/v8/v8/blob/dc712da548c7fb433caed56af9a021d964952728/src/strings/string-search.h#L194).
In other words, people have hand-tuned V8 over the years to go ridiculously fast in all sorts of situations, and this is one of them.

Well, OK, let's try finding some multi-character string instead.
I used "nope", which doesn't trigger this optimization, but still fails to match "abc".
Does that give us a result that matches my intuition?

| Browser              |     1 "abc" |             10 "abc"s |            100 "abc"s |          1,000 "abc"s |
|----------------------|------------:|----------------------:|----------------------:|----------------------:|
| Chrome 88.0.4324.182 | 885,211,831 | 863,845,523  (-2.41%) | 849,821,335  (-1.62%) | 837,391,727  (-1.46%) |
| Firefox 85.0         |  58,648,716 |  44,107,472 (-24.79%) |  40,529,513  (-8.11%) |  16,768,019 (-58.63%) |
| Safari 14.0.1        | 102,071,445 |  26,242,114 (-74.29%) |   4,212,339 (-83.95%) |     467,329 (-88.91%) |

That's *kinda* like what I expected, but Chrome is still incredibly fast at this!
Well, OK, that's fine.
Good for them.
But at this point I got curious (and a little devious): how can I defeat Chrome's optimizations?
What is the worst-case scenario that they can't possibly have handled already?

I tried to imagine the algorithm that you'd have to write to implement `indexOf` and came up with something like this:

1. Look at the first character in `haystack`.
2. If it matches the first character in `needle`, look at the next pairs of characters in the two strings one by one.
3. If you get to the end of `needle` and they all match, you've found the index.
4. But if one pair doesn't match, you've got to start over at the next character in `haystack`.

With that in mind, what's combination of `needle` and `haystack` would perform the worst?
I think it's any pair of strings where `haystack` is all but the last character of `needle` repeated over and over.
So, maybe a benchmark like this?

```javascript
"abc".repeat(size).indexOf("abcd")
```

That can never succeed, but it'll make the browser do a lot of extra work reading the initially-matching "abc" over and over.
Let's see the results:

| Browser              |     1 "abc" |             10 "abc"s |            100 "abc"s |      1,000 "abc"s |
|----------------------|------------:|----------------------:|----------------------:|------------------:|
| Chrome 88.0.4324.182 | 877,221,230 | 863,929,216  (-1.52%) | 688,398,676 (-20.32%) | 125,023 (-99.98%) |
| Firefox 85.0         |  61,384,762 |  12,874,505 (-79.03%) |   1,366,202 (-89.39%) | 137,245 (-89.95%) |
| Safari 14.0.1        | 100,546,438 |  25,948,095 (-74.19%) |   4,170,375 (-83.93%) | 467,753 (-88.78%) |

Finally, Chrome has similar performance to other browsers.
I don't think this is representative of real workloads, but even so Chrome performs admirably.
Hats off to the V8 team for this implementation, but honestly, it's good to know they're still mortal!

## Comparing the Implementations

So now that we know more about the component pieces involved in this optimization (for example, knowing to avoid single-character test strings), we can check if `slice` actually gives us a real-world speedup.
In setting this up, I decided to go for the middle of the road to try and benchmark the browsers under something that you can kind of squint at and think "yeah, that will probably happen reasonably often in real life."
In this case, that meant setup looked like this:

```javascript
haystack = "abc".repeat(100)
needle = "abc"
```

Then the `indexOf` and `slice` benchmarks looked like the code at the top of this post:

```javascript
haystack.indexOf(needle) === 0
```

```javascript
haystack.slice(0, needle.length) === needle
```

That gave me these results:

| Browser              |     indexOf |         slice |   % Diff |
|----------------------|------------:|--------------:|---------:|
| Chrome 88.0.4324.192 | 871,312,454 |   870,810,291 |   -0.06% |
| Firefox 86.0         |  32,428,394 |    46,845,953 |  +44.46% |
| Safari 14.0.1        | 430,854,455 | 1,352,674,261 | +213.95% |

Note that Chrome and Firefox had released new versions between me testing `indexOf` and this test. I kept the old data here because it doesn't seem to have changed the performance, but I just want to be up front that the versions are different!

Anyway, that said: looks like a result within the margin of error for Chrome (around 0.4%), but a reasonable speedup for Firefox and a big win for Safari.

What does the failure case look like? (Same `haystack`, but `needle = "nope"`):

| Browser              |     indexOf |         slice |      % Diff |
|----------------------|------------:|--------------:|------------:|
| Chrome 88.0.4324.192 | 874,951,212 |   854,116,367 |      -2.44% |
| Firefox 85.0         |  31,026,729 |    22,180,114 |     -28.51% |
| Safari 14.0.1        |   4,189,768 | 1,508,770,435 | +35,910.83% |

This time, Chrome has a slowdown greater than the measurement error, which surprised me!
Same with Firefox, but to a larger degree.
But the real story here is Safari, which can now do this operation over 1.5 billion times per second.
*Billion!*
What even!

## Is It Worth It?

So, with all that measurement done, is this optimization worth it?
I'm actually not really sure.
This is basically nothing in Chrome but means making some real performance tradeoffs in Firefox.
And, even though it looks like a huge win in Safari, my claims can only be as strong as the underlying assumptions I'm making in choosing test data.
So, just to be explicit about that:

- These benchmarks assume that `haystack` is a long-ish string (300 characters.)
  Many of the gains we see here are erased when the strings are short.
  Safari in particular, drops to only about a 100% gain in the failure case with a shorter string (I tested at 3, 30, 150 characters, all with similar results.)
- The `needle` strings are neither a single character nor a worst-case scenario for `indexOf` performance.
- Success and failure cases are equally likely.
  We can't make any assumption other than that at the runtime level, although we could make a good argument to switch this for individual applications.
  For example, we could choose to use `slice` in an application where we expected most checks on `startsWith` would succeed, since that's basically a wash in Chrome and much faster in Firefox and Safari.
- We care about browsers based on global total share instead of splitting out into desktop or mobile.
  This is another area where you could make different decisions at the application level: if the users of your app skew more towards using Chrome or more towards Safari, this payoff for this optimization gets better or worse.

Of course, if you can measure that your application *would* benefit from this optimization, go ahead and do it yourself!
Calling `String.slice 0 (String.length haystack) === needle` has some overhead in Elm (due to equality having different semantics) but you may still able to get the majority of the benefits if your users are mostly using Safari or you're running iOS webkit views or something like that.
Just make sure to actually measure it!
Optimizations at this level can be helpful, but they're more often dwarfed by DOM stuff in the runtime.

As for me: at this point, I'm not going to make a PR to `elm/core` with this improvement, even I intended to when I set out.
However, I found it interesting to look into these things, and I learned a lot about how strings are optimized in various browsers, so I'm gonna call it a win overall.

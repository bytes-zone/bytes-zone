+++
title = "Digital Gardening in Obsidian"
date = 2022-12-26
description = "Observing growth in my notes without being overwhelmed."

[extra]
featured = true
+++

I have been using [Obsidian](https://obsidian.md) for all my notes for something like 6 months now. That's really _everything_, from temporary measurements to journaling to serious documentation work. I've tried Obsidian a couple of times before and bounced off of it, so I decided to try to do things differently this time. Instead of starting out by figuring out a system for where everything lives in advance, I've just thrown almost everything in the default folder and sorted it out with linking and search.

Some structure has emerged over time, which I'm fairly happy with, but it's more to do with practices than things that would make it easier for someone else to read my vault. These practices basically boil down to "digital gardening"—they allow me to keep things neat and tidy and observe growth without being overwhelmed by it. Here's some of what I do!

## Rollup Journaling

I've been keeping a log in my daily notes. These logs can contain answers to journal prompts like "what have I been avoiding?" but most of the time it's just a roughly accurate timestamped log of what I've been up to in a given day.

Every Monday I summarize these daily notes into a weekly digest. These have more of a journaling flavor to them, since one of the goals is to help me discover patterns, but the template is still pretty basic: a header for highlights, one for lowlights, and one for things I want to change in the next week.

If the particular Monday I'm doing this on also starts a new month, I'll also do a summary of the weeks in the previous month following the same basic pattern. Same for the last 3 months of monthly notes, if it happens to be the first Monday of April, July, October, or January. I haven't been doing this long enough to do a yearly rollup yet, but I may do a 2022 yearly rollup note in January.

I've been really happy with this! The big benefit so far I've seen is being able to see back in time with more clarity. There have been times this year where I've felt stuck—like I'm not making progress and haven't for a long time—but looking back in my notes I can see that I actually have done some pretty major things in the past year. This has had a nice side benefit that my end-of-year review at work was really easy to write: I just looked back at my quarterly reviews, as well as a few monthly ones, and pulled out some good stuff. It doesn't completely get rid of recency bias, but it does mean that I'm not _only_ focusing on stuff that happened in the last month or two.

I don't know if "rollup journaling" is the best name for this, but it's one that's stuck with me for some reason. I got the idea for doing this a couple years (and tries at Obsidian) ago based on [Britney Braxton's talk at JuneteenthConf 2020, _Journaling as a Dev_](https://www.youtube.com/watch?v=AzrEDnIye14).

## Spaced Repetition

I've been using the [community spaced repetition plugin](https://github.com/st3v3nmw/obsidian-spaced-repetition) to periodically review notes. It's a bit of a hack—this plugin is clearly not meant to be used like this—but it works.

I add a `#review` tag to every note that I want to periodically come back to and improve or tweak (this is actually most of my notes.) I then ask the spaced repetition plugin if there's anything for me to look at. If I make any changes, I'll mark the review as "hard" so the plugin will show it to me earlier. If I don't think it needs any changes, I'll mark it as "easy" to send it further into the future.

I'm not terribly disciplined about doing this every day, but it has a nice benefit of improving notes that need to improve while sending ones that don't into the far future for me to get reminded of periodically.

I think I originally got the idea for this from an [Andy Matuschak note](https://notes.andymatuschak.org/z36iMKLe4CDAXdtLSJD4Z6qPPFUS8ZXymUk3i).

## Pages that Don't Exist, but Should

When writing notes, I link freely, even if the page I'm linking to doesn't exist yet. Then, every couple of days, I'll have a look at my "pages that don't exist but should" note, which has a [dataview](https://blacksmithgu.github.io/obsidian-dataview/) query that shows me all those nonexistent pages, ranked by how many incoming links they would have if they did exist.

For example, if I look at that page right now, I can see that I haven't made a note for Phoenix Liveview—I've been looking into it for a side project and have made notes on a couple of conference talks where I've linked to it. There's also a missing note for some features of the product I work on, since I've mentioned them in daily notes.

I'm fairly happy with this approach. It's a bit easier than looking for greyed-out nodes in the graph view, and over time it's lead to some interesting practices. For example, I started linking the names of my coworkers when I paired or collaborated with them on something, which eventually lead to keeping notes on what other teams around the company are responsible for. I'm not sure I would have started that (quite useful) practice if I hadn't been paying attention to what "[desire paths](https://www.wikiwand.com/en/Desire_path)" I was creating in my vault.

In case it's useful to someone else, here's the dataview script I embed for this. There's probably a better way to get this information, but it's been working well as-is. This version filters out daily notes and doesn't consider media files, but you may want to remove those lines if being prompted to create daily notes far in the past or future sounds useful to you:

```javascript
let phantoms = dv
  .pages()
  .flatMap((p) => p.file.outlinks.map((link) => [link, p.file]))
  .groupBy((p) => p[0])
  .filter((g) => g.rows.length > 1)
  .filter(
    (g) =>
      !g.key.path.endsWith(".png") &&
      !g.key.path.endsWith(".jpeg") &&
      !g.key.path.endsWith(".jpg") &&
      !g.key.path.endsWith(".mov") &&
      !g.key.path.match(/^\d\d\d\d-Q\d$/) &&
      !g.key.path.match(/^\d\d\d\d-\d\d-\d\d$/) &&
      !g.key.path.match(/^\d\d\d\d-\d\d$/),
  )
  .map((g) => {
    return { key: g.key, rows: g.rows.map((r) => r[1]) };
  })
  .filter((g) => dv.page(g.key) === undefined)
  .sort((g) => g.rows.length, "desc");

dv.table(
  ["Page to Create", "Linked From"],
  phantoms.map((g) => [g.key, g.rows.map((p) => p.link)]),
);
```

## Other Dataview Shenanigans

Other than the stuff mentioned above, I have a handful of useful dataview pages. For example, I'm looking into replacing an older car we own right now. The page for that project has a dataview query summing up research I've done into cars I might want to buy to replace it. I also have a view of everything tagged `#possible-blog-post` sorted by when I think I might want to publish it. None of these are huge, but they do a good job of gathering information from around my vault that I probably want to see all at once.

## Anyway

That's how I organize my Obsidian vault. I have a few more plugins I use (e.g. [a calendar widget](https://github.com/liamcain/obsidian-calendar-plugin), [improved daily notes](https://github.com/liamcain/obsidian-periodic-notes), [templater](https://github.com/SilentVoid13/Templater), and [a map view](https://github.com/esm7/obsidian-map-view) for when I was looking at stuff to do on vacation) but that's the core of it. I hope you can take some of this and get use out of it for yourself!

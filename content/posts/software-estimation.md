+++
title = "Software estimation that doesn't suck"
date = 2025-12-04
description = "A good process and a little statistics."

[extra]
featured = false
+++

You've been asked to give an estimate about when you're gonna be able to ship some code. Fine fine, except that there's something riding on this… a trade show, seasonal deadline, etc. Point is: there's another part of the business depending on you doing a good job here.

But software estimates are notoriously inaccurate, to the degree that people frequently double or halve them depending on what they think of the team. Think about that for a sec: a change of **50% in either direction based solely on personal factors.** Absolutely wild.

<!-- more -->

Part of that is that software engineers have a weird aversion to figuring out how to do better here. As a result, a lot of people never get better than off-the-cuff "I can knock that out in a week" style estimates, and develop a reputation for being inaccurate. These skills are worth learning, though, if only because giving useful estimates means that you have the time you need to do the rest of your job correctly! You can also build credibility as someone who understands how to navigate complex systems, and end up with more of a say in the processes you're a part of.

I'm going to share a process that I've personally used to prepare and update estimates for all sorts of software projects. It's based based off the advice in [_Software Estimation: Demystifying the Black Art_](https://www.microsoftpressstore.com/store/software-estimation-demystifying-the-black-art-9780735690851) by Steve McConnell. I'm not following this book to the letter, but the process ends up being enough to communicate with to some degree of accuracy. That's fine, since that's typically what you're really after. However, it's possible that I've fatally compromised some important statistical property. If you read this and you notice, I'd appreciate a heads-up!

This is going to be a longer post, but here's the overall process in five steps:

1. Break down the work into high-level outcome-focused areas.
2. Break each item down into tasks small enough to feel familiar.
3. Go to your team and ask them to give a "about this long" guess as well as a best case and a worst-case for each item.
4. Do a little math to get a range based on percentage confidence.
5. Keep your estimates up to date as the project progresses.

This has worked well for me in companies which lean more towards big-plan-up-front as well as companies that try to stick with a more "agile" approach.

However, sometimes people read this and think "oh no! It's waterfall!" and bounce off it without getting any benefit. So: there's nothing about this process that prevents you from breaking the work into smaller independently-releasable components, or shrinking the project scope, or putting things behind feature flags for beta users, or whatever release strategy you're comfortable with. If you're in an organization that's all-in on agile, you could even use this process to just make sure you're not overcommitting in a single sprint.

It's also usually true that scope or project management style are things you're inheriting instead of something you have direct influence over. Even when you do, working up a proper estimate builds long-term credibility that lets you have more influence over the system.[^cassandra]

## High-Level Breakdown

To get our top level breakdown, we need to address two problems:

- **People usually communicate estimates as single points, but ranges are more realistic.** There are always a bunch of possible outcomes, and we need to be able to cover them. So instead of saying "3 weeks", you might say "we're 90% confident that we'll land it in 1–5 weeks." That is, given all our possible outcomes, 90% of them end up shipping in that time. If you _must_ give a single point, give the upper end of the range.
- **People are really bad at giving percentage-confident estimates to work up a range.** That gets worse as the range expands: you could easily give me a 90% confident estimate for the weight of a glass of water, but if I ask you for the weight of all the water in Lake Michigan you're likely to get it wrong by a couple orders of magnitude. (If you want to try, make a guess and then check the answer in the footnotes.[^lake-michigan])

We'll have to overcome both issues to succeed. To start, we're going to break down work into high level areas. Say we're adding emoji reactions to posts on some businessware app. We might think of these as the high-level components:

- Clicking the reaction button and selecting an emoji adds it to the post.
- Clicking an existing reaction adds +1 to it along with your name. If you had already done that, it removes the +1 instead.

From here, we'd break this down into some finer-grained work items:

- Add reaction button to posts
- Handle request to add reaction to post
- Send reactions+attribution to the frontend along with post payload
- Show people who reacted on hover
- Add +1 to the reaction on click
  - Uses the same backend route as adding a new reaction, just a slightly different UX
- Remove your own reaction if clicked when present
- Handle request to remove reaction from post

You might get these by talking through the functionality with a designer or PM. Starting out high-level and user-focused usually helps to ensure you don't miss anything.

In addition to breaking down the work, this is a good place to make sure that we're not missing any implicit work that we need to do. Missing items are the biggest reason why my estimates have been inaccurate in the past, so making sure to consider all the work in the project—even the indirect or wrap-up stuff—helps a lot!

For example, does this work require a refactor? What's new/unusual about this? What happens in failure modes? I ask questions about the project using something I call "the [feature-proofing checklist](@/feature-proofing-checklist.md)." As I said, missing work has been the biggest source of inaccuracy when preparing estimates, so don't skip it!

## Task-Level Breakdown

Next we need to break these tasks down further to prepare them for estimation. You'll know something is small enough if you could imagine it being in a single PR. If your team regularly uses huge PRs, break it down to items that would take less than two days instead.

You'd do this for all of the tasks, but for the sake of keeping things brief, I'm only going to do it for a couple:

- Add reaction button to posts
  - Upgrade post component to our new standard pattern
  - Add reaction button, styles, event handlers with DOM tests
  - Test for keyboard and screen reader accessibility
- Handle request to add reaction to post
  - Add API endpoint to handle POST
  - Add database table to store many-to-many relationship between posts and users with reaction data

I'm spitballing here, since this isn't a real app, but let's pretend that the existing post component is pretty messy. Maybe it's old code—one of the first things added in this project—and it hasn't had any love in a while. This is the perfect time to upgrade it, since doing so will remove incidental complexity and make future updates faster.

The important thing here is to go from "weight of Lake Michigan" to "weight of a glass of water": you want to get these into small enough chunks that the work gets familiar enough that people can imagine actually doing it. This is something you were probably going to have to do anyway to make the work legible to stakeholders; you might as well get the bonus of an accurate estimate.

## How Big is Each Task?

Next, we'll prepare time-based estimates. We need three numbers for each task in your breakdown. Specifically:

- The **normal-case** estimate.
  - What's your guess about how long this item will take?
  - Aim for 50% confidence on these tasks. Half the time you do this task, it should take longer. The other half, it should take shorter.
- The **worst-case** estimate.
  - If everything went wrong—broken builds, libraries not having needed features, unexpectedly-complex code—how long would it take? I like to use the guideline of "how long would this have to take before we would choose to take a different approach?"
  - This should almost always be quite a bit longer than the normal-case estimate.
  - Aim for 90% confidence here. (If you did this task 10 times, 9 of them would take less time than the worst-case estimate.)
- The **best-case** estimate.
  - If someone got into some amazing flow state and everything magically fell into place, how long would it take?
  - This should always be shorter than the normal-case estimate, although for very short tasks it may not be _much_ shorter.
  - Aim for 90% confidence again here. (If you did this task 10 times, 9 of them would take more time than the best-case estimate.)

It will probably help to put these numbers in a spreadsheet!

Even though it's a bit more work, this is the best place to get your team involved. You'll find out areas that need to be broken down further, as well as areas that you thought would be difficult but maybe won't be. These are some of my favorite discussions when planning, since it gets assumptions into the open where we can deal with them, and reveals differences in opinion between different team members.

This might seem like a lot, but it usually goes quickly. Don't skip all three numbers, either: if you ask people for just one number you'll usually get something that's closer to the best-case estimate than the normal case. As we'll see in a minute, that'll mean an overly-optimistic final estimate!

For our example, let's say we talked with our team and got these estimates:

| Item                                                                                          | Worst Case | Normal Case | Best Case |
| --------------------------------------------------------------------------------------------- | ---------: | ----------: | --------: |
| Upgrade post component to new standard pattern                                                |     3 days |       1 day |   4 hours |
| Add reaction button, styles, event handlers with DOM tests                                    |     4 days |      2 days |     1 day |
| Test for keyboard and screen reader accessibility                                             |   1.5 days |     4 hours |   2 hours |
| Add API endpoint to handle reaction POST                                                      |     2 days |       1 day |   4 hours |
| Add database table to store many-to-many relationship between posts+users with reaction data. |     2 days |     2 hours |    1 hour |

## Building an Estimate

Finally we're getting to the point where we can produce something other people would recognize as an estimate!

First, we'll need to calculate the "expected case." In this style of estimation, that's pretty simple: just sum up the normal case times. If you've kept to a standard of 50% confidence for these, you're doing well! For the part of this project we're using as an example, we get 4 days 6 hours (which I'm choosing to call 4.75 days for maths's sake.)

| Item                                                                                          | Worst Case | Normal Case |  Best Case |
| --------------------------------------------------------------------------------------------- | ---------: | ----------: | ---------: |
| Upgrade post component to new standard pattern                                                |     3 days |       1 day |    4 hours |
| Add reaction button, styles, event handlers with DOM tests                                    |     4 days |      2 days |      1 day |
| Test for keyboard and screen reader accessibility                                             |   1.5 days |     4 hours |    2 hours |
| Add API endpoint to handle reaction POST                                                      |     2 days |       1 day |    4 hours |
| Add database table to store many-to-many relationship between posts+users with reaction data. |     2 days |     2 hours |     1 hour |
| **Total**                                                                                     |  12.5 days |   4.75 days | 2.375 days |

Our next step will be to turn this into a range by getting the standard deviation and then using it to create a percent-confidence-based estimate.

If you have fewer than 10 tasks[^law-of-large-numbers], this math is pretty easy: `stddev = (sum(worstCase) - sum(bestCase)) / 3.3`. (You're just going to have to trust me on the magic constant for now!)

In our case, that's `(12.5 - 2.375) / 3.3`, or 3.07.

However, if you have 10 tasks or more it's better to calculate `(worstCase - bestCase) / 3.3` for each individual task, then square it to get the variance. To get the final standard deviation, we'll take the square root of the sum of the variances. Like this:

| Item                                                                                          | Worst Case | Normal Case | Best Case |    Stddev |  Variance |
| --------------------------------------------------------------------------------------------- | ---------: | ----------: | --------: | --------: | --------: |
| Upgrade post component to new standard pattern                                                |     3 days |       1 day |   4 hours | **0.756** | **0.574** |
| Add reaction button, styles, event handlers with DOM tests                                    |     4 days |      2 days |     1 day | **0.909** | **0.826** |
| Test for keyboard and screen reader accessibility                                             |   1.5 days |     4 hours |   2 hours | **0.379** | **0.143** |
| Add API endpoint to handle reaction POST                                                      |     2 days |       1 day |   4 hours | **0.455** | **0.207** |
| Add database table to store many-to-many relationship between posts+users with reaction data. |     2 days |     2 hours |    1 hour | **0.568** | **0.323** |

That's a total variance of 2.073, for a final standard deviation of 1.440.

(That's pretty different than the group formula's answer of 3.07; that's because with few data points we can't take advantages of the law of large numbers and have to assume that we're 90% confident in the entire data set instead of in each individual point.)

Finally, you take your expected case and compute a range based on what percentage confidence you want to communicate:

| Percentage Confident | Calculation                           |
| -------------------: | ------------------------------------- |
|                   2% | expected - 2 \* standard deviation    |
|                  10% | expected - 1.28 \* standard deviation |
|                  16% | expected - standard deviation         |
|                  20% | expected - 0.84 \* standard deviation |
|                  25% | expected - 0.67 \* standard deviation |
|                  30% | expected - 0.52 \* standard deviation |
|                  40% | expected - 0.25 \* standard deviation |
|                  50% | expected                              |
|                  60% | expected + 0.25 \* standard deviation |
|                  70% | expected + 0.52 \* standard deviation |
|                  75% | expected + 0.67 \* standard deviation |
|                  80% | expected + 0.84 \* standard deviation |
|                  84% | expected + standard deviation         |
|                  90% | expected + 1.28 \* standard deviation |
|                  98% | expected + 2 \* standard deviation    |

So for our project, using the individual standard deviation calculation, we'd get a 90% confident estimate by calculating `4.75 + 1.28 * 1.44`, or 6.59 days. Filling out the table, we get:

| Percentage Confident | Estimate |
| -------------------: | -------: |
|                   2% |     1.87 |
|                  10% |     2.91 |
|                  16% |     3.31 |
|                  20% |     3.54 |
|                  25% |     3.79 |
|                  30% |     4.00 |
|                  40% |     4.38 |
|                  50% |     4.75 |
|                  60% |     5.11 |
|                  70% |     5.50 |
|                  80% |     5.96 |
|                  84% |     6.19 |
|                  90% |     6.59 |
|                  98% |     7.63 |

## Communicating the Estimate

We've all heard Spock or a robot or whatever say things like "there is a 95.83462% chance of failure!" [There's even a TV Tropes page on it.](https://tvtropes.org/pmwiki/pmwiki.php/Main/LudicrousPrecision) But when you're communicating estimates? Don't do that!

We can calculate our estimates to whatever precision we want. Since our units are days, calculating to the hundredths place means we're claiming a precision of 14 minutes and 24 seconds.

This seems reasonable until you remember that our inputs are… well, if you're doing this process for the first time, let's call them "fuzzy." Even when you're trying to get to 90% accuracy, you might get lucky and hit 70% the first time.

But at this point, you do need to give someone a number—boss, PM, whoever. My usual way to do it: take the 50th percentile and the 98th percent confidence numbers[^why-50-and-98] and put them into human language.

I want to justify each step here, so:

1. "We expect this to take between 4.75 and 7.63 days." Precise but no good, since whoever you're giving this too will hear accuracy when you only intended to communicate precision. So…
2. "We expect this to take between 5 and 8 days." Better, and if I were communicating internally (e.g. with a PM assigned to the team) I might stop here. Note that I rounded up; rounding down to 4 days would take us from 50% confident to 30%. Overall, however, it's still a fairly narrow range. I might improve it to…
3. "We expect this to take 1–2 weeks." We're 90% confident this work will take _at least_ 4.75 days, so rounding up to a workweek is not unreasonable. And 8 workdays definitely represents the better part of two workweeks.

This is different than the kinds of random padding people do with off-the-cuff estimates ("engineers always pad by 20%; I'll cut it by that much") since we're working from reasonable estimates for individual items. However, we know we're not going to be 100% accurate, or even accurate to within a tenth of a day in many cases. It's reasonable to represent the fuzziness in our inputs with fuzziness in our outputs.

## Adjusting for Inaccuracy

As you proceed through the project, you're going to immediately get useful data about how accurate your estimates were. The evidence shows up immediately in your bug tracker: how long did it take between starting and finishing the task? I can tell you that you're not gonna hit 100% of your estimates! Fortunately, we can account for that.

Let's talk about where we got the magic divisor 3.3 from. That's actually the amount of standard deviations that you think the range spans, and it depends on the percentage confidence you are trying to hit during the estimation process. Since I told you to aim for 90%, we use 3.3. Here are some more:

| Actual Outcomes within Range | Divisor for standard deviations |
| ---------------------------: | ------------------------------: |
|                          10% |                            0.25 |
|                          20% |                            0.51 |
|                          30% |                            0.77 |
|                          40% |                             1.0 |
|                          50% |                             1.4 |
|                          60% |                             1.7 |
|                          70% |                             2.1 |
|                          80% |                             2.6 |
|                          90% |                             3.3 |
|                        99.7% |                             6.0 |

This works in reverse, too: if we find that we've been inaccurate in our estimates as the project progresses, we can recalculate the estimate based on our real accuracy.

So let's pretend that we're done with the part of the project we've been estimating so far and have hit a milestone. Hooray and congrats! Remembering that this is just the first part of the project, let's update the estimate for the rest.

Say we've got 15 tasks and our actual working time fell within the bounds of the estimate for 12 of them. That ends up being 80% coverage, not 90%. Redoing the calculations, we get a standard deviation of 1.83, up from 1.44. That's not a huge jump, but it's enough to know that we need to widen our range. If we were to recalculate our sample tasks, the most precise version of the range would go from 4.75–7.63 days to 6.58–8.41 days.

This may be an unpleasant surprise to your stakeholders, but it's better to share this kind of news early instead of waiting until the very end of the project to drop that everything is going to take 25% longer than you originally estimated. Point is, you now have the tools to adjust! In the second project you estimate with this method, you'll account for more of the things that you missed the first time.

Because you know things will shift around as you get more data, you should agree with your stakeholders that you'll be providing updates on the estimate as you move through the project. If they're expecting to hear from you, delivering that news gets way easier (and it's not that much additional work if you've kept the spreadsheet from earlier around.)

You can also begin in a better place once you have some historical data. If you know that your team almost always ends up at 70%, you can use that to calculate your initial estimate. (You should still work on identifying gaps and building skill, though, so that you can get to 90%!)

Basically, as soon as you can ground your estimate in reality, do that!

## That's It!

Just to get everything in one place, here are the steps we've just been over:

1. Break down work into high-level areas.
2. Break those areas down until each task feels like something you'd put in a PR.
3. Work with your team to estimate the best-case, normal-case, and worst-case scenarios for each task.
4. Figure out the standard deviation represented by the range between best and worst case, then use it to calculate a time range that you can communicate. (50% and 98% is nice.)
5. Re-estimate at least at agreed-upon milestones. If you have to share bad news, share it quickly so that your team can get ahead of it and build trust and credibility.

If you've enjoyed this, or want to learn more, I'd really recommend picking up _Software Estimation: Demystifying the Black Art_. In addition to this technique (which is based off of several chapters, but most notably chapter 10) there's a lot about ways to build up an estimate based off analogies to historical data, as well as useful tactics for communicating with stakeholders.

Give this a try, though! I'd love to know how it turns out for you!

However, before I leave you…

## Reasonable Objections

People tend to be skeptical of this process. Seems like a lot? For what benefit? So I want to address some of that:

### Time Cost

> This seems like a lot of effort? Is the improvement here really worth it?

I think so, yes! (Or I wouldn't be writing about it, would I?)

Basically: as a team leader, this is work you'd be doing anyway. Even if you aren't doing it directly, someone else (maybe your PM) is breaking down projects into smaller components that can be worked as tasks.

After that, it's pretty common for a stakeholder to count the tasks/stories/points in the project and divide by the team's velocity to get a simple number. This process provides benefits above and beyond that because:

1. We're breaking down work down past where an external stakeholder or PM would necessarily have expertise. Doing this requires you to build a good idea of the feature/project/requirements, and puts you in a position to be a good partner.
2. It gives your team a chance to come up to speed on the same, as well as creating opportunities for them to point out issues.
3. It's generally more accurate than a simple velocity calculation.

I talked a lot about the statistical machinery in this post since it's important to use that correctly. However, a lot of the benefit of this process comes from the discussions you have to have to run it.

### Anchoring Bias

> How do you run the estimation sessions? Don't people anchor on the first number they hear? Doesn't this process also bias towards the loudest or most senior person's view?

This is sort of orthogonal to the estimation process, but it's important!

First, I've played a game with people when running these meetings. Instead of just opening the floor and saying "what do you think is the worst-case estimate here?" I'll ask people to show a number of fingers on the count of three. Then we have a discussion about why there's a broad range, or simply accept the lowest/highest answer for a narrow one (depending on if we're doing worst-case or best-case.)

All that goes out the window, though, if a team has unhealthy group dynamics. If you have a single person or group dominating the conversation, you're going to get a worse result. Fixing this is outside the scope of this post.

### What about fixing 50% confidence?

> How do you calibration 50% confidence for the normal case estimates? Seems like a tricky skill to learn. Most teams will be guessing.

Yep, most teams will be guessing at first. However, we'll get data pretty quickly as to how well we guessed. Unfortunately, I don't have a convenient statistical trick to adjust the expected case if you're consistently ending up on one side of the line. However, that's data that you can take into the next projects and learn from.

McConnell also has a number of strategies in the book that help increase accuracy here.

### Identifying Gaps

> You mentioned that the biggest inaccuracies have been due to missing work. How do you get better at that skill?

A combination of best practice and battle scars. After each gap, I've been collecting questions to ask to avoid the issue in the future. Again, my list is available at [feature-proofing checklist](@/feature-proofing-checklist.md) and I encourage you to steal it and make it your own! (I've given this to new team leaders as a handout for years, and it's usually been pretty helpful!)

Some notes on mine:

- It starts with a bunch of "why" questions. If you can't answer those for your team, you're not in a good place. This also helps push back on junk work that people haven't thought through.
- It's a lot of work, but this is another case where you should be doing most of this anyway.
- You don't need to answer all the questions up front or by yourself. The first section is work with your PM or stakeholders, the second is for gap coverage, and the third has a few questions for nearer the tail end of the project.

### What if your estimate is unacceptably long?

> What if someone expects a feature to take 3 weeks and you come back with a 3-month estimate?

Yeah, this happens. It's painful, but a good opportunity to make implicit assumptions explicit. While it can be annoying to have to negotiate/cut scope, that's part of the job sometimes too.

In my experience, this only has to happen once or twice before people start asking your opinion much earlier in the process. So there's a virtuous cycle here as well, in terms of doing a good job on engineering leadership!

[^cassandra]: Of course, it's possible that you're in a [Cassandra](https://en.wikipedia.org/wiki/Cassandra) situation and credibility and accuracy aren't the problems. If that's the case, I've been there and this process isn't the way out. Sorry!

[^lake-michigan]: about 6 trillion US (short) tons, or 5 trillion metric tons.

[^law-of-large-numbers]: If you have fewer than 10 items in your list, you may want to consider breaking them down more. At 10 items and above you start to benefit from the law of large numbers, where errors in your estimates will start cancelling out.

[^why-50-and-98]: Why 50% and 98%? Two reasons. First, people are generally happy with "whether we finish early is basically a coin flip, but you can make plans around hitting the end date." Second, I can remember the calculations off the top of my head: 50% is `expected + stddev` and 98% is `expected + 2 * stddev`.

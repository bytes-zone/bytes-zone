+++
title = "launch ftw, part 11"
date = 2023-07-09
+++

Before I just jump into finding communities around property testing, I wanted to try and do a cold answer of the launch FTW questions in lesson 4 (which I've been putting off since… June 26th? Shorter than I thought, actually.) Anyway, here they are, along with my answers (cleaned up slightly.)

By the way, if you're unaware: property testing is like unit testing but with automatic test case generation. This is a straw man, but in example-based testing of an "add" method you might say "ok, add makes numbers go up" and write down pairs like 1+1, 2+20, 3+1e9. In property testing, you might say "add _always_ makes numbers go up" and tell the system to give you any two numbers, asserting that the result is higher than both of them. Then the property testing system will immediately give you a negative number and you'll be like "oh duh."

Anyway, the questions:

- **What's one thing that people need to know, but don't?**

  You don't have to be a galaxy brain to come up with good properties. Most follow a small number of themes.

- **What's one thing that people fail to do?**

  Writing down a description of your system is often enough for finding good properties, and people don't really do that. At least in my experience, you get the "blank canvas" experience where you're just staring at a screen and saying "uhhhhhh" if you miss this step.

- **What's one thing that that people waste time on?**

  Writing property tests that only exercise like half the possible cases instead of finding ones that are universally true. Leads to a lot of flakes and conditionals in the test. Like other forms of testing, this is a "smell" and can mean you should break up the system under test to make it more testable.

- **What's one thing that people always screw up?**

  Other than the above… over-filtering, maybe? Just "too many conditionals" in general.

- **What's one thing that people complain about all the time?**

  Property testing requires more and different kinds of effort than example-based unit testing. (They use language like "it's harder" but seem to mean "it's harder _for me, with my current skill set_") People often do not see the benefits, either, because their property tests are flakier 'cause of all the conditionals.

- **What's one thing that people don't understand?**

  Mathematical properties are often better than stuff you just make up, but the stuff you make up can work unreasonably well too.

- **What's one valuable thing that people don't have time for?**

  Sitting down and writing out a full specification of their system, at least semi-formally. That often shows a bunch of useful properties and is helpful regardless, but it involves using a bunch of hard-to-acquire skills and takes quite some time.

  Also, verifying that the examples follow a reasonable distribution (e.g. not cutting off all the edge cases.)

- **What's one thing that people love achieving?**

  Getting tests failures that make them say "oh, I hadn't thought about _that_."

- **What's one thing that people feel great about?**

  After having a passing test suite, people tend to feel better that the code is more "bulletproof" than other code they've written.

- **What's one thing that people consider to be "successful?"**

  Having working software. "Correct" or "correctness" is often invoked.

- **What's one thing that makes them lose money?**

  Bugs, I guess? Or the costs of having to redo work (although in my own experience that's more of a social cost than a monetary one.)

- **What's one thing that makes them earn more money?**

  Since the audience is mostly programmers, and programmers mostly make money by being employed… I guess the perception of intelligence? You can get a lot more people to listen to you by being perceived as smart. Commands a higher salary, too.

This was difficult for me! It's early and I'm pretty tired and it felt like my thoughts were extra slippery. I'm glad I put the effort in to tie them down; I see some themes here around accessibility and approach here that could at least be useful products.

I think it might also be worth revisiting this exercise and putting in the effort to answer these questions for Sorbet or Formal Methods. I've been in a (broadly-published) blogging drought recently and it seems like this could generate good ideas for that, too.

Next time I'm going to go out and if I can find reasonably-sized communities around property testing. I was able to find a few things immediately but I want to dig in more.

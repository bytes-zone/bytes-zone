+++
title = "Moving From Example-Based to Generative Tests"
date = 2021-01-19
draft = true
+++

(TODO: this title is not great. Figure out a better one.)

- Trading Specificity for Coverage (?)

When I think of "testing" as a whole, unit tests always show up first in my mind.
Their core characteristic is that they're based on individual examples.
In other words:

- They each take a specific input and some process, and assert that you get a specific output.
- I probably have a lot of them, and I can run a small group of examples to zoom in on something I'm implementing.
- Hopefully, they're exhaustive: if I run all of them, I want to find out if I broke anything, so I run them all regularly (for example, in CI.)

The specificity here is really useful!
If I have some specific thing I want to do, all I have to do is write down the specific input and output I want.
The test framework then makes sure that the code does what I intend.
Great!

This specificity leads to practices like test-driven development, where you write the smallest possible examples that move towards the thing you intend.
That's way harder to do if you can't express yourself with this kind of specificity!

But example-based testing has drawbacks too: that amazing level of control means that you have to specify 100% of the cases that you want to be tested.
If you forget one, it's just not verified.
And that's before even thinking about the fact that to test all the edge cases in your integrations between different things (classes, data structures, whatever) you've got to _multiply_ the number of edge case tests in each!
That's a lot of examples!

This is where a lot of people learn about generative tests, usually through property tests.
The basic idea here is that you trade specificity for coverage: you don't have to write every single case yourself, but tell the computer how to write them and it can test hundreds or thousands.
But to do that, you have to come up with some pretty specific properties.
This, in a word, is hard!

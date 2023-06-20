+++
title = "launch ftw, part 3"
date = 2023-06-20
+++

Lesson 2 is fairly light, but has an important lesson. Big takeaway: learn what people need, want, and are willing to buy. (That was the first rule last time, as well.) I like the framing of "**find misery and fix it.**" This is familiar to me from 30x500, but getting a compressed version like this helps me see the process at a high level!

Well, then, on to lesson 3. Emphasizing that you need to make something people are *already* willing to buy—"it's a million times easier to capture a need than create one." In other words, skip the traditional startup advice of having an idea and then finding a customer. Instead, find the customer first, then build a custom solution to their problem. To do that, you need to find:

> What does your audience
> 
> 1. actually do
> 2. actually talk about
> 3. actually complain about
> 4. actually read, share, try, recommend and, of course
> 5. actually buy
> 
> The answers are Sales Safari gold.

So who are your ideal customers? What is your ideal audience? It's "the people you are best suited to serve." In other words, people you already know things about because they're people like you.

There's an interactive workbook in this step. Before I do it, the tips are to prioritize:

- professional audiences (because they're used to paying for things)
- audiences where you have some built-in advantage (e.g. because you consult or work in the space.)

Copying my answers back here. First question, "List your potential audiences." As many as you can come up with, one per line. Here are mine:

> formal methods people
> Alloy users
> TLA+ users
> Elm programmers
> Rust programmers
> Ruby programmers
> Sorbet users (subset of Ruby programmers)
> makers
> 3d printer users
> laser cutter users
> parents
> omnifocus users
> obsidian note-takers
> stationery bike owners
> frontend developers
> Helix users
> Vim users
> Kubernetes folks
> programmers (generally)
> command-line shell users
> TDD practitioners
> tech leads
> staff engineers
> Linear users
> toolmakers

Second question, narrowing those down to "professional" options:

> formal methods people
> Alloy users
> TLA+ users
> Elm programmers
> Rust programmers
> Ruby programmers
> Sorbet users (subset of Ruby programmers)
> 3d printer users
> laser cutter users
> omnifocus users
> obsidian note-takers
> frontend developers
> Helix users
> Vim users
> Kubernetes folks
> programmers (generally)
> TDD practitioners
> tech leads
> staff engineers
> Linear users
> toolmakers

Third question, narrowing those down to ones where I have an advantage. In my case, that mostly means "have I used this in the past and would have some advice for someone just getting started." I also removed general programming and toolmaking because I have an advantage but it's too vague!

> Alloy users
> Elm programmers
> Rust programmers
> Ruby programmers
> Sorbet users (subset of Ruby programmers)
> frontend developers
> TDD practitioners
> tech leads
> staff engineers

Fourth question is just to pick one to move forward with for launch ftw. This is where I struggle, and the exact question I stopped on the first time I did this challenge (even though they repeatedly say that the only "wrong" answer is to just not pick.)

… and after 15 minutes of flailing about trying to think through it ("well, this, but no, then again, that…") I've got to try a different approach. I've put the lines into [elo.bytes.zone](https://elo.bytes.zone) (a tool that I wrote to help with analysis paralysis) and done head-to-head comparisons until each of them got at least 10 tries. Here's the results

| Rank | Item                | Rating | Difference from Last |
| ----:| ------------------- | ------:| --------------------:|
|    1 | Sorbet users        |   1307 |                    - |
|    2 | Ruby programmers    |   1305 |                   -2 |
|    3 | frontend developers |   1279 |                  -26 |
|    4 | Alloy users         |   1269 |                  -10 |
|    5 | Rust programmers    |   1192 |                  -77 |
|    6 | tech leads          |   1167 |                  -25 |
|    7 | Elm programmers     |   1117 |                  -50 |
|    8 | TDD practitioners   |   1076 |                  -42 |
|    9 | staff engineers     |   1046 |                  -30 |

There's a big gap between the top four and the rest of the field. For example, I did 30x500 with Elm stuff. It gave me a considerable amount of traction in my career! But I feel burned out in that community; 5 years of running elm-conf took a lot out of me, and I'm experienced enough in the discourse to be tired of the "permanent problems" and no longer interested in debating them. I see a similar situation developing in Rust, especially with [recent problems in the community](https://www.jntrnr.com/why-i-left-rust/). (Although TBH this may be just growing pains due to popularity. I recall Ruby had quite a few community problems when it was super popular.)

So, OK, that leaves basically four things (or more like three, since Sorbet and Ruby are gonna be similar audiences.) Examining each:

- Folks who are interested in Sorbet are generally interested in making Ruby code more predictable and safe. Reading between the lines in their marketing and docs, it's a similar attraction to folks who have moved from JavaScript to TypeScript.
- Rubyists generally are a nice bunch. It's a really big circle since it was so popular for so long, which means more eyeballs and dollars in a really general sense.
- "Frontend developers" is a little vague… but I really mean people who are interested in developing on the web as a platform. There's a ton of stuff happening every year in CSS, HTML, new JS features, new platform features. Hard to keep up! The nature of the web means that this audience should *stay* pretty large as well.
- Alloy users is more niche. It'd be nice to grow interest in it, but that's counter to the advice here about addressing a need rather than creating one (although the need could be "I spent weeks developing this feature, only to find a design flaw that means I have to start over… ARGH!") Promoting the tool as an alternative seems good, but I'm not sure where I'd find people who had that particular pain.

So out of those, folks who are getting into Sorbet seems like the best fit. It's a good combination of a large-enough audience and a relevant topic (e.g. there are people starting Ruby projects today as well as folks who are dealing with code written in 2008.)

So, all aboard the Ruby/Sorbet train!

+++
title = "launch ftw, part 12"
date = 2023-07-19
+++

Ok, it's been about ten days since I last worked on this project. In the intervening time I've been working on some custom software to do time tracking in the way I want, so I haven't been focusing on this. But, you know what, it's Wednesday night and time to party! And by "party" I mean "search the web for people talking about property testing". SO GRAB YOUR CYBERDECK AND LET'S HACK ON.

- Reddit! There are a few posts on /r/programming that include "property-based testing". There are more in the Haskell, Python, and Rust subreddits. One in Ruby, as well. (Hypothesis briefly had a Ruby port. Maybe still has one?)

Oh, before I continue with the bullets, I should say: people call this "property-based testing" or "property testing" or "PBT" or "PBT testing" (real ATM Machine vibes there) or "fuzz testing" (although that's _technically_ a different thing.) They also refer to it by library/ecosystem where X is one of the libraries that does this. Hypothesis for Python, QuickCheck for Haskell/Erlang, Hedgehog for Haskell/F#/some others, elm-test for Elm, etc.

Anyway if you search "property-based testing forum" or "property testing forum" you get a bunch of intro blog posts and some whitepapers. There's also some more relevant results, like [the Elixir subforum dedicated to property testing](https://elixirforum.com/tag/property-testing) (which is fairly inactive.)

… searching searching searching forgot to make bullets …

Ok, turns out I can find a few easy-to-find things very easily, but there doesn't seem to be much depth behind them. _In fact_, I'm finding fewer total discussions than I found with formal methods. I _am_ finding more total blog posts, though, which is not nothing… but it's also not something I can use.

Ok, sigh, what to do about it then? Back to OODA, I guess.

1. **Observe: what am I feeling, why, and what is my impulse?**
   - **What am I feeling?** _Sigh_, another "probably not a good idea".
   - **Why?** "property-based testing" seems to be another strikeout, see above.
   - **What is my impulse?** Switch to "team leads" and try this exercise again.
2. **Orient:**
   - **What is happening?**
     - I spent like 45 minutes finding not very much again.
     - There's no single "community", just people using the general technique across a bunch of different programming languages.
   - **What does the data say?** The kind of discussion I want to read and participate in doesn't exist, at least not in places that are accessible for me. (disclosure: I copied this from last time.)
   - **What do I want?** I want a place to get a slightly easier foothold. (disclosure: same.)
3. **Decide:** I'm going to move on to Rust. "Why not team leads" below.
4. **Act:** Going to carve out 25 minutes to try this tomorrow. I bet I can find stuff pretty quickly.

Before I said that I was going to carve out some time to focus on why I was hesitant to pursue Rust as an opportunity. Basically it came down to wanting to pursue techniques over tools… in particular, things that had more staying power than trendiness. But look: pursuing Elm meant that many people in the Elm community knew my name, that I had a successful conference, and eventually that I got a solid job that I've been at for the last 6 years. Even today I keep in touch with a lot of people that I got to know and like through the Elm community. Even though Elm is not something I want to pursue _right now_, I couldn't exactly call any of that unsuccessful. Going somewhere that I don't have the same kinds of feelings about but which has similar potential upsides seems like something I can get behind!

On the other hand, it seems like pursuing "tech leads" might be more of the same kind of issues that I've seen before. Plus, I feel some fear about giving people bad advice and hurting their careers instead of just their code.

So all that to say that I'll be pursuing Rust next! Looking forward to it.

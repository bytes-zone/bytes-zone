+++
title = "launch ftw, part 7"
date = 2023-07-02
+++

I've felt a little stuck for the past couple of days. There's a couple parts to this:

1. (Minor) I intended to get up early to work on this, as I usually do, but had a hard time waking up and ended up falling back to sleep and missing the chance.
2. (Major) When I *did* have the opportunity, I haven't felt motivated by Ruby or Sorbet stuff. In fact, looking around it seems like Sorbet is still fairly niche. From community discussions I've looked at, it seems like most people are bouncing off Sorbet (and RBS too) saying things like "it's never good when there's daylight in between the things your type system can express and the things your language can express." And, I mean, that's fair! It's also overcome-able, but do I really want to fight an uphill battle there?

Basically, I feel uncertain whether the audience I had in mind (Rubyists interested in adding static typing for additional safety) actually exists. People who are using Ruby seem perfectly happy with dynamic typing. That's not *particularly* surprising, though, and my view might have been influenced by people in my company who are enthusiastic about adding static types to everything? I suppose it might be time to try OODA…

1. **Observe: what am I feeling, why, and what is my impulse?** Uncertainty, because I am wondering if I had a straw man standing in for my audience of the sparse results I'm getting when searching for Sorbet stuff. My impulse is to say I had a misperception, drop this as a target, and try and find a different audience.
2. **Orient: what are the facts?**
	- **Where am I?** Very early in the process of figuring out what I want to do/build.
	- **What's happening?**
		- There's nothing external here that means I need to make a rush decision. Good!
		- I recently had an opportunity fall through related to Ruby stuff that may be putting me in a more pessimistic mindset about this.
		- I have also chatting with people who are excited about formal methods/modeling and I'm excited to learn more about that for myself.
	- **What does the data say?** I am mostly basing my opinion on reading chat messages in the Ruby Discord, where there's a weird gap: you either have people who say "I use Sorbet for everything and you should too" or people who say "what's this Sorbet I keep hearing about?" Nothing in between. No struggles about installation, or expressing types, or anything. This could just mean that people aren't using this Discord as a place to get Sorbet-related questions answered, though?
	- **What do I want?** Same as before—to make a sustainable business, starting by making around $10k on the side in the next year. That's the goal, and I'm not emotionally/socially tied to any particular audience (although staying in programming would probably be ideal since I have considerable advantage through experience.)
3. **Decide: what will I do?** I might have gone from one kind of bubble (very pro-verification) to another (people who embrace Ruby's dynamic nature.) I could look over the other Ruby community spaces and see if the thing I'm inferring is actually happening across more spaces!
4. **Act!** … the rest of this post

OK then…

- **Twitter:** Not a lot of movement on Twitter, but I might not be searching hard enough (or it's promoting bluechecks or something?)
- **Ruby on Rails forum:** [Very few results on the Ruby on Rails forum](https://discuss.rubyonrails.org/search?expanded=true&q=sorbet) Several are from folks who are trying to make everything work nicely together and are getting errors. (But one of them says they've "fallen in love" with Sorbet recently, which is encouraging.)
- **Newsletters, dev.to, Ruby linklog, ruby-forum.com:** nothing
- **Ruby on Rails Link Slack:** a fair amount of discussion on the Ruby on Rails Link Slack. However, it's mostly the extreme "what is this" or "I use this everywhere" stuff. Also someone has a conspiracy theory that the Chan-Zuckerberg Initiative is using Sorbet as a Trojan horse to destroy Ruby? What? People are strange.
- **/r/ruby:** only has one discussion thread
- **/r/rails:** very light
- **Sorbet Slack:** this is where most of the discussion happens, that I can find
- **StackOverflow:** reasonable amount of questions, but no discussion

So outside of the Sorbet Slack and SO (which are officially endorsed by the Sorbet team at Stripe/Shopify) we're talking like under 25 posts where people are sharing pain across my view of the entire Ruby ecosystem. To add to that, the Sorbet Slack is free (so limited to 90 days of posts) and SO doesn't really allow discussion in a way that's useful to me in finding people's deep pains. It seems like the thing I decided to do above (find out if I was looking at a bubble) resolves to "you weren't looking at a bubble."

So, basically, it seems like people are interested in Sorbet, but they're not sharing their struggles using it. This is suspicious to me because if Sorbet were being widely adopted I'd expect people to be sharing way more—it was super hard to set up for me for our Rails app!

Let's OODA again:

1. **Observe: what am I feeling, why, and what is my impulse?** Reusing the answer from above: uncertain if continuing with Ruby/Sorbet is a good idea.
2. **Orient:**
	- **What is happening?** I just found out that my idea about adoption of Sorbet in the Ruby community was a straw man based on my own company's behavior around Ruby.
	- **What does the data say?** It says there's not a lot I can work with in this community!
	- **What do I want?** Top-level goal is still the same. I want to switch audiences, though.
3. **Decide:** Based on my audience brainstorming before, I think I can widen "Alloy users" to "formal methods practitioners." You have people looking in from the outside and wanting to get started, you have people willing to pay for services inside the space, you have people wanting to level up their game… or, at least, I think you do!
4. **Act:** for tomorrow and during this week, I'm going to chat with the people I know in this community and see if I can get a sense of where folks are hanging out online. I'm fortunate in that I have social connections to a couple people who are active in the formal methods space, so I can just start by asking them!

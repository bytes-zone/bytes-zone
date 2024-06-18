+++
title = "launch ftw, part 13"
date = 2023-08-14
+++

Time passes (almost a month this time) and I'm back. Enough time has passed that it might make sense to start over from the beginning, but this time I actually have an idea of the product that I want to make: I noticed that in almost every instance where formal methods come up online, there is at least a subtext of "but how do I actually get started in this?" I think I could help there!

<!-- more -->

Basically, I have noticed that there's a sweet spot of formal methods when used as documentation. You don't even have to use software for this; you can write a decision table or decision tree on a whiteboard and instantly have something useful for a team to talk about.

This is pretty off-script from what I decided earlier, so I think I want to find a little justification in the real world. Let's just root around in Hacker News comments for a bit, since that's attracts a pretty wide slice of tech folks.

Some quotes:

> I see lots of value in adopting [TLA+ and Alloy], but the dsl's that they use are inscrutable to me. I'm sure that after some hands-on time I'd understand them well enough, but having a hard time figuring out how to get that ball rolling.

> It looks pretty impressive, but I’m struggling to find the practical problem it solves. Lots of jargon, eg “constraint language for modelling data structures”. How will that practically help making development easier / better / more secure?

[Some answers to that question by Hillel Wayne](https://news.ycombinator.com/item?id=20012979) and [a gist of an access control model](https://gist.github.com/hwayne/2619df2dd7055a57de96f8769c37fca6)

> I tried and failed to learn Alloy, the documentation is too mathematically dense for me, even though I suspect the concepts aren’t difficult for a working programmer. Any tips on prerequisite knowledge are appreciated.

> Every time I see some TLA+ related article, I read it and then spend an hour convincing myself that I don't have time to learn it right now, even though I really want to. That convincing usually comes in the form of showing that the gains are not worth the effort for the software field that I am in. Can someone change my mind on this?

Response to this: "I'd recommend design by contract as a lighter way of verification." [The whole thread](https://news.ycombinator.com/item?id=19661809) here is also pretty good with people recommending things, including this great summary of the benefits:

> Formal specifications themselves have a few benefits. The first is they force you to make everything explicit that's usually a hidden assumption. From there, they might check the consistency of your system. From there, you might analyze them or generate code from the specs. Spotting hidden or ambiguous assumptions plus detecting interface errors were main benefits in industrial projects going back decades.

> I love the concept of formal verification, but translating my algorithms into yet another DSL and hoping I get that right seems like a waste of time. I'd rather simulate the algorithm with my brain.

> Can someone who has learned TLA+ comment on how useful it is has been for you?

[A story from AWS about saving a ton of time by using TLA+.](https://news.ycombinator.com/item?id=19634915)

Oh hey, Hillel Wayne's "[Using Formal Methods at Work](https://www.hillelwayne.com/post/using-formal-methods/)" has documenting an existing system as one of the top-level good ideas. Neato.

> My mind works best with examples, I was about to ask here when I stumbled upon it on the TLA site.

(In support of documentation—aka examples—as a sweet spot.)

> Simply put, there isn't any time to do any of this.

> Formal methods can help you come up with a specification (i.e. deciding what the program should do).

Hmm:

> Formal specifications are the anthesis to agile thinking, our business folks change demands all the time, expecting them to stick to some up front spec that can be proven is hilariously unlikely. This also ignore the need to continuously update and extend software: it's not just a one time development that ends. We are given too little budget as it is and have to make do with too few people and too little time to try to complete things that are constantly changing. You can argue a formal spec makes things better, I can argue not one of our VPs would even understand the concept much less pay for it. Sure that could be fixed by replacing all of our VPs, but unlikely, despite my desiring it.

I don't feel like I have as strong a conclusion to this as I'd like, but I do have some observations after reading the discussions I could find with broad search terms:

1. Everyone seems to have a different idea of what "formal methods" means, and a different idea about whether they're easy/hard, quick/time consuming, etc. It would make sense for this to be because "formal methods" is an umbrella term for a lot of stuff. For these people, I'd want to recommend "lightweight" formal methods—and that's what I want to teach anyway, not being so mathematically inclined as to teach proofs.
2. I forgot how mean-spirited Hacker News commenters could be, especially when they're trying to build clout without having to engage with the ideas in the things they're commenting on. _That said_, people writing solely from their biases and preconceptions gives me a fairly clear window into their biases and preconceptions. Helpful!
3. It seems like "documentation" might not be a good way to think about this… maybe it's more "build one to throw away" or some other concept? I guess I'm coming to "documentation" from "if you have thought through something thoroughly, you should be able to explain it to someone else." If that explanation takes the form of persistent docs, great, but I guess the important thing is the thought process. That's what lightweight formal methods are great for!

No real conclusion here; I'm going to have to have a think about what's best to do going forward.

+++
title = "launch ftw, part 6"
date = 2023-06-27
+++

Ten threads. Let's go.

- [Rails - How to work with serialize attributes and Sorbet](https://stackoverflow.com/questions/75935405/rails-how-to-work-with-serialize-attributes-and-sorbet)
	- pain: how do I get types on a `serialize :related_pages, Array` call?
	- comment: DoN't ViOlAtE FiRsT nOrMaL FoRm
	- OP: I just want this to be typed! This table has 10 million rows! My life is hard enough without you telling me to refactor my database!
	- This question didn't have an answer. I answered it because, like, I've been there man.
	- I forgot how annoying and pedantic SO commenters can be.
- [What is the directory structure for adding Sorbet RBIs to a gem?](https://stackoverflow.com/questions/69155000/what-is-the-directory-structure-for-adding-sorbet-rbis-to-a-gem)
	- pain: docs say I need an `/rbi` folder, BUT WHERE?
	- answer: literally just in the root of the project. A single file is fine. Sorbet is happy.
	- secondary pain: neither the OP nor the answerer found the docs very clear in this case
- [How to configure Sorbet with rspec?](https://stackoverflow.com/questions/74842832/how-to-configure-sorbet-with-rspec)
	- pain: Sorbet doesn't know how to figure out the core rspec DSL, so it's complaining that `describe` isn't a valid method.
	- solution: binding `self` to `T.untyped` so Sorbet lets you do whatever. (I'm not certain that the OP knows that they've just turned off typechecking for all instances of this receiver?)

Alright, ok, you got me. That's not ten threads! But it is three, and I took the time to answer one of them. I also looked around and found a handful of threads that I *want* to look at on the Sorbet Slack, so that's some collection done.

As a little status update from yesterday, I asked around in the Ruby discord for help finding more places to look for pain. A few people got confused and thought I was a beginner asking for help, but someone shared a big list with me. Gonna have a look through that soon!

And a thought from yesterday: I went to a [Model Monday](https://www.bellotti.tech/courses) yesterday and someone mentioned that professors who teach programmer frequently don't actually know the problems that their students are struggling with because the students make all the typical mistakes while doing homework, and the professors only see the finished version. I've taught Sorbet to a bunch of people at work, so I've seen some of the mistakes there, but I wonder if I'm going to run into the same problems looking online? I don't think so, anyway; it seems like if folks are willing to post a problem online they're really feeling stuck!

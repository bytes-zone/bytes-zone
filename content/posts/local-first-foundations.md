+++
title = "Local-First Foundations"
description = "When we say \"local-first\", what do we mean?"
date = 2025-01-22
+++

I'm writing a book about local-first software tentatively called [Local-First From Scratch](@/projects/local-first-from-scratch.md). This is a snippet from that book—an intro to why you should care about local-first software and what it gets you. I thought it ended up being a pretty good summary of what the whole project is about, so I wanted to share it as a blog post as well!

---

If you picked up this book, you might have some idea about what "local-first" means[^lf-manifesto], but let's get on the same page: other than "works offline", what are we aiming for?

In short, local-first software moves ownership of data from "somewhere in the cloud" to your local devices.

<!-- more -->

This has a bunch of consequences. We like some of them:

1. Updates are practically instant because the network does not have to be involved. No loading times or spinners! You can also work completely offline.
2. You are in control of your data and control who gets access to it.
3. A company going through an "incredible journey" acquihire doesn't mean you lose access to your work.

Of course, *implementing* these ideas is a little harder than just storing data in a local SQLite database. There's a cost paid in complexity and figuring out new ways of doing things. For example, we'd typically enable sharing by having a central server hold all the state. But we can't do that if the user is offline and can't reach the server![^local-first-business-case] So local-first also raises some questions we need to answer:

1. You probably have more than one device (phone, computer, etc.) Which one is the "real" copy?
2. If you want to share your work with someone else, how?
3. When you share—either with other devices or other people—how do you avoid conflicting writes?

We want satisfying answers to these without giving up local control. The typical approach—and the one we'll implement in this book—is CRDTs.

[^lf-manifesto]: If you want to learn more about local-first principles, Ink & Switch's essay [*Local-first software: You own your data, in spite of the cloud*](https://www.inkandswitch.com/local-first/) is a great place to keep going. You may hear folks refer to the "local-first manifesto"—this is the thing they're talking about.

[^local-first-business-case]: This blows up a lot of SaaS business models that depend on a subscription to a central server. We're not going to address the business ramifications of local-first software in this book. If you're interested in that, as of early 2025 the Local-first Software Discord hosts frequent online meetups where people share their experiences.

---

That's it for the preview. Keep an eye out for the book hopefully later in 2025!

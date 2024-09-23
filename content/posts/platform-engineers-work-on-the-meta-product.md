+++
title = "platform engineers work on the meta-product"
description = "a better definition for platform engineering"
date = 2024-09-23
+++

In [[what is platform engineering?]], I gave this definition:

> Platform engineering, as a discipline, takes a coherent approach to improving an engineering organization's output in ways that the rest of the business can see and understand.

I've had some thoughts and discussions since then, though, and I think that definition needs revising. Specifically, I tried to be very clear in the last post that I didn't think platform engineering could/should be gatekept. Problem is, that previous definition has some scoping issues—mostly around vagueness—that could work against that goal.

For one thing, it gives a bad-faith interpretation some gotchas: you could be doing the work of platform engineering, but have someone argue that your approach is not "coherent" or that the business cannot see and understand your work. I gave examples in the last post, but that feels like a bad substitute for the definition itself being clearer.

For another, the language here is too broad: there are differences between SRE, devops, and platform engineering, but this definition does not give you the tools to distinguish between them. To be fair, I think this is minor; this definition gives enough information to get started, or to explain what you're doing to someone outside your immediate work. But I also think definitions should allow for clear distinctions, and this one doesn't.

Fortunately, I think I see a way around all these problems in two steps. First: who is a platform engineer?

> A platform engineer is someone who does the work of platform engineering.

If you make art, you're an artist. If you make music, you're a musician. If you do the work of platform engineering, you're a platform engineer. That definition resists gatekeeping, which I like. But what is the work?

> Platform engineers work on the internal product that other teams use to make the customer-facing product.

Or more succinctly:

> Platform engineers work on the meta-product.

I like a couple things about this. First, this clearly includes the things we care about: CI/CD, developer experience, tooling, moving observability tools to where developers can see and use them, etc. If it’s part of the internal product, then it's in scope.

Second, it distinguishes between the work of platform engineering and SREs or devops. For example, when I've worked in devops or SRE roles, I've cared a lot about what applications are running where, what kind of traffic loads we're expecting, or how much we're spending to deliver the product. These are all customer-facing concerns, and might not be in scope for platform engineering.[^1] The meta-product here would be working on things like adopting Terraform or Kubernetes, which automates a lot of that work and allows teams to ship the product more efficiently.

Now, someone might say "ah, but SREs care a lot about automation! That's the meta-product and actually a big part of the gig!" Yes, good, that's correct! But check out the new definition: are they working on the meta-product? Yes? Then they're doing platform engineering in addition to SREing. That's fine; I acknowledge the overlap here. Part of the utility of this definition is that it allows us to recognize this overlap, while still making a distinction. People hired into platform engineering roles may (and probably will) work with SREs on cloud automation projects, but that's not their only thing.

Let's examine this from the dev side as well: at a small company, you probably don't have someone specifically doing platform engineering as their whole role (for, say, more than 50% of their time.) But you still need a platform: gotta set up CI and a deployment target, at minimum. Congratulations, you're doing platform engineering! Nobody can tell you you’re not.

Finally, in the platform engineering role itself, this serves as a good charter for an individual or team. Where there’s overlap, you can share the load. Where there’s not, it’s clearly your responsibility.

So there you have it: a better definition. This still isn’t perfect, but I think it’s a big improvement over the last one.

[^1]: I know about (and have worked on) teams named "platform engineering" who spend most of their time taking care of cloud infrastructure. I think that's more a titling issue than anything, and it depends more on the age of the organization than their level of seriousness. Terms vary, people use language differently, it's fine.

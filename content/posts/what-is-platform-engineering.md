+++
title = "what is platform engineering?"
date = 2024-09-09
description = "definitions are hard, but making them is useful"
+++

Today I'm starting my third[^jobnum] platform engineering job. During the interview process, I had a few people ask me what exactly a platform engineer does, and I realized that…

1. I've had my own short answer—"a platform engineer finds and reduces friction in the engineering organization"—but that's more an example than a proper definition, plus it doesn't cover everything.
2. There are a bunch of confusing/contradictory answers floating around the internet if you just search it. This is made worse by vendors who seem to want to gatekeep the term to sell products. (Can you really even _be_ a platform engineer if you're not running an IDP???[^idp] Contact our sales team!)

Anyway, I though it'd be useful to try and sum up the things that platform engineering is/does in a succinct definition. <!-- more --> Here's what I came up with. I'm not saying it's perfect, but it's helped me understand my role better:

> Platform engineering, as a discipline, takes a coherent approach to improving an engineering organization's output in ways that the rest of the business can see and understand.

Breaking some of that down:

- **an coherent approach:** The thing that sets platform engineering apart is that it focuses on making an integrated whole out of processes that are often otherwise approached in a piecemeal (or incoherent) way. (You could also say "holistic" or "integrative" or "product-minded approach.")
- **improving an engineering organization's output:** By focusing on output, platform engineering takes a fairly wide area of responsibility. Improvement can mean a bunch of different things, as can output.
  - Some examples: improving p99 response times, increasing test coverage, decreasing CI pipeline runtime, coordinating penetration tests, consolidating docs, finding new project management tools, auditing and classifying runtime exceptions, and training teams in new tools and methodologies. (As a matter of fact, I've done all of those at some point or another as a platform engineer.)
  - As a counterexample, platform engineers typically do not work on the "people" side of the engineering organization. For example, we don't train managers or consult with teams on the best ways to work together. But we _do_ conduct ourselves with the human side in mind.
- **in ways the rest of the business can see and understand:** to be effective, platform engineers need to be able to talk about our work in ways that the rest of the business can buy into. For example, this might mean being able to talk about both the system's ability to handle increases in transaction volume and what that means for scaling runway. Usually this means quantifying achievements, but it also may mean being able to talk about, say, the impacts of developer experience on voluntary attrition.

To put it another way, platform engineers work _on_ the engineering organization instead of just _in_ it, at least to some degree. They can't spend 100% of their time here though: platform engineering needs to have a solid idea of the day-to-day challenges and pains the organization experiences in order to do an effective job.

This also isn't work that can be gate-kept, no matter how much a vendor might want to. You need to do at least some of this work to have a functioning software business in the first place. For example, how does your code make it to production?[^devops] How are builds and tests run? Engineers need to do this work regardless of if they have someone specifically focused on platform engineering, but it might be at the cost of not focusing on the things that they excel at.

You sometimes hear people talking about this with the terms "inner loop" vs "outer loop." Time spent on the primary process of improving the product (coding, writing tests, etc) is the inner loop, and time spent on stuff like deployments or requirement definition is the outer loop. The value in hiring someone to do platform engineering for your business is that they can work on minimizing the time everybody else has to spend in the outer loop.

There are a couple other interesting things that fall out of this definition too. For example, it explains why platform engineering tends to be the interface between product engineering and security or QA (because they're responsible for output and coherence) and why platform engineers may be later hires at companies (because smaller companies may have more visibility into cross-departmental processes.)

At any rate, I found this definition helpful and I hope you do too!

[^jobnum]: Third-ish, anyway. Maybe fourth, as the eldest of those was a devops-ish role focused entirely on building a deployable PaaS on top of Apache Mesos. At any rate, at least two of the four jobs predate the term "platform engineering" as we know it now by a couple of years. The principles here have been relevant in all those positions, though!
[^idp]: Integrated developer platform, basically an integrated portal to an organization's docs, best practices, deployment patterns, service catalog, etc.
[^devops]: This hints at the fact that platform engineers, devops, and SREs have very closely related responsibilities. I'd say the defining difference is what work each would consider "the inner loop." DevOps and SREs I've worked with have been primarily concerned with safely delivering and running software while platform engineers I've worked with tend to focus more on developer productivity and "shift left" work. This has not been globally true, though.

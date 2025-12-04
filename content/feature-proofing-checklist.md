+++
title = "Feature-Prooing Checklist"
template = "post.html"
+++

Gap identification checklist used in [my software estimation process](@/posts/software-estimation.md).

---

Here are some things we need to consider when creating a new feature:

## Why This? Why Now?

- Why is this the most important thing we could be doing right now?
- How did we arrive at this point?
- What can we point to for folks who are interested about the project?
- Is everything in the project required to get that value?
- Is there a smaller or easier project we could do to get that value?
- Who will have access to the feature?
- How does this relate to our goals?
- How about our OKRs/KPIs/whatever, or other teams' goals, or department goals?
- Who is driving the push to make the feature happen?
  - Who are the internal stakeholders?
  - Who are the external stakeholders?
- How should we communicate with sales and marketing functions about the value?

## How Will We Build It?

- How can we get value from the project quickly?
- What could we get away with _not_ building to get to the goal?
- Is there anything that can be split into multiple iterative releases?

- What have we done in the problem space before?
- Are we going to have to re-learn something that someone else has already spent a long time figuring out?
- Who knows about the problem space? What do we need to ask them?

- Have we built anything like this before?
- Who else knows about this? What should we ask them?
- What are the main domain concepts we're working with?
  - Do we call them different things internally and externally?
  - Do different groups call them different things?

- What is our plan to make this accessible from the start?
  - Are there any interaction patterns we haven't seen before which we'll need to make extra sure to make accessible?

- Is our approach local or holistic? before starting the project, have we thought through where generalization is helpful?
- Before we start, what refactoring do we need to do?
- What code needs to be pulled out of existing pages/components?

- What will be the biggest pain points in building this feature?
- Are there any places where we'll be bottlenecked on having something upgraded?
- Are there any places where we'll be bottlenecked on having two or more things unified?
- Which part/story is going to take the longest? Second longest?

- Are there any pieces where we'll want to/have to try out new technologies?
- Are there any pieces where we'll be pushing our current technologies to their limits?

- How could this fail?
- Model the domain and interactions formally to try and find surprising unconsidered edge cases.
- Does it make sense to sketch out any implicit state machines so we can all be on the same page about how information/capabilities change over time?
- Have we accounted for service-boundary failures? e.g., adding killswitches and automatic backoffs. Have we documented these tools for use in emergency response?
- What are our performance requirements?
- Have we considered STRIDE?

## What Happens After We're Finished?

- How will we tell people using the product about this?
- How are we releasing? (Feature flag? Beta group? Percentage rollout?)
- How will we know if the project has succeeded?
  - What will we do if the project succeeds?
- How will we know if the project fails?
  - What will we do if the project fails?
- At what point would we stop working on other projects & come back to this one because of performance degradation?
- What is our plan for the last 1%?
  - Internal (maintenance) documentation
  - External (how-to/FAQ) documentation
  - Performance metric instrumentation
  - Easy-to-decipher performance metric dashboard
  - Usage metric instrumentation
  - Easy-to-decipher usage metric dashboard
  - Error metric instrumentation
  - Easy-to-decipher error metric dashboard
  - Alerting
  - Automated testing

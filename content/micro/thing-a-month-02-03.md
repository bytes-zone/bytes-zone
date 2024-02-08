+++
title = "a Kubernetes shopping list"
date = 2024-02-08T06:12:53-06:00
+++

I talked to a few people yesterday—it sounds like Kubernetes is where it's at. I really enjoyed Nomad back in the day, but it looks like I'd have to do a lot of roll-your-own, which kind of negates the benefit of operational simplicity for me.

<!-- more -->

That doesn't mean that I'm going to let simplicity go out the window. I looked around and found that Vultr will manage the control plane for free as long as you pay for the worker nodes. Doesn't look like it's highly-available, but I think that's OK for me for now.

So that leaves me with another shopping list to make: how do I run my stuff in Kubernetes?

- **CD and workload management:** I'll definitely use Argo CD for this. I used it in production at my last job and it was great.
- **CI:** Like I mentioned yesterday, I've been wanting "real" CI for my personal stuff for a while. It looks like I have options: maybe Argo Workflows to stay in the family, but Tekton looks fine too. I know I said I'd rather avoid Jenkins but Jenkins X is apparently a rewrite? Interesting. I could also switch Git hosting to GitLab and use their runners.
- **Routing and load balancing:** Bunch of good options. Traefik, the Nginx ingress controller, etc. I'm most interested in Istio, though. Seems like it has a gateway thing? Worth playing around with, anyway.
- **Container storage:** Harbor graduated from the CNCF, so probably that if I don't get something built in with the Vultr cluster. But maybe Dragonfly, which does P2P stuff? Seems cool but I probably don't have the problem it solves.
- **Misc:**
	- A very experienced friend told me that cert-manager and external-dns were pretty much required, so I'm going to look into them.
	- I've also used and loved Argo Rollouts, so that's going on the list. Not *required*, but they worked enough better for me than the core deployment object before and give you options for healthy rollouts so I'm going to use them for sure.
	- I'll need to set up the CSI driver for Vultr too so that my persistent volumes will persist.
	- How do secrets work in Kubernetes now? Do I need to run some component or is the builtin stuff usually good enough?

But, zooming out, I don't want to spend *too* much time on this. It's really easy to tweak and tweak and then never move on to the rest of what needs to happen.

So, guess I'll start grabbing stuff and shoving it into Terraform and see what happens!

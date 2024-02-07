+++
title = "shopping for a scheduler"
description = "evaluating tradeoffs between Kubernetes and Nomad"
date = 2024-02-07T07:07:00-06:00
+++

The first thing on my "meta" list is to get my house in order with how I deploy things. Right now I have a single VM in DigitalOcean that runs my blog, git.bytes.zone, and a couple other smaller static sites. (See [clown computing](@/posts/clown-computing.md).)

That's starting to kind of burst at the seams, though. I haven't done an amazing job separating databases for various things, so they all live in one big server and backup. I also can't publish a blog post without rebuilding the entire VM in Nix. That means that yesterday, for example, I was trying to publish a blog post and Nix (via [nixbuild.net](https://nixbuild.net)) was trying to recompile the Linux kernel. Those are both important things, but they need to be done separately. It's all too messy and needs a good scrub.

<!-- more -->

I'd like to move things into containers (or at least separate them a bit more) and I think I have two great options: [Kubernetes](https://kubernetes.io/) and HashiCorp's [Nomad](https://www.nomadproject.io/). I've used or consulted on deployments of both, but it's been a while so I'm trying to brush up. Here's what I'm trying to evaluate:

- In terms of operational simplicity, I prefer Nomad. It integrates well with Consul for service discovery and Vault for secret management. Kubernetes has all-in-one distributions like [k0s](https://k0sproject.io/) but there are still many many more control loops.
- For ecosystem support, Kubernetes wins in a landslide. For example, I'd like to set up CI/CD for my git server as part of this work (a long-standing pain point for me.) There are like a billion options for Kubernetes—dedicated "cloud-native" ones like Tekton or Argo, plus basically every standalone CI/CD solution has a Kubernetes operator. And for Nomad… not many options at all. There's Jenkins, but I'd really rather not use Jenkins if I can avoid it.
- In licensing… meh, kind of a wash. HashiCorp made a splash with their license changes last year, but it doesn't really affect my use. The enterprise features of Nomad are all things I can live without (geo-replication would be nice but worrying about that now is kind of putting the cart before the horse.)
- How about resource use? Seems like Nomad wins again here but I haven't benchmarked them. K0s seems pretty light though.
- And as far as how they actually are to use: I really don't like templating YAML, but HCL is also semi-famous for being annoying. I could just use CUE for either, probably. Nomad is better at nice deployment patterns out of the box, but Kubernetes can be extended there easily.

In short: it's hard to decide. Both options have things to recommend them as well as clear tradeoffs (the biggest one being operational simplicity trading off for ecosystem support.) It's also the case that either option would be fine, and once all the stuff I want is containerized moving between them is not too bad (my workloads are simple enough that ingress is going to be the pain point rather than overlay networking or service discovery.)

After publishing my last post, I actually got in contact with a couple folks who have used both of these in bigger ways than I have to see what they think. I'm curious to hear what they have to say!

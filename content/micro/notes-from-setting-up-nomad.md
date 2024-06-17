+++
title = "Notes from setting up Nomad"
date = 2024-06-17
+++

A couple people have asked me for my impressions of [Nomad](https://nomadproject.io). I used it a little bit back before 1.0, but haven't touched it for ~8 years so I'm going in with relatively fresh eyes.

The "stack" here is Vault, Consul, and Nomad. Here's a snippet of what they do:

- Vault: secrets management. As well as basic key/value stuff, it can provision things like database credentials on demand.
- Consul: service discovery and configuration store.
- Nomad: container scheduling. Basically, give it declarative manifests of apps to run and it'll figure out placements. Pretty advanced in terms of scheduling; it can do blue/green by default, plus any constraints you'd like (e.g. keeping services from being all on the same node/rack, or running one instance of a service on every node.) Not just containers either; it can do raw exec, Java, firecracker VMs, etc.

I tried to get as much as possible configured declaratively (either with Nix or Terraform) and I think I've mostly succeeded, although secrets management needs a little bit of cleanup (maybe with agenix?)

Here's a collection of impressions in no particular order:

- Overall, I really like using this system. Everything feels well-put-together. It's a neater garden than my Kubernetes setup was.
- Probably the biggest thing to figure out was which piece of the stack depended on which other pieces. You can set it up however you like: for example, Nomad can use Consul to discover clients/servers for clustering, or you can run Consul *using* Nomad. I ended up setting up all three in server mode on a control box, then adding a few clients to run workloads (although it could hypothetically happen all on one machine.) Nomad depends on Consul service discovery to connect clients to the server, and on Vault for OIDC login.
- I would have appreciated more guidance on the "right way" to set up TLS. Nomad relies on mutual TLS to keep unauthorized clients from joining the cluster as well as the usual transport security. There's a CLI to set it up with a self-signed CA, but the docs all make vague references to getting better certificates somehow. I'm not a security person, so that feels just a little unsettling!
- I'm not 100% clear what the network security model in Nomad is. For example, I thought I could use Consul Connect (a service mesh) to control access to services within the cluster, but when I used it I found that I could still connect to all my services in the private Hetzner network. I'd like to restrict that eventually, but I gave up for now since the Envoy sidecars from Connect are pretty heavy given my tasks' needs.
- I really love how declarative and complete the Nomad job specs are. To get similar in Kubernetes, I'd need multiple deployments with pod definitions plus services and HPAs, probably running something like Argo Rollouts to get blue/green deployments. In Nomad that's one file and one control loop.
- I also love the integrations between products in the stack. For example, there's a Nomad provider for Terraform, and I'm doing CD for all my workloads by templating out Nomad jobspecs using Terraform variables.

The one thing that makes me feel annoyed about this setup is the somewhat arbitrary line that gets drawn between the "community" (free) and enterprise versions of all the software. For example, you can set up OIDC login for Nomad in the community edition, but that's a paid feature in Consul.

There are also a few features that I'd be willing to pay a reasonable small-business-sized fee to access, but not a "contact us for enterprise pricing" fee. The biggest one is resource quotas: I can set up namespacing within Nomad, but all namespaces can run whatever they'd like with no limit. I'd like to restrict that, just to limit the blast radius if I mess something up or my continuous delivery API keys get leaked and some cryptominer decides to set up shop in my cluster. I *kinda* get why it's an enterprise feature (since it essentially segments Nomad into per-team resource pools) but I'd still like it.

Other than that, I have very few drawbacks about using Nomad. The BSL/IBM stuff coming up is the biggest thing, but I think I've got a good amount of time before post-acquisition shenanigans would make me want to switch.

+++
title = "first light on HTTP"
description = "getting an example service running and accessible from the new Kubernetes cluster"
date = 2024-02-14

[extra]
project = "thing-a-month (meta)"
+++


Over the past few days I've been working on getting Kubernetes serving apps. As of this morning I have a sample web app (the [Kubernetes guestbook example](https://github.com/kubernetes/examples/tree/master/guestbook), minus Redis) running on my cluster, frontend by a load balancer, and with a certificate provisioned by Let's Encrypt to communicate with CloudFlare, who terminate SSL from the browser with their own cert.

<!-- more -->

I'm not going to write a blow-by-blow, but here's how a deployment ends up being exposed:

- Argo CD creates all the application manifests that it sees in a Git repository. (All the cluster components are managed this way, actually, which simplifies things. No Helm server, very few manually-applied manifests.) This gets us the service, any deployments, containers, etc. But the most important thing for this is the ingress!
- The app's ingress specifies that it wants to use the cluster Nginx ingress controller, which is fronted by a load balancer. The controller picks up the ingress, adds an Nginx config for it with host-based routing, and reloads.
- The app's ingress has a `external-dns.alpha.kubernetes.io/hostname` on it, which `external-dns` picks up once the ingress controller adds the app's accessible IP and associates with an A record in CloudFlare.
- The app's ingress also has a TLS config and a `cert-manager.io/cluster-issuer` annotation, which `cert-manager` picks up and uses to request a Let's Encrypt certificate with a DNS-based challenge.

After all those things happen, the app ends up running in the cluster and accessible to the public. When you request the specified host in the browser, CloudFront terminates TLS with their own certificate, then establish a connection with the Let's Encrypt certificate to the load balancer, which sends the traffic to the Nginx router, which talks to the container directly.

That's four hops, but some quick tests suggest that my response time is acceptable: looks like I've got a 50th percentile response time of 132ms, going up to 239ms at the 95th percentile under a load of about 30 requests per second. If I end up needing to optimize that, I could use a loadbalancer service instead of an ingress with the nginx ingress controller, but I think we'll be OK for now.

Not bad for like 15 hours of work!

Anyway, the next step in my prep will be exposing the Argo CD control plane safely. I've just been port forwarding it for now, which is fine, but I want to be able to send it webhooks to refresh so that it can be properly integrated with my Git server. That'll probably mean setting up Keycloak to act as an OIDC provider and then using that to provision a Tailscale network to keep everything connected. After that, I'll set up Argo workflows to build container images, and then I'll be in a place to start moving more services over. I anticipate that might take the rest of the month, leaving me in a good place to build the first "real" thing-a-month in March.

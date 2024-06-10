+++
title = "Kubernetes whoops"
date = 2024-06-10
+++

Welp, I accidentally deleted my Kubernetes cluster. I was messing around with Hetzner Cloud and Nomad trying to figure out if they'd be a good fit for what I'm doing and ran a `terraform delete` thinking it would just affect my Hetzner machines. Turns out there's a good reason that the `delete` subcommand is disabled by default in Terraform Cloud.

It took me a bit to come back, but this blog and all my sites are now running on Nomad. I'm pretty happy with it. May switch back eventually (it's easy because everything is static and containerized) but not immediately.

As a result, no progress on tinyping these past couple of weeks. 😅

<!-- more -->

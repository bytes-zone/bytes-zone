+++
title = "moving Kubernetes to New Jersey"
description = "finding problems, moving to a different DC to solve them"
date = 2024-02-15

[extra]
project = "thing-a-month (meta)"
+++

So this morning was shaving yaks. (I mean, what infrastructure project isn’t?) I got up thinking I’d spend a couple hours before work setting up Keycloak, but then I realized that it needs a Postgres database for a proper setup, so I comparison shopped Postgres operators. But in testing out my choice, I realized that the region I deployed the cluster into doesn’t have support for NVMe drives. No good for databases!

<!-- more -->

So I ended up tearing down the cluster and moving everything to a different region (New Jersey instead of Chicago.) I was very pleased that the gitops stuff really shone here. I only needed to inject a few secrets manually and everything else came back online by itself.

This would have been much harder if I had to think about uptime or data migration, so I’m glad I found out about the problem early!

+++
title = "running this blog on Kubernetes"
description = "PR-based workflow for the win"
date = 2024-02-23

[extra]
project = "thing-a-month (meta)"
+++

This week has been wild but I've got an update: I'm now That Person who has a static site blog running on a Kubernetes cluster. 😆

The workflow for publishing a new post is now:

1. Write the post
2. Put it in a PR
3. Merge the PR when checks pass

<!-- more -->

Everything else is automated. Once the PR merges, GitHub Actions builds the container with nixbuild.net, then pushes it to a container registry and updates the manifests file that Argo CD is listening to. Once Argo sees that, it updates the containers running in the cluster.

It's quite a rube goldberg machine, but I'm happy with it. Now to get the rest of the little services I have running under bytes.zone ported!

+++
title = "getting on the CI train"
description = "which CI solution should I use?"
date = 2024-02-19

[extra]
project = "thing-a-month (meta)"
+++

If I’m going to be shipping apps by the end of the month, I’d better get CI set up. I’ve been looking around at different options and found:

<!-- more -->

- Argo Workflows. Probably a taste that goes great with Argo CD, but I’d like to source CI steps from the repos and this seems difficult.
- Tekton: similar.
- Woodpecker: an offshoot of Drone, looks nice, seems to do what I want, but I can’t get the Helm chart working.
- Agola: smaller, maybe newer. Does the normal CI stuff, plus you can define your config in jsonnet. Kind of cool. I’d like to be able to pull in editable build steps though.

Basically I feel these options are either too complex or too simple or I can’t make them run. I bet if I redid how I’m setting up apps in Argo CD, I could get Woodpecker working. May have to shave that yak!

Right now the plan is to try a little longer (maybe today and Tuesday) to get Woodpecker working, and to bail and use Agola if I can't.

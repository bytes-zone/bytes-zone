+++
title = "seeing the forest through the trees"
date = 2024-03-15

[extra]
project = "thing-a-month (awareness)"
+++

I’ve been pretty heads down trying to get the first version of tinyping done this week. Here are the highlights:

<!-- more -->

1. Automerge is very cool, and it seems like it might even be able to do the encrypted syncing that I want. Data migrations are really tricky though, though.
2. I’m using Elm for this, since I’m super familiar with it, but the way I’m setting up the app right now means duplicating responsibility for data storage. Not great.
3. The hardest part has been figuring out how to schedule pings according to the right distribution when there is no central authority. I _think_ I have a solution though: using the last ping’s timestamp as a random seed should allow all clients to converge on the same sequence of pings. (Assuming the lambda value does not change, anyway!)

Despite the difficulties, I’m starting to see the bigger picture of how the app will work. That feels pretty encouraging!

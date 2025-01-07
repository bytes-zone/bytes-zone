+++
title = "early thoughts on using beeps"
date = 2025-01-07

[extra]
project = "Local-First From Scratch"
+++

I've been using the TUI version of the book software for a couple days, and have some observations!

First off, here's how it looks:

![a TUI for tagging pings running in a terminal with a blue background. The interface is two columns: one for ping times, and one for tags. Several tags are filled in, mostly with "sleep."](/images/beeps-0.3.0.png)

<!-- more -->

Unlike my previous attempts at making this software, I can see and edit the whole database. I knew that would be helpful, but it's way more helpful than I thought! For example, I no longer have to guess as much at what I previously tagged something. I can also go back and adjust without editing the file directly!

I'm also finding that my memory of precisely what I'm doing can get spotty quickly. For example, I got a notification about a ping this morning and thought "oh, I'll tag that in a minute. It's easy; I'm doing `X`!" Ten minutes later, I went back and couldn't for the life of me remember what `X` had been. I know it was something related to journaling, but not the exact details.

I guess that's part of the point, though: removing the ability to gloss over time I spent unwisely is a major part of why I wanted this system to exist in the first place!

As I've added features to this TUI, though, it's becoming less and less suited as the subject of a book that's not _only_ about making TUIs in Rust. I'm almost at the point of wanting to drop it for the book and make some simpler entry-only interface instead… problem is, I didn't find the entry-only interface was very nice to use at all! Since part of this book is making good choices for product design like that, I don't really want to go back to that.

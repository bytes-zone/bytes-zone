+++
title = "On *How to Take Smart Notes*"
date = 2021-01-01
draft = true
+++

I recently finished [How to Take Smart Notes](https://takesmartnotes.com) by Sönke Ahrens.
The book manages to give something as ordinary as note-taking a fairly lively treatment.
Although it could have been shorter, I think it's worth reading!
But really, the sample ([available on the author's site](https://takesmartnotes.com)) has enough to get you started.
If you're at all interested in the topic, or the ideas in this post, it's worth your time.

Now, just to set expectations about this post… this is going to be my take on the ideas in the book, rather than a review of the text *per se*.
This method of note-taking seems attract introductory posts the way Haskell attracts monad tutorials.
 That is to say: they're trendy, but a bit obvious, and pretty boring if that's the only thing you have to say about the subject.
Even so, I've had some wonderful results using this method to learn more about datalog (which I plan to post more about soon) so I think it's worth sharing!
Hopefully I can go a little deeper into the important ideas here than other introductions I've read.

Finally, as a brief housekeeping note before we really get into this, numbers in parentheses roughly correspond to page numbers in the print edition of *How to Take Smart Notes*.
I say *roughly* because I read the book in the Kindle desktop client and so going to the next page sometimes meant jumping 3 or 4 "real pages."
If you're trying to track down a reference and can't find it, please let me know; I'd be happy to help.

## Learning Requires Effort

If there's a single biggest lesson to be learned from *How to Take Smart Notes*, it's that **learning requires effort**.
In other words, the person who puts in the effort to learn something is the one who learns it. (85)
So if you want to learn—and publish papers, the book's goal—you need to put in the effort.

But we need to be more specific: if effort is required to learn, what kind of effort?
In this context, it means elaboration: taking what you're learning and working to relate it to facts and arguments you already know.

So with that definition, how do we elaborate?
Well, that's easy!
We just, uh… take smart notes.
That's the whole rest of the book!

## The Implementation

The framework you take notes in here is a *zettelkasten*—German for "slip-box".
The translation is extremely literal here: in the physical form, it's a box for storing slips of paper.
The concept originated from a influential and prolific sociologist named [Niklas Luhmann](https://en.wikipedia.org/wiki/Niklas_Luhmann), who amassed something like 90,000 of these notes over his career.

The note-taking process is iterative and fairly simple.
First, when you're reading something you intend to learn from, you take notes on it.
There's something of an art to this: you want to get the gist of what you're reading, rather than copying exact quotes (in fact, you want to avoid copying as much as possible!)
Ahrens calls this "translating"—using different words but keeping as true to the original meaning as possible. (17)
These notes are called "literature notes" and you store them with your system of references (in a separate box, physically, or in a program like Zotero.)
Take as many literature notes as you need—you're likely to need more when you're getting started on a topic, for example, and fewer once you know the basics.

On a regular basis, you reflect on your recent literature notes, along with recent observations and thoughts you've captured elsewhere, and enter your reflections into the slip-box as "permanent notes."
You follow a few simple guidelines when creating new notes: first, these notes should be written in full sentences with proper citations, as if for publication.
Second, and probably more importantly, you get **one idea per note**. 

One idea per note is actually crucial here because of the next step: linking your new permanent note together with the things that are already in your slip-box to form a web of knowledge.
Ahrens calls this a "latticework of ideas" (54) which I also like a lot.
You want a mix of links: some from the new note to existing notes, and some from existing notes to the new one.
However, you have to have the mindset of an author rather than an archivist here.
That is, try to think about the context in which you'd like to rediscover your new note rather than what categories or hierarchies it belongs to. (109)
You also want to make sure you're not linking mindlessly: your links should always create context so you avoid creating a situation where you follow the link just to see why you might have made it in the first place.
("See also" and similar are the smells to avoid here, and [some folks avoid automatic backlinks as well](https://zettelkasten.de/posts/backlinks-are-bad-links/).)

After you link up a permanent note, that's pretty much it for the iterative process.
Add the next note, and the next, and the next, and build up a big ol' web of knowledge.

## What You Gain

If you think this looks like a lot of work, you're right.
It's taken me significantly more time to read the datalog papers I'm currently working through using this method, but it's been worth it: I'm understanding concepts correctly on the first pass more often, which means not having to re-read nearly as much, and the implementations I'm building are more solid as a result.

That said, if learning requires effort, there are no shortcuts to understanding.
I might feel like my datalog learning is taking longer, but I bet I'm actually saving time using this method, and I'm certainly having a lot more fun—it makes me feel really smart when I understand something enough to relate it to the things I already know.
For me, that means it's more sustainable as well: if I enjoy the work of learning something, I'm more likely to stick with it.

There are more benefits than just "it's fun", though: building a web of knowledge this way means that you're automatically citing well and backing up your ideas with facts.
When it comes time to publish (whether it's a blog post like this one, an academic paper, or encoding the ideas in software) you have a wealth of information to draw on. (132)

Writing for yourself also has well-documented benefits (my colleague Tessa Kelly frequently recommends [Peter Elbow](https://zettelkasten.de/posts/backlinks-are-bad-links/).)
It's true in the slip-box as well!
Getting your ideas down in black and white has a way of making you think clearly about them. (93)
Is your thinking clear enough to explain to someone else, or are you at the hand-waving stage of understanding?

The back two thirds of the book is full of more benefits of writing like these.
I'm not going to list all of them here, but some claims I found compelling:

- The constrained form (one idea per note) enables better thinking and creativity. (129)
- This process provides a fast feedback loop so you'll know if your notes are high-enough quality well before you need to use them to write. (54)
- When you have a well-formed latticework of ideas, you can look for clusters around specific notes to get ideas for writing instead of having to brainstorm from a standstill. (46, 132)

## That's All, Folks!

I don't have an advanced academic background, so reading papers is sometimes pretty difficult for me.
I keep at it, because I've seen benefits to doing so, but it can be pretty annoying!
This technique has made exploring datalog a lot easier for me.
If you find yourself in a similar situation, the ideas here could maybe be useful for you too.
Even though I'm somewhat late to the party with this post, hopefully it's another data point of "yeah, this is a really cool idea!" that convinces someone to give it a shot.
If that's you, I hope you find success here!

Some links:

- Official site, including a lengthy sample: [How to Take Smart Notes](https://takesmartnotes.com)

- [zettelkasten.de](https://zettelkasten.de/), where Sascha Fast and Christian Tietze publish a lot about this method.
  I've found their posts a helpful resource in getting into the right mindset to be successful here.
  They also make their own (Mac-only) note-taking software called [The Archive](https://zettelkasten.de/the-archive/).

- [Obsidian](https://obsidian.md/), the software I use to manage my notes, and [Zotero](https://www.zotero.org/), the software I use to manage my references.
  But don't forget: learning requires effort!
  That raises an interesting implication for someone like me who loves tools: software is not going to make you learn.
  A prettier, more well-organized, faster program is not going to make learning take any less effort.
  A specialty tool like Obsidian or Roam will work more-or-less as well as something simpler like a plain directory full of notes or a literal box full of literal slips of paper.
  Don't get me wrong, I'm happy using tools that help make my life easier, but I don't think they're necessary to get started.
  If I had to learn this technique again from scratch I would focus far less on tooling.

- This topic has been catnip for the tech news aggregators this year.
  If you want many, many more introductory posts, search for "zettelkasten" on Hacker News or Lobsters.

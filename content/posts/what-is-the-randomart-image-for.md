+++
title = "what is the randomart image for?"
date = 2023-02-20

[extra]
featured = true
+++

When you generate an SSH key (like I did when looking at [signing commits with SSH keys](@/posts/signing-commits-with-SSH-keys.md)), you get a “randomart image” from `ssh-keygen`. These things:

```
+--[ED25519 256]--+
|..o              |
|.+               |
| .E              |
|.. .     +o o    |
| .+.    S+=+     |
| .... o.*+o*     |
|     oo*.o+oo.   |
|     o o=+.oo+   |
|     .o.oo==B++  |
+----[SHA256]-----+
```

That looks nice, and I appreciate art in my terminal, but what is it for? So, let's see… first, I looked in `man ssh-keygen`, because that's the context in which I see these, but it doesn't have any hits for `randomart` or `art`. But on a hunch I tried `man ssh`, and that page has some info! Here's what it says:

> Because of the difficulty of comparing host keys just by looking at fingerprint strings, there is also support to compare host keys visually, using random art.  By setting the VisualHostKey option to “yes”, a small ASCII graphic gets displayed on every login to a server, no matter if the session itself is interactive or not.  By learning the pattern a known server produces, a user can easily find out that the host key has changed when a completely different pattern is displayed.  Because these patterns are not unambiguous however, a pattern that looks similar to the pattern remembered only gives a good probability that the host key is the same, not guaranteed proof.
> 
> To get a listing of the fingerprints along with their random art for all known hosts, the following command line can be used:
>
>     $ ssh-keygen -lv -f ~/.ssh/known_hosts

Ok, that makes a lot of sense! There have been plenty of times when I've logged on to a new server, and it asks me if I want to trust key such-and-such. I mostly just say “yeah, that's fine” without paying attention, so I see how the art could help me remember what's right!

If I run the command given in the manual page, I get this for GitHub:

```
256 SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU github.com (ED25519)
+--[ED25519 256]--+
|                 |
|     .           |
|      o          |
|     o o o  .    |
|     .B S oo     |
|     =+^ =...    |
|    oo#o@.o.     |
|    E+.&.=o      |
|    ooo.X=.      |
+----[SHA256]-----+
2048 SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8 github.com (RSA)
+---[RSA 2048]----+
| =+o...+=o..     |
|o++... *o .      |
|*.o.  *o.        |
|oo.  ..o.= .     |
|.+o. .. S =      |
|*=+ .  o = .     |
|OE .  . o        |
| o     .         |
|                 |
+----[SHA256]-----+
256 SHA256:p2QAMXNIC1TJYWeIOttrVc98/R1BUFWu3/LiyKgUfQM github.com (ECDSA)
+---[ECDSA 256]---+
| .o=X*+      .o.=|
|  .o=O         o |
| .  . .   E   . .|
|o     .. . .   o |
| +   . +S o.o . .|
|. . .  o++.... o.|
|   o    o.   ...+|
|  o    .   o .oo.|
| .      ... o....|
+----[SHA256]-----+
```

The manual also mentioned that you can set `VisualHostKey` to `yes` in your SSH client config to get that information every time. If I do that, I can see that my SSH client is using the ED25519 key:

```bash
$ ssh git@github.com
Host key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU
+--[ED25519 256]--+
|                 |
|     .           |
|      o          |
|     o o o  .    |
|     .B S oo     |
|     =+^ =...    |
|    oo#o@.o.     |
|    E+.&.=o      |
|    ooo.X=.      |
+----[SHA256]-----+
PTY allocation request failed on channel 0
Hi BrianHicks! You've successfully authenticated, but GitHub does not provide shell access.
Connection to github.com closed.
```

It shows a different image when I `git push` to my [dotfiles repo](https://git.bytes.zone/brian/dotfiles.nix), which also makes sense—they're different servers, so they have different keys. I left this on for a while and see if I started to be able to recognize the randomart images in the way the manual implies I'd be able to, and it turns out it worked! For example, I've started seeing the GitHub fingerprint (above) as something like the Statue of Liberty if it were a cat (don't ask why; that's just how my brain sees it), and the signature for `git.bytes.zone` (below) as the Vagrant logo. How interesting!

```
+---[RSA 2048]----+
|.+=+.         **o|
|...+ .       *.o+|
|o + o     . = =. |
| +   . + . E . + |
|  o  .+ S =   + .|
|   o .o+ . o o o |
|    ..o.+   o .  |
|     o...    .   |
|      oo         |
+----[SHA256]-----+
```

All in all, I think I'd recommend doing this. Even if the keys never change, it's pleasing to see the art show up in your terminal. And if they do, I now have one more tool to know if something's wrong.

One final note: I mentioned this in the [Recurse Center](https://www.recurse.com/) Zulip and someone mentioned that they had recently come across [the paper that describes the algorithm for making these](http://www.dirk-loss.de/sshvis/drunken_bishop.pdf). Now we know!

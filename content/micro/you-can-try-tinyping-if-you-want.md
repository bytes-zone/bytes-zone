+++
title = "you can try tinyping, if you want"
date = 2024-09-23
+++

Despite not talking about it much, I'm continuing to work on tinyping. In the spirit of working with the garage door up, you can try an _extremely early version_ at [app.tinyping.net](https://app.tinyping.net). It mostly works, though! Pings are scheduled and stored appropriately, and you can edit tags for them. It also follows the Automerge project's advice on how to best structure documents to avoid the main document growing and growing forever (it stores pings in journal documents, one per month.)

If you decide to try that, be aware that it doesn't gracefully handle schema changes at all, in cases where the data storage format has to change. I'm mostly just calling `localStorage.clear()` whenever in the console whenever I need. Don't put anything valuable in there; it'll get eaten.

<!-- more -->

Next step there is to make the UI actually nice. I don't think that will be awful to do, although the list of pings can feel a little overwhelming if you haven't filled them in for a while.

Oh, and if you're reading this and have a better idea for a name, please get in touch. I wanted to get the .com version of the name, but the owners of that domain want "in the 5 figures of GBP" and I'm not gonna do that for a side project.

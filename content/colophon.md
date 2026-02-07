+++
title = "Colophon"
template = "post.html"
+++

## Source and Licensing

The source of this site is available for inspection at [git.bytes.zone/bytes.zone/bytes.zone](https://git.bytes.zone/bytes.zone/bytes.zone).
The contents are licensed [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) as it says in the footer of every page.

I haven't put any thought into what license the code that builds the site should be released under, but I'm not gonna track you down or anything if you use it as prior art for your own site.
If this matters to you, please [get in touch](mailto:brian@brianthicks.com) and I'll figure it out and add a proper `LICENSE` file where it needs to go.

## This Page is Designed to Last... ish

I love [This Page is Designed to Last](https://jeffhuang.com/designed_to_last/), so this site is built with it in mind.
I haven't stuck to it 100%, though.
Let's look at the principles:

1. **Return to vanilla HTML/CSS.**
   Yep!
   This is a completely static site.
   The HTML is templated using [Zola](https://www.getzola.org/) and the styles are plain CSS based on [Better Motherfucking Website](http://bettermotherfuckingwebsite.com/) (or one of the derivatives of [Motherfucking Website](https://motherfuckingwebsite.com/) anyway... I don't 100% remember which, just that it had a very permissive license.)

2. **Don't minimize that HTML.**
   I'm... minimizing the HTML.
   CSS and JS too.
   Sorry, I guess?
   Open the dev tools in your browser and everything will get automatically prettified.
   Browsers are really good about this now!
   It's _fine_!

3. **Prefer one page over several.**
   I'm not doing this, but I feel like the pain behind this principle is "it's hard to maintain multiple pages" buuuuut… I'm using a static site generator, most of the content is in markdown, and _all_ of it is version-controlled.
   Making a change is trivial, and all the dependencies are versioned with [Nix](https://nixos.org/).
   I've been using this kind of setup for years now, and have had very few issues like he mentions.

4. **End all forms of hotlinking.**
   With the exception of YouTube embeds in [the talks section](@/talks/_index.md), this site doesn't load any resources that aren't hosted somewhere on bytes.zone.
   Success!

5. **Stick with the 13 web safe fonts +2.**
   `font: 1.2em/1.62 san-serif` for the body.
   Looks fine.
   Done.
   I used to do sans-serif for the headers too, but loading a single WOFF2 gives it a nice designed look without being too heavy.
   I'm hosting my own fonts; see above about hotlinking.

6. **Obsessively compress your images.**
   The site doesn't use any images for layout.
   In fact, the only images outside of page content are for the favicons and they're compressed with `pngcrush`'s brute-force settings.
   (Although, check out [the SVG version of the favicon](/icons/icon.svg)... it uses a CSS media query to change based on the system dark/light mode.
   CSS can do some pretty wild things now!)

7. **Eliminate the broken URL risk.**
   This is the only item where I don't feel like I'm at least satisfying the spirit of the rule.
   I don't have an external link checker of any kind.
   That said, this site is hosted on a VM which also serves as my personal git host ([git.bytes.zone](https://git.bytes.zone)) so I'd notice pretty quickly if it went down!
   I also periodically check for 404s in the Nginx access log so I know if I need to add a redirect or improve the missing page stuff.

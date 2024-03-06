+++
title = "app architecture"
date = 2024-03-06T12:44:04-06:00

[extra]
project = "thing-a-month (awareness)"
+++

So, a little news to start: I decided on a name for this project and bought a domain. [tinyping.net](https://tinyping.net) is now receiving traffic (but just linking back to bytes.zone for the moment.) But today I want to write about the ideal architecture!

Part of the thing-a-month project is to pare down my ideas to the minimum that I can actually achieve in a month. I thought that was going to be easy on this project, but then I got to thinking about data governance and privacy balanced with long-term sustainability as a service. Let's think about how someone might use this app:

<!-- more -->

0. They sign up, get whatever app installed and authed, whatever.
1. They start answering pings
2. They look at reports on how they're using their time
3. Repeat, hypothetically forever (but actually who knows how long)

Questions about privacy and sustainability come up before the beginning, and in between each of those steps. For example:

- What does sign up look like? Is it a website, an app, or some combination?
- Where does ping data live? Who gets to read it? How is sensitive data (how people are spending their time) protected?
- Who bears the cost for a constantly (but slowly) growing data set?

Let's work out a couple scenarios. First, what's the answer if this is a purely-local app? Say it's on your phone (just to make it available everywhere, since people keep their phones close.) The answers to these questions would be:

- **What does sign up look like?** Purchasing an app from an app store.
- **Where does ping data live?** Local storage, or perhaps in the OS' persistent storage (e.g. iCloud)
- **Who gets to read ping data?** Only the person who enters it.
- **How is sensitive data protected?** App sandboxes, I guess? Could also be encrypted at rest if that's something we're interested in. Only has to be readable when the app is open.
- **Who bears the cost for the storing the data set?** The person who owns the device it's stored on.

That doesn't seem so bad, but this is where I hit some scope creep. I'd like this data to sync between my phone and computers somehow. I'm on my work laptop for most of the workday, on my phone in the evenings, and on my personal laptop when I'm doing things like blogging or working on projects like this. I want to track all that time!

One way to do this might be to consider making this a web app instead of a local-only app. Then the answers might look like this:

- **What does sign up look like?** Some SaaS signup tactic. Username/password, OAuth, magic email links, passkeys, whatever.
- **Where does ping data live?** In a database that I control.
- **Who gets to read ping data?** The person who enters it, plus hypothetically me the system administrator, plus hypothetically other people due to bugs or misconfigurations.
- **How is sensitive data protected?** "best practices." I kid, but it's at least a little earnest… making sure data in the database is encrypted at rest, controlling access, things like that.
- **Who bears the cost for the storing the data set?** I do! And because of that my costs go up and one-time purchases become less sustainable (since I'd have a constant stream of cost paired with an intermittent stream of revenue.)
- **New question: will this work on a plane?** Not without buying wifi!

That seems worse on first read. It does have some clear benefits, though: there aren't nearly as many gatekeepers for web apps, and I wouldn't have to pay platform fees on sales (other than, say, Stripe's normal fees.) But I have a hard time thinking this is the *best* way forward.

But what about a hybrid approach? Local-first software is looking pretty good these days. What if the client stored its own data and then could sync with a server to get the data everywhere? Seems like that could work alright. Then what if the tags were encrypted somehow and could only be decrypted by the user on their devices? Then…

- **What does sign up look like?** Still a SaaS signup tactic.
- **Where does ping data live?** In a database that I control.
- **Who gets to read ping data?** The person who enters it, plus hypothetically someone in the far future who can break the encryption.
- **How is sensitive data protected?** The data is encrypted everywhere but where the app is actually running.
- **Who bears the cost for the storing the data set?** Joint responsibility. Each client would be responsible for hosting all of its data, plus I'd store a copy too to facilitate syncing.
- **Will this work on a plane?** Sure would!

That makes me think that the way to get started here might be a local-first PWA. That'd allow you to get pings immediately, and then later be able to sync them with a server when that exists. That makes signup a little annoying (since all the data lives on your device anyway) so maybe the first version of this could just be an open thing? Or maybe that's how I'd make a trial available… use this for a while on your own device, but if you want backups and sync then there's a fee (seems like this works fine for Obsidian!)

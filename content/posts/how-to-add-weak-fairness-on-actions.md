+++
title = "how to add weak fairness on actions"
date = 2023-03-06
description = "ensure an action always fires if it's able"

[extra]
project = "learning Alloy"
+++

In [Alloy](@/projects/learning-alloy.md), you can add weak fairness to actions (that is, ensure that they'll always eventually fire if they're able) by saying:

```alloy
(eventually always p) implies (always eventually q)
```

In English, this means: "if `p` is eventually true, then `q` will eventually be true at all points afterwards." In other words, `p` is the condition under which `q` can happen.

Note that you should be careful about existential (`some`) vs universal (`all`) quantifiers with this kind of statement. For example:

```alloy
all t: Thing {
  (eventually always enabled[t]) implies (always eventually do[t])
}
```

Saying `all` here means that every time the condition `enabled` is true the action `do` is eventually taken. If this said `some t: Thing` instead, that would mean that this condition would only be true some of the time.

Source: [Alcino Cunha's answer to my question about this on the Alloy discourse instance](https://alloytools.discourse.group/t/how-do-you-say-once-this-is-true-its-always-true/294)

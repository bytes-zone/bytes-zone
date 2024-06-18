+++
title = "once p is true, it's always true"
date = 2023-08-28
description = "temporal properties in Alloy"

[extra]
project = "learning Alloy"
+++

In [Alloy](@/projects/learning-alloy.md), to say "once this is true, it's always true", you say:

```alloy
always (p implies always p)
```

This is true because `always` means "in all states starting from this one." So, the outer "always" means that the condition is always true starting from the initial time. Once `p` is true, the `implies` says that it will always remain true.

If you did just `p implies always p` without the wrapper, that would be saying "if `p` is true _at the initial time_ then `p` will always be true."

Source: [Alcino Cunha's answer to my question about this on the Alloy discourse instance](https://alloytools.discourse.group/t/how-do-you-say-once-this-is-true-its-always-true/294)

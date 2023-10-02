+++
title = "Modeling in-flight requests in Alloy"
date = 2023-10-02
description = "Messages on the network can be dropped or delivered out of order. How do we model that?"

[extra]
project = "learning Alloy"
+++

In [Alloy](@/projects/learning-alloy.md), sometimes I want to model clients and servers (or any relationship where two entities are talking.) With network stuff, it's always possible for a message to not be received, or to be received twice, or out of order, et cetera. I'd like to model that!

Because I just want to learn the basics here, I'll try to keep this as simple as possible. So instead of requests and responses or any other protocol, we'll stick to just messages:

```alloy
var sig Message {}

var sig Delivered in Message {}
```

In English, "We have a set of `Message`s, some of which have been delivered and some of which haven't. Both sets can change over time."

In addition to the things we define in a model like this, we have to think about the world they live in. Here I'm imagining that these messages form a stream going from some node A to another node B—no return messages, though, only one way!

Next we'll take care of a little boilerplate: how the system starts (with no messages) and a do-nothing message so our traces can run forever.

```alloy
pred init {
  no Message
}

pred do_nothing {
  Message' = Message
  Delivered' = Delivered
}
```

(`Message'` means "`Message` in the next step." If this is unfamiliar to you, here's [a previous post where I went into more detail about how time works in Alloy](@/posts/modeling-git-internals-in-alloy-part-3-operations-on-blobs-and-trees.md).)

Next we want to send a message:

```alloy
pred send_message {
  // action: we want exactly `one` new message
  // without making any other changes to `Messages`
  one m: Message' - Message {
    Message' = Message + m
  }

  // frame (holding everything else still)
  Delivered' = Delivered
}
```

We can do something similar to model the request being received:

```alloy
pred receive_message {
  // action: mark exactly one message as delivered.
  one m: Message - Delivered {
    Delivered' = Delivered + m
  }

  // frame
  Message' = Message
}
```

Note that this can't be true (that is, can't happen) if we don't have at least one message in `Message - Delivered`, which can read as "The set of `Message` minus the set of `Delivered`."

Finally, we set up a state machine telling Alloy when each predicate can be true over time:

```alloy
fact traces {
  init
  always {
    do_nothing
    or send_message
    or receive_message
  }
}
```

That works pretty well! If you step through the traces here, you can get instances where messages are delivered out of order, never delivered, etc. We can't get duplicate messages in this model, but that wouldn't be the worst thing in the world to add!

Since this is demonstrating the lack of safety on the network, we can't add a check like "all messages are eventually delivered", but we can make assertions that the individual actions are doing what they say they will. For example, we know that if `send_message` is true then we will always have exactly one new message and no changes to `Delivered`:

```alloy
check SendMessageNextStepHasExactlyOneNewMessage {
  always send_message implies one Message' - Message
}

check SendMessageDoesNotChangeDelivered {
  always send_message implies Delivered' = Delivered
}
```

I debated including `Delivered' = Delivered` above, though… it's a property I care about, but it's also a frame condition. If you squint and think of this like a unit test, it's just testing that the implementation is what I expect. But on the other hand, if Alloy allows express my intent this way, where's the problem?

We can make similar assertions about `receive_message`:

```alloy
check ReceiveMessageOnlyMarksMessagesAsDelivered {
  always receive_message implies one Delivered' - Delivered
}

check ReceiveMessageDoesNotChangeMessages {
  always receive_message implies Message' = Message
}
```

(If you're typing this in by hand and want to go back to just exploring instances, don't forget you can add a `run {}` block at the end to generate something more explorable!)

So with that, we have a fairly nice skeleton to add more network operations onto. For example, imagine that these messages mutated some state. We can now make sure that the state changes are correct in the face of out-of-order or dropped messages. Give it a try and see if you can extend the model to do that!

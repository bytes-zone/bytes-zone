+++
title = "sourcing secrets from 1Password"
description = "avoid committing secrets!"
date = 2024-02-27

[extra]
project = "thing-a-month (meta)"
+++

I've been [setting up a personal Kubernetes cluster](@/projects/thing-a-month-meta.md) recently.
The whole thing is set up with [Argo CD](https://argoproj.github.io/), which basically means that I make changes to the cluster by committing to a git repo and pushing.
Really handy, especially when I make a mistake and need to clean something up or revert.

One problem with this, though, is that it's probably not a great idea to commit secrets to the repository.
I don't want things like passwords and API keys sitting there in clear text on my laptop or on the remote.

If I were setting up a cluster that other people were going to operate, I'd probably set up something like [Vault](https://www.vaultproject.io/), but since it's just me I can get away with creating the secrets by hand.
That said, I still don't want to leave them on disk unencrypted!

Enter the `opw` CLI for [1Password](https://1password.com/). <!-- more -->
It can output secret data as JSON, and I can use [`jq`](https://jqlang.github.io/jq/) to transform that into Kubernetes secret objects, which I can pipe into `kubectl` to apply in the cluster.

Let's take a simple example: an image pull secret.
I have the secret stored in 1Password under a specific vault.
If I run `op item get --vault k8s "image pull secret"`, I'll get something like the following:

```yaml
ID:          y63hsk7qy5osug5n2qupwhtz3e
Title:       image pull secret
Vault:       k8s (2qaqjigknr3htch273i2mho5vi)
Created:     2 weeks ago
Updated:     2 weeks ago by Brian Hicks
Favorite:    false
Version:     1
Category:    LOGIN
Fields:
  password:    password-goes-here
  username:    username-goes-here
```

I can also ask for it in JSON format by adding `--format json` to the end:

```json
{
  "id": "y63hsk7qy5osug5n2qupwhtz3e",
  "title": "image pull secreet",
  "version": 1,
  "vault": {
    "id": "2qaqjigknr3htch273i2mho5vi",
    "name": "k8s"
  },
  "category": "LOGIN",
  "last_edited_by": "B76OR7I6DNENPAQOQFFO6FKQOM",
  "created_at": "2024-02-12T18:37:38Z",
  "updated_at": "2024-02-12T18:37:38Z",
  "additional_information": "brian@brianthicks.com",
  "fields": [
    {
      "id": "password",
      "type": "CONCEALED",
      "purpose": "PASSWORD",
      "label": "password",
      "value": "password-goes-here",
      "reference": "op://k8s/image pull secret/password",
      "password_details": {
        "strength": "FANTASTIC"
      }
    },
    {
      "id": "username",
      "type": "STRING",
      "purpose": "USERNAME",
      "label": "username",
      "value": "username-goes-here",
      "reference": "op://k8s/image pull secret/username"
    },
    {
      "id": "notesPlain",
      "type": "STRING",
      "purpose": "NOTES",
      "label": "notesPlain",
      "reference": "op://k8s/image pull secret/notesPlain"
    }
  ]
}
```

We can then pipe that into the following jq program to get an object indexed by the field names:

```jq
.fields | map({ key: .label, value: .value }) | from_entries
```

That produces this:

```json
{
  "password": "password-goes-here",
  "username": "username-goes-here",
  "notesPlain": null
}
```

And we can add onto that jq program to produce some JSON in the shape of a Kubernetes secret:

```jq
.fields | map({ key: .label, value: .value }) | from_entries | {
    apiVersion: "v1",
    kind: "Secret",
    type: "kubernetes.io/dockerconfigjson",
    metadata: {
        name: "ghcr-image-pull-secret",
    },
    data: {
        ".dockerconfigjson": {
            auths: {
                "image-host.io": {
                    auth: "\(.username):\(.password)" | @base64
                }
            }
        } | @base64
    }
}
```

Assuming that's in `image-pull-secret.jq`, we can now load the secret into Kubernetes like so:

```sh
op item get --vault k8s "image pull secret" --format json | \
    jq -f image-pull-secret.jq | \
    kubectl apply -n whatever-namespace -f -
```

Like everything, this has some tradeoffs: the secrets are stored securely and never hit the disk, which is *great*!
But in exchange, I have to run a command manually if I want to update the secrets.
This means that if I'm creating a new app, it'll probably fail at least once.
Same if I have to move my cluster ([which I already did once](@/micro/thing-a-month-02-05.md)) and have to apply all the manifests from scratch.

So in the end, would I recommend this?
Yes, if you're in my situation!
But if you're running a cluster where other people have to operate it too, this is probably not the best approach.
It's good to know it's possible, though!

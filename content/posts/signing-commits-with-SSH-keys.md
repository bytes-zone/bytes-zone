+++
title = "signing commits with SSH keys"
date = 2023-02-06
+++

I sign all my git commits. “Why” is not super important here (but basically: I participate in some open source organizations for whom supply chain security is important.) Right now, I want to focus on nice ways to make the signatures.

To start with, [here are some GitHub docs](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits) on signing commits with different kinds of keys. I currently use GPG keys, but they're kind of annoying to manage (at least for me.) A better option for me might be to sign my commits with SSH keys. But, what are the consequences of doing that?

I'm gonna run some experiments to figure that out. To start with, I use two git forges: GitHub and [Gitea](https://gitea.io/en-us/) (although I plan to migrate to [Forgejo](https://forgejo.org/) once it's in a stable version of nixpkgs.) I want to make sure that I can get verified commits on both.

I'm _most_ interested in what happens when I revoke keys. Generally speaking, I generate one SSH key per machine I use for development. That way, no key ever has to leave the machine it was generated on. So what happens if I retire a machine, along with its key? Will all my commits turn into unsigned commits? GitHub's documentation implies that it might be fine, but I don't know.

## Testing Stuff Out

Well, then: let's try! I'm gonna create a new repo and key:

```bash
$ git init test-ssh-key-signing
Initialized empty Git repository in test-ssh-key-signing/.git/

$ cd test-ssh-key-signing

$ ssh-keygen -t ed25519 -f test-key.ed25519
Generating public/private ed25519 key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in test-key.ed25519
Your public key has been saved in test-key.ed25519.pub
The key fingerprint is:
SHA256:mevdSg3mn8+unpYYaB7+Sw2D6k4/VmViamKCEHHma0M brianhicks@sequoia.local
The key's randomart image is:
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

First, I'll make a commit that's signed with my normal GPG key (which I have set globally):

```bash
$ git commit --allow-empty -S -m "this commit has been signed with my regular GPG key"
```

Then I'll reconfigure the repo to sign using the local key and make another commit:

```bash
$ git config gpg.format ssh
$ git config user.signingKey "$(pwd)/test-key.ed25519"

$ git commit --allow-empty -S -m "this commit has been signed with the test SSH key"
```

Now I can check the signatures on the commits. Unfortunately, it looks like `git` needs some additional configuration to verify the signature with the SSH key:

```bash
$ git log --show-signature
error: gpg.ssh.allowedSignersFile needs to be configured and exist for ssh signature verification
commit 60c4afaae4bb3a2013648a26a99b994e868ee4ae (HEAD -> main)
No signature
Author: Brian Hicks <brian@brianthicks.com>
Date:   Thu Jan 19 11:02:37 2023 -0600

    this commit has been signed with the test SSH key

commit 04627098cc096584dac81c43ad70b40851880c18
gpg: Signature made Thu Jan 19 11:02:12 2023 CST
gpg:                using RSA key 66BAD9732604D23EF4A55B75C4F324B9CAAB0D50
gpg:                issuer "brian@brianthicks.com"
gpg: Good signature from "Brian Hicks <brian@brianthicks.com>" [ultimate]
Author: Brian Hicks <brian@brianthicks.com>
Date:   Thu Jan 19 11:02:12 2023 -0600

    this commit has been signed with my regular GPG key
```

Very well, let's set an allowed signers file up. I found [some instructions on GitLab to set up the allowed signers file](https://docs.gitlab.com/ee/user/project/repository/ssh_signed_commits/#verify-commits):

```bash
$ echo "$(git config --get user.email) namespaces=\"git\" $(cat test-key.ed25519.pub)" > allowed_signers
$ git config gpg.ssh.allowedSignersFile "$(pwd)/allowed_signers"
```

Now I can get both signatures verified:

```bash
$ git log --show-signature
commit 60c4afaae4bb3a2013648a26a99b994e868ee4ae (HEAD -> main)
Good "git" signature for brian@brianthicks.com with ED25519 key SHA256:mevdSg3mn8+unpYYaB7+Sw2D6k4/VmViamKCEHHma0M
Author: Brian Hicks <brian@brianthicks.com>
Date:   Thu Jan 19 11:02:37 2023 -0600

    this commit has been signed with the test SSH key

commit 04627098cc096584dac81c43ad70b40851880c18
gpg: Signature made Thu Jan 19 11:02:12 2023 CST
gpg:                using RSA key 66BAD9732604D23EF4A55B75C4F324B9CAAB0D50
gpg:                issuer "brian@brianthicks.com"
gpg: Good signature from "Brian Hicks <brian@brianthicks.com>" [ultimate]
Author: Brian Hicks <brian@brianthicks.com>
Date:   Thu Jan 19 11:02:12 2023 -0600

    this commit has been signed with my regular GPG key
```

Cool. Now let's test how forges deal with rotating these keys.

## GitHub

GitHub says that SSH key signing is less involved but lacks features, namely that an SSH signing key can't be revoked. Fair enough; there's no mechanism for that. They _don't_ say what happens when you roll keys, though, so let's try it.

First, I'll push my test repo to GitHub:

```bash
$ gh repo create --private --source . --push
✓ Created repository BrianHicks/test-ssh-key-signing on GitHub
✓ Added remote https://github.com/BrianHicks/test-ssh-key-signing.git
Enumerating objects: 3, done.
Counting objects: 100% (3/3), done.
Delta compression using up to 10 threads
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 1.25 KiB | 1.25 MiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
To https://github.com/BrianHicks/test-ssh-key-signing.git
 * [new branch]      HEAD -> main
branch 'main' set up to track 'origin/main'.
✓ Pushed commits to https://github.com/BrianHicks/test-ssh-key-signing.git
```

I haven't uploaded the new key, but I have enabled [vigilant mode](https://docs.github.com/en/authentication/managing-commit-signature-verification/displaying-verification-statuses-for-all-of-your-commits), so their web UI shows the commit as unverified:

![the GitHub UI, showing the commit history with one verified commit signed by GPG and one unverified commit signed by SSH](/images/unverified-commits-on-GitHub-in-the-test-ssh-key-signing-repo.png)

However, if I go to my settings and add the SSH key as a signing key, it shows as verified!

![the GitHub UI, showing both commits verified](/images/verified-commits-on-GitHub-in-the-test-ssh-key-signing-repo.png)

If I remove the signing key, the commit status goes back to unverified, which makes sense.

Since I uploaded this key as a signing key instead of an authentication key, it does not let me log in:

```bash
$ ssh -o "IdentitiesOnly=yes" -i test-key.ed25519 git@github.com
git@github.com: Permission denied (publickey).
```

Good! I'd be uncomfortable allowing authentication from machines with decommissioned keys, but I'm at least OK-ish with saying “the commits that I made with this are still valid forever”, as long as I can be reasonably confident that the key material is completely destroyed, so no new commits can be made. If I wanted to say "any commits with signatures after this date should not be considered verified", I could use a GPG key (but you can maybe still mess around with that, since you can change the date of a commit?)

Anyway, signing commits in this way seems like it satisfies my security requirements, so it might be possible. I still need to look at Gitea, though!

## Gitea/Forgejo

For Gitea/Forgejo, there's [some documentation by Gitea](https://docs.gitea.io/en-us/signing/). It only mentions GPG keys. I wonder if it'd “just work” for SSH-based signing, though? Let's find out!

I don't have the CLI installed for Gitea, so I created a private repo in my account and pushed to it. Afterward, the commit shows up as unverified, as expected:

![the Gitea UI, showing the commit history with one verified commit signed by GPG and one unverified commit signed by SSH](/images/unverified-commits-on-gitea-in-the-test-ssh-key-signing-repo.png)

I added the key to my account as a regular authentication key, but that didn't change anything. However, I noticed a new “Verify” button in the web UI. Once I verified my SSH key (by signing a string with some instructions provided on the page) the commit showed up as verified:

![the Gitea UI, showing both commits verified](/images/verified-commits-on-gitea-in-the-test-ssh-key-signing-repo.png)

This creates a problem, though: it doesn't look like I can accept the key for signing but not authentication. For example, if I try to authenticate to my git host with the key it lets me:

```bash
$ ssh -o "IdentitiesOnly=yes" -i test-key.ed25519 git@git.bytes.zone
PTY allocation request failed on channel 0
Hi there, brian! You've successfully authenticated with the key named brianhicks@..., but Gitea does not provide shell access.
If this is unexpected, please log in with password and setup Gitea under another user.
Connection to git.bytes.zone closed.
```

This is maybe worth asking either the Gitea or Forgejo development teams about. Of course, I could just be thinking incorrectly about the security model here: it could be the case that they don't want to allow this because you can't revoke SSH keys.

Either way, it seems like if I rotate my keys, I either have to allow authentication access to old keys forever, which I really don't want to do. Looks like I'll be sticking with my GPG key for signing commits for now!

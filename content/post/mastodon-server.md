+++
date = "2022-11-10"
title = "Setting up my own Mastodon server"
+++

In light of the recent implosion of Twitter after its takeover,
there's been an exodus of users to [Mastodon](https://joinmastodon.org/),
the distributed, open-source, social network alternative.

I have also set up an account and initially set it up on the largest server, [mastodon.social](https://mastodon.social/about),
it did, however, not take long before there were severe delays and sporadic  failed requests when using Mastodon,
which is understandable considering the massive growth the network experienced.

The delays did make me wonder if I should make use of the distributed nature of Mastodon and set up my own server,
so I did.

I had a few reasons for doing this:

* I can run my own server and, by that, help reduce the load on the public Mastodon servers,
  which most other people might not be able to do.
* I've got a server running at home that isn't doing much,
  so it could do with something to run on it.
* NixOS (which my server runs) already have a module for Mastodon available,
  which makes it much easier to configure.
* And who am I kidding? There's a certain amount of "because I can" to this!

Since it's running on a server located in my home,
I decided I wanted to have it set up behind Cloudflare,
giving me some protection against potential malicious actors.

Images and video are instead hosted in an S3 bucket, so it doesn't consume much bandwidth.

All in all, it took me a couple of evenings to get set up,
but I also got my NixOS configuration improved as part of it,
so I for instance now use [agenix](https://github.com/ryantm/agenix) for encrypting the secrets in my configuration,
rather than having it written directly in the Nix files.

For now, I am the only person with an account on my Mastodon server,
but any bots I might make would be located on it as well.
[@TaphouseWatcher](https://twitter.com/TaphouseWatcher) could do with a space in the fediverse...

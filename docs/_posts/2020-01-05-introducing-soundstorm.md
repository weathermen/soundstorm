---
layout: post
title: Introducing Soundstorm
author: tubbo
---

Welcome to the Soundstorm Engineering Blog, a place where I'll be
writing about the technical challenges that were encountered during the
course of development for Soundstorm, as well as new release
announcements for the platform. I haven't written in the blog yet,
so here's a summary of what Soundstorm does at this very moment:

- Uploads tracks and slices them into Transport Segments using `ffmpeg`
- Generates track waveforms
- The "classic" social networking features such as commenting/liking on
  tracks
- User profile management
- Federation API speaking the ActivityPub protocol (not yet tested
  between two Soundstorm instances in the wild!)

This post is mostly introductory, there will be more coming in the
future once I get some time to sit down and write them. Thanks for
checking out our little project!

## But Why?

Soundstorm was born out of the need for a more democratic streaming
service. The democratization of recorded music has largely given way to
a sort of syndicalism between the "big players" in the streaming market,
like Spotify, Apple's iTunes, and Soundcloud. Indeed, this is where most
people discover and listen to new music. The actions of these companies
tend to go against the will and needs of the music industry as a whole,
including less-than-stellar royalty fees, the difficulty in promotion on
these platforms, their tendency to keep you addicted, and of course,
annoyingly loud advertisements in between listening to songs. Not only
that, but community-driven platforms like Soundcloud and Mixcloud have
arbitrary rules surrounding long-form audio and DJ mixes, causing many
DJs to leave the platform altogether due to takedowns causing eventual
bans on their account. Soundstorm cannot be affected by this, if an
operator wishes to terminate your account, you can either run your own
server or join a different server where those rules don't apply.

Whereas a handful of radio conglomerates dominated the media of the
1990s and early 2000s, inspiring the development of P2P downloading
applications and largely preventing innovation on a mass scale, the
domination of the Web by a handful of technological conglomerates
threatens to do the same, after so much effort has been made to make
music more accessible, and make creating music and getting it out to the
masses a lot easier. To counteract this trend of centralization and
ensure the longevity of what we've created, many have chosen federated
networks (rather than going directly peer-to-peer) to implement a
network that no one entity can ever control. Soundstorm is part of this
federalization experiment, much like Mastodon or Diaspora, and hopefully
others will be into the idea.

## At What Cost?

Soundstorm can't be free. In order to serve large files such as mp3s or
wavs, one will always need to pay for some kind of object storage that
allows fast access to these files by a web application. In addition, the
web application must be able to handle traffic of this magnitude and
have enough RAM to process audio in the background. I don't expect a
*ton* of people to run their own instances, but I believe entities such
as venues, local music communities, record labels, and even online music
publications will want to run their own Soundstorm community for a few
reasons:

1. It advertises the entity in question
2. It allows for promotional capabilities far beyond the ability of any
   existing social network
3. You can access the entire Fediverse without having to duplicate posts
   across networks

Right now, <https://soundstorm.social> is the only running Soundstorm
instance, and since it hasn't been up very long, I'm not sure how much
it will actually cost to run a Soundstorm server, but much of the goals
surrounding the development of the project are to keep costs down as
much as possible.

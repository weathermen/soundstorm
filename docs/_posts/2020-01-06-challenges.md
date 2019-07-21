---
layout: post
title: Challenges of Developing a Federated Social Audio Platform
author: tubbo
---

Federated social media is nothing new. The idea that you should be able
to own your own social networking data was experimented on way back in
2008, and we're only now beginning to figure out how to make it work on
a large scale. With the new standards and level of cooperation between the
developers behind federated social networks, a lot of the basic problems
behind the practice have been solved, and we're seeing an influx of new
ideas into the space which are more interesting than a simple text
message to another user across the internet.

Soundstorm is part of this grand experiment, to create social networking
tools that are independent of any one large company. But unlike posting
text to a network, Soundstorm is based primarily around the sharing of
audio. There were several challenges surrounding this new goal that were
overcome, and this blog post shares a few of them.

## Challenge #1: Securely Streaming Audio

The biggest challenge here is also shared between the operators of
Soundstorm instances and its development, which is how to securely and
efficiently stream audio from a user's account to anyone on the Web.
Content creators won't want to be forced to provide a song for download
whenever they upload a file, and in many cases would rather the file be
only available to stream. This poses a challenge for a federated social
network: How do you share something that can't be downloaded?

The way we chose to accomplish this was to use [HTTP Live
Streaming](https://en.wikipedia.org/wiki/HTTP_Live_Streaming), a
technology that involves slicing the given audio into many 15-second
"transport segments", then generating an `.m3u8` playlist containing
those segments, and playing back that audio using a web player (or
anything else that can read such a playlist). This is somewhat of an
expensive operation, and can put an excessive strain on the server, so
it's performed in the background using [Sidekiq](https://sidekiq.org),
and users are notified later on when their track is available.

Rails comes with its own uploading framework called
[ActiveStorage][], and Soundstorm uses it extensively since it's
primarily a media uploading service. When a user uploads a track, it's
done so via ActiveStorage's JavaScript integration, which uploads
directly to S3. When the track is saved, the application downloads the
track and post-processes it in Sidekiq jobs. Additionally, when
generating transport segments and the track waveform, the generated
files are *also* uploaded to ActiveStorage so that they take advantage
of the CDN and fast external storage of Amazon.

However, this poses a sub-challenge: If we're using a cloud to store all
files, how are we going to process them after they're uploaded if
there's no actual file being saved on the application server?
Thankfully, one of ActiveStorage's capabilities is post-upload analysis
of video and images, which it can do so by downloading the artifact to a
tempfile on disk, then deleting the file afterwards. While ActiveStorage
comes with an image and video analyzer out-of-the-box (for variant and
preview support), there's nothing for audio that I could find, so
[I made my own](https://github.com/tubbo/activestorage-audio). By
including the gem in your Gemfile, it will automatically analyze any
audio files that are uploaded and save their `metadata` to the database.
It's based off the out-of-box `VideoAnalyzer`, which also uses `ffmpeg`,
but is just designed to work with a different kind of file. The analyzer
can grab duration, technical stream info, and much more, and is used
both for display purposes and to serve the original file download.

## Challenge #2: Communicating New Uploads

Now that we have audio files on the server, how can they be federated to
other servers? We sure don't want the other servers to have to download
every new audio file posted to the network, and although ActivityPub
has [an Audio type](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-audio)
for sending audio *files*, this would prevent users from making tracks
non-downloadable, and that's not very useful. The solution here was to
broadcast new track uploads as
[Notes](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-note)
with the contents being a link to the track, and including OEmbed
support with an inline web player, so tracks can be played back from
directly inside one's feed. No previewing or weird login errors, no
matter where you share from, any public track is always available
inside a web player

Additionally, since `<audio>` tags don't always support HLS in all
browsers, we opted to use a video-type OEmbed, which essentially looks
like you're playing back a video, but in reality it's the Soundstorm web
player.

## Challenge #3: Containerization and Configuration

The final challenge I'm going to talk about today was getting the
application prepared for production. It was decided early on that Soundstorm
was going to be primarily distributed using a Docker image. Since
Soundstorm is implemented in Ruby on Rails and this can pose several
roadblocks for those new to the whole ecosystem. In the past, you'd have
to worry about pretty much the entire stack, especially when gems use
native extensions, because you never know exactly which architecture
that the C extension is compiling on, leading to errors that are
difficult, if sometimes impossible (depending on how old your system
is), to get around.

But with Docker and a simple Makefile, a lot of these build problems go
away instantaneously.  Running `make` in the root of Soundstorm
generates a Docker image that has Soundstorm's source code, all of the
assets you'll need for your environment, and any other hard dependencies
that are used by the app (such as `ffmpeg` and `libsndfile`). By running
all of your Soundstorm commands on the Docker image, you can ensure a
fast and stable build environment for which to do your work upon. In
addition, Docker Compose helps configure and start external services
needed by the application, such as PostgreSQL, Elasticsearch, and Redis.

Originally, Soundstorm was configured using environment variables, but
this got hairy pretty quickly. Rather than force a user to set 15-20 env
vars just to get the app set up, the decision was made to use Rails'
`config/credentials.yml.enc` for saving secrets. When installing the app
for the first time, a new credentials file is generated and that file
(as well as `config/master.key`) is used to keep secure credentials on
production. These files are saved into Kubernetes as secrets, and copied
into place before the application is initialized so that the app's
secrets are available to it at all times. However, these files are
ignored by the build step and are never included in a Soundstorm image.
By doing things this way, the trade-off of being able to start a
container using the Soundstorm image without any configuration (e.g. a
one-liner with `docker start`) was out of the question, but it will be a
lot easier to communicate secret credentials into the Kubernetes cluster
than by using environment variables and forcing Kubernetes to figure it
out.

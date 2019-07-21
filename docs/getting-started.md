---
title: Getting Started
layout: default
---

# Getting Started

We attempted to make running your own Soundstorm instance as easy as
possible. Here's a couple ways to deploy Soundstorm to your own
infrastructure, using [Heroku][]'s PaaS or the [Kubernetes][] framework.

## Heroku

You can install your own Soundstorm instance on [Heroku][] by clicking this
button:

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/weathermen/soundstorm)

This is, by far, the easiest way to install Soundstorm and see if it's
right for you, but it does have some limitations. For one thing, SSL is
required by Soundstorm, and Heroku only offers SSL out-of-the-box for
its own `.herokuapp.com` domains. Additionally, Bonsai Elasticsearch is
somewhat out-of-step with the latest Elasticsearch, so version
differences may cause hard-to-debug issues. That said, Heroku has proven
to be a great staging server for us and even hosted
<https://soundstorm.social> at one time, but we only recommend its usage
for low-traffic servers (like a personal instance) unless you're willing
to pay for the higher scaling abilities.

## Kubernetes

This is how <https://soundstorm.social> is hosted on production. We
recommend using Kubernetes if the Heroku option doesn't work out, or
your scaling needs surpass the level where Heroku is still affordable.
That said, Kubernetes is still the recommended choice of hosting for all
scaling levels because of its precision and efficiency, as long as
you're OK with the learning curve.

If you want to install on your own Kubernetes infrastructure, make sure
you have [kubectl][], [Docker][], and [Helm][] installed and configured
locally to use your production cluster.

First, download the latest installer from GitHub and `make install` it:

```bash
$ curl -L https://github.com/weathermen/soundstorm/releases/latest/installer.tar.gz -o soundstorm-installer.tar.gz
$ tar -zxvf soundstorm-installer.tar.gz
$ cd soundstorm-installer
$ make install
```

This will prompt you to create a credentials file, which occurs in the
actual container itself. Set up your credentials here and a
**config/credentials.yml.enc** and **config/master.key** file should
appear in the current directory.

Once your credentials are saved, create the production image by running:

```bash
$ make RAILS_ENV=production
```

Now that your application is configured for production use, and the
production image has been built, run the following command to install
the preliminary resources needed for the application to run, such as
the [Nginx Ingress Controller][], [Compose API][], and [Cert-Manager][]:

```bash
$ make cluster
```

You're now ready to deploy the application! Make sure you have your
domain name's `A` record pointing to the Kubernetes cluster so that the
ingress point that was just created will work with your actual domain.

Run the following command to deploy the latest containers to your
Kubernetes cluster:

```bash
$ make deploy
```

This command might take a while, so be patient. When it finishes, your
containers should be live on your cluster. Run `kubectl get all` to view
a status report of all your pods.

### Deploying Updates to your Kubernetes Cluster

When new updates are released for Soundstorm, you'll be able to deploy
them by running `make deploy`. You won't have to do all the other steps
mentioned above.

### Data Integrity

Soundstorm stores its data volumes in Kubernetes, so if you delete the
cluster and its volumes, your data will be lost (except for the actual
download files and transport segments, those are stored on S3, but will
become "orphaned" if your database gets deleted). Be very careful not to
delete the entire Kubernetes cluster. If you need to rebuild it for any
reason, create a brand new cluster, migrate the volumes over to it,
then deploy to the new cluster instead of destroying and rebuilding the
existing one.

If for any reason you don't wish to store your data in Kubernetes, you
can always use the `$ELASTICSEARCH_URL`, `$REDIS_URL`, and
`$DATABASE_URL` environment variables to control where the application
looks for its data.

[Heroku]: https://heroku.com
[Kubernetes]: https://kubernetes.io
[kubectl]: https://kubernetes.io/docs/tasks/tools/install-kubectl/
[Docker]: https://docker.com
[Helm]: https://helm.sh/
[Nginx Ingress Controller]: https://github.com/kubernetes/ingress-nginx
[Compose API]: https://github.com/docker/compose-on-kubernetes
[Cert-Manager]: https://cert-manager.io/

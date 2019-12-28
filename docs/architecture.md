# Architecture

Soundstorm is a Ruby on Rails application that takes full advantage of
the "majestic monolith" concept, as well as rendering all HTML on the
server. This is done for a number of reasons, including simplicity of
development as well as improved performance in production (taking full
advantage of Rails' caching mechanisms, `Rack::Cache` HTTP caching, and
using a CDN to serve static assets).

## The Rails App

The Rails application is divided into several main layers:

- **Controllers** describe the HTTP API that is used to interact with
  Soundstorm, which is served in both HTML and JSON format. The HTML is
  what you see when you use the web interface, and the JSON is
  authenticated separately (over OAuth) for machine integrations with
  the platform.
- **Jobs** are the background jobs, which take large chunks of work and
  process them in the background to avoid slow response times. These
  jobs include segmenting a newly uploaded track for streaming over HLS,
  and analyzing tracks for waveform and metadata.
- **Processors** are used to process newly uploaded tracks. These do the
  "grunt work" of segmenting/uploading, analyzing metadata, and
  generating waveforms from the uploaded audio, to be stored back into
  ActiveStorage for use when streaming or viewing the track.
- **Models** describe the data model and most of the business logic of
  the platform.
- **Services** communicate with 3rd-party services and translate between
  incoming activity updates from federated servers and the local API.
- **Validators** are custom-written validations for model objects.
- **Views** describe the web interface of the application as well as a
  lot of its JSON API used to interact with machines.

## The JavaScript App

In Stimulus, everything is a controller.

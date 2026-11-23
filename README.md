# FOIWorks

FOIWorks helps people make Freedom of Information (FOI) and
Environmental Information Regulations (EIR) requests to a council.

Before a person sends a request, the app shows them information the
council has already published. These suggestions come from the council's
disclosure log and from links that council staff add. If a suggestion
answers the question, the person does not need to send a request.

The app sends each new request to the council's case management system.
It supports iCasework and Infreemation, through the
[icasework](https://github.com/mysociety/icasework-ruby) and
[infreemation](https://github.com/mysociety/infreemation-ruby) gems.

[mySociety](https://www.mysociety.org) built FOIWorks with Hackney Council,
which helped to design it.

## Use it for your council

[SocietyWorks](https://www.societyworks.org), a subsidiary of mySociety,
can set up and run FOIWorks for your council. Read about
[FOIWorks](https://www.societyworks.org/services/foi/), or
[request a demo](https://www.societyworks.org/demo-request/).

## Requirements

- Ruby 3.4
- PostgreSQL
- Redis
- Firefox, for the JavaScript specs

## Set up

Run the setup script:

```sh
bin/setup
```

The script installs the gems and copies the example config files. Then it
prepares the database and starts the development server.

To use Docker in place of a local Ruby, PostgreSQL and Redis, run
`docker/setup`. Then run `docker/server`.

## Configuration

### Database

Set the database connection in `config/database.yml`. The setup script
copies it from `config/database.yml-example`.

### Case management

Set the case management system in `config/case_management.yml`. The setup
script copies it from `config/case_management.yml-example`. Each
environment needs an `adapter`:

- `Icasework` sends requests to iCasework.
- `Infreemation` sends requests to Infreemation.
- `Dummy` does not send requests anywhere. Use it to run the app without a
  case management system.

The iCasework and Infreemation adapters also need `client_params`, such as
the API endpoint and key.

Do not use the `Dummy` adapter on a live site. It does not deliver
requests.

### Environment variables

| Variable | Use |
|---|---|
| `REDIS_URL` | The Redis server for Sidekiq, for example `redis://localhost:6379/0`. |
| `REDIS_PASSWORD` | The Redis password, if the URL does not include it. |
| `REDIS_SENTINELS` | A comma-separated list of Redis Sentinel hosts, for example `10.0.0.1:26379,10.0.0.2:26379`. With sentinels, `REDIS_URL` names the master, for example `redis://mymaster/0`. |
| `GOOGLE_CLIENT_ID` | The Google OAuth client for admin sign in. |
| `GOOGLE_CLIENT_SECRET` | The Google OAuth secret for admin sign in. |
| `EXCEPTION_NOTIFICATIONS_TO` | A comma-separated list of addresses that get error emails in production. Leave it empty to send no error emails. |
| `EXCEPTION_NOTIFICATIONS_FROM` | The sender address for error emails. |
| `VHOST` | The site name in the subject of error emails. The default is `foi-for-councils`. |
| `RAILS_LOG_LEVEL` | The production log level. The default is `info`. |

## Run the app

Start the web server:

```sh
bin/dev
```

Start the Sidekiq worker in a second terminal:

```sh
bin/sidekiq
```

Sidekiq delivers new requests to the case management system. It also runs
the recurring jobs in `config/sidekiq.yml`:

- It queues requests that could not be queued before, for example when
  Redis was down.
- It deletes old requests.
- It imports the disclosure log.

Staff sign in at `/admin` with a Google account on the `mysociety.org`
or `hackney.gov.uk` domain. To allow a different domain, change `hd` in
`config/initializers/omniauth.rb`.

Staff can then manage curated links, export them as CSV, and see how the
suggestions perform.

`/sidekiq` shows the job queue. The app does not require a sign in for
it. Protect it in the web server config.

## Specs

Run all the specs:

```sh
bin/rspec
```

The JavaScript specs need Firefox. Where a browser cannot start, skip
them:

```sh
bin/rspec --tag '~js'
```

Check the code style:

```sh
bin/rubocop
```

## Licence

FOIWorks is free software under the GNU Affero General Public
License version 3 or later. See [LICENSE.txt](LICENSE.txt).

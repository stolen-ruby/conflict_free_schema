![71wdVdp0ncL](https://user-images.githubusercontent.com/1527612/111843245-1a0d8b80-8901-11eb-987a-f382d2396f8d.jpg)

### Why stolen ruby?

_Stolen ruby_ is an idea behind extracting open-source code into more accessible packages. I noticed that a lot of interesting projects have quite a lot of brilliant code that is unfortunately often _embedded_ into the source and never extracted - which is a shame because often it's very useful stuff and a lot of different people could benefit from it. The idea is to change that - extract those hidden gems and publish them into the world.

_Note: cover stolen [from well known book](https://austinkleon.com/steal/)._

# conflict_free_schema

![status](https://github.com/stolen-ruby/conflict_free_schema/actions/workflows/ci.yml/badge.svg)

**Stolen from:** [GitLab](https://gitlab.com); references: [merge request](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/30109#65c74abf34b80b85fc4b56a98b029c7e2d884bac), [issue](https://gitlab.com/gitlab-org/gitlab/-/issues/218590)

Original author: Patrick Bair; extracted code with very minor modifications, added higher-level Rails integrations tests on top

## Requirements

Rails 6+ with postgresql

## Installation

Add the following to your `Gemfile`:

~~~ruby
gem 'conflict_free_schema'
~~~

Then install the gem using bundle:

~~~bash
bundle install
~~~

Gem will auto-hook into your rails app via `Rails::Railtie`

## What does it do?

> Remove conflicts from structure.sql that are caused by tracking the schema_migrations.versions information. To do this, store an empty file named after each version under the db/schema_migrations directory. That way when we versions are added or removed, we add or delete files from the directory, which should not conflict with other changes.

If you're using `structure.sql` in your Rails project with postgresql - instead of putting schema version in the sql file upon dump, each migration will be stored as a separate file in `db/schema_migrations` (with a SHA hash as content so it's a unique file from git's perspective). If you're doing a lot of structure changes across your organization it should make the life of your developers much easier - resolving conflicts in structure is pain already - even without the need to resolve schema migrations version numbers.

## Development

You can spin up postgres test dependency with provided `docker compose`.

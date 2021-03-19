![71wdVdp0ncL](https://user-images.githubusercontent.com/1527612/111843245-1a0d8b80-8901-11eb-987a-f382d2396f8d.jpg)

### Why stolen ruby?

Stolen ruby is an idea behind extracting open-source code into more accessible packages. I noticed that quite a lot interesting projects have quite a lot of brilliant code that is unfortunately often embedded into the source and never ever extracted - which is a shame, because often it's very useful stuff and a lot of other people could benefit from it. The idea is to change that - extract those hidden gems and publish it into the world.

# conflict_free_schema

![status](https://github.com/stolen-ruby/conflict_free_schema/actions/workflows/ci.yml/badge.svg)

**Stolen from:** [GitLab](https://gitlab.com); references: [merge request](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/30109#65c74abf34b80b85fc4b56a98b029c7e2d884bac), [issue](https://gitlab.com/gitlab-org/gitlab/-/issues/218590)

# What does it do?

> Remove conflicts from structure.sql that are caused by tracking the schema_migrations.versions information. To do this, store an empty file named after each version under the db/schema_migrations directory. That way when we versions are added or removed, we add or delete files from the directory, which should not conflict with other changes.

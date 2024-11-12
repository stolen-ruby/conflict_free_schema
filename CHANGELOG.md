### 0.2.0

- Add support for Rails 7.0, 7.1, and 7.2 ([@mkrfowler](https://github.com/mkrfowler))
    - please be aware that multi-db support was not yet ported from GitLab's original codebase; so this release simply relaxes the Rails version requirement and adds basic integration tests for Rails 7.x

- drop old Ruby 2.x from test matrix - test on Ruby 3.0 - 3.2
- drop old postgres version from test matrix - test on 14 - 16

### 0.1.2

- do a recursive search for migrations - use `db/migrate/**/*` pattern ([@Ivanov-Anton](https://github.com/Ivanov-Anton))
- test on latest Rails 6.0 / 6.1
- exclude Ruby 3.1 in CI matrix for now ([6.x required workarounds](https://github.com/rails/rails/issues/43998))

### 0.1.1

- explicitly declares files for gem package
- properly require at least 6.x version of Rails (if anyone is interested in Rails 5.2 - #1 might be a good start)

### 0.1.0

- Initial release

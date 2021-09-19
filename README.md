# K6

**This project provides mix tasks for interacting with k6.**


## Installation

The package can be installed by adding `k6` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:k6, github: "spawnfest/gabibbo"}
  ]
end
```

After that you can install k6 by running:

```shell
mix k6.install
```

At the moment we support only the following architectures:

* mac os - amd64
* linux  - amd64

By default the installation task will install k6 version `v0.34.1`.
You can override this in your config file:

```elixir
config :k6, version: "vX.X.X"
```

## Generating a k6 test

You can generate different k6 tests by running:

```shell
mix k6.gen.test --type graphql --url any-url:port testname.js
```

Supported test types are:

* graphql
* rest
* grpc

Notice that if you don't pass the `url` option when generating a test, generators will make assumptions on the url to test:

* rest/graphql: if inside a phoenix application fallbacks to configured phoenix endpoint, otherwise to `http://localhost:4000`
* grpc: fallbacks to `localhost:9001`

## Running tests

You can run k6 as:

```shell
mix k6 run
```

The flgs you can pass when running test are those of standard k6.
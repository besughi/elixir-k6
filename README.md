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

By default the installation task will install k6 version `v0.34.1`.
You can override this in your config file:

```elixir
config :k6, version: "vX.X.X"
```

## Generating a k6 test

You can generate different k6 tests by running:

```shell
mix k6.gen.test --type graphql testname.js
```

Supported test types are:

* graphql
* rest
* grpc
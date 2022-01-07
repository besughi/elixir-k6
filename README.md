# Elixir-K6

Quick and painless load testing for Elixir applications.
Easily generate load tests and run them via a local installation of [k6](https://k6.io).

Originally developed at [SpawnFest](https://spawnfest.org/) 2021.

## Installation

The package can be installed by adding `k6` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:k6, "~> 0.1.0"}
  ]
end
```

## Usage

To generate new k6 tests run:

```shell
mix k6.gen.test <test_name>
```

By default k6 tests will be placed under the `priv/k6` directory of your project.

The template to use for the test can be set via the `--type` argument.
Supported types are `rest` (default), `graphql`, `grpc`, `websocket`, `phoenix-channel` (experimental) and `liveview` (experimental).

Run `mix help k6.gen.test` for more info on generating tests.

To execute k6 tests run:

```shell
mix k6 run <test_name>.js
```

Run `mix help k6` for more info on running k6.

### Configuration

`elixir-k6` can be configured via `config.exs` as follows:

```elixir
config :k6,
  version: "vX.Y.Z",
  env: [VAR_KEY: "some value"],
  workdir: "priv/my_load_tests_dir"
```

The supported configuration parameters are:

- `version`: the desired version of k6. Defaults to `v0.35.0`.
- `env`: environment variables to pass to load tests. K6 will expose those variables to load test scripts within the `__ENV` object.
- `workdir`: path of the directory that contains k6 load tests. Relative to the project, defaults to `priv/k6`.

### K6 installation

K6 is automatically installed the first time you run k6 tests, and it is stored in `_build/k6`.
In case you want to explicitly install it before running any test, you can run `mix k6.install`.

At the moment the following architectures are supported:

|  OS   |    Architecture    |
| :---: | :----------------: |
| MacOs |       amd64        |
| MacOs | arm64 (not tested) |
| Linux |       amd64        |
| Linux | arm64 (not tested) |

By default the installation task will install k6 version `v0.35.0`.
You can override this in your config file, as documented above.

## Contributing

Issues and contributions are welcome!

To run static analysis run:

```shell
mix check
```

To execute tests run:

```shell
mix test
```

The test suite also includes some end-to-end tests, which are not executed by default as they are much slower.
To execute all tests run:

```shell
mix test --include end_to_end
```

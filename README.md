# K6

Quick and painless load testing for Elixir applications.

Easily install [k6](https://k6.io) locally, generate load tests and run them.

## Installation

The package can be installed by adding `k6` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:k6, github: "spawnfest/gabibbo"}
  ]
end
```

## Usage

### Installing k6

K6 is automatically installed the first time you try to run load tests.

If you need to explicitly install it before running the tests, you can run:

```shell
mix k6.install
```

At the moment we support the following architectures:

- mac os - amd64
- linux - amd64

By default the installation task will install k6 version `v0.34.1`.
You can override this in your config file:

```elixir
config :k6, version: "vX.X.X"
```

### Generating tests

To generate new k6 tests run:

```shell
mix k6.gen.test <testname>
```

These tests will be placed under the `priv/k6` directory of your project.

Available options to customize the generated test are:

- `--url <url>`: sets the url of the target application. When not provided, the generator will try to detect the url of the configured application, and default to a predefined value (e.g. `localhost:4000` for rest / graphl APIs) otherwise.
- `--type <test_type>`: defines the template to use for generating the test. Supported types are `graphql`, `rest` and `grpc`.

### Running k6

Once you have defined some tests, you can run k6 as follows:

```shell
mix k6 run [<arg>...]
```

This will run k6 in the context of your `priv/k6` folder, where your tests reside, and will forward all the provided arguments to k6.

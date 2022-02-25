defmodule K6.MixProject do
  use Mix.Project

  @source_url "https://github.com/besughi/elixir-k6"
  @version "0.1.1"

  def project do
    [
      app: :k6,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      aliases: aliases(),
      xref: [exclude: [:httpc, :castore, :xref]],
      dialyzer: [plt_add_deps: :transitive, plt_add_apps: [:mix]],
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:eex, :public_key, :logger]
    ]
  end

  defp package do
    [
      description: "Mix tasks for generating load tests, installing and invoking k6",
      links: %{"GitHub" => @source_url, "k6" => "https://k6.io"},
      licenses: ["MIT"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:castore, ">= 0.1.11"}
    ] ++ dev_deps() ++ test_deps()
  end

  defp dev_deps do
    [
      {:credo, "~> 1.6", only: [:dev]},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp test_deps do
    [
      {:bypass, "~> 2.1", only: [:test]}
    ]
  end

  def aliases do
    [
      check: [
        "compile --all-warnings --ignore-module-conflict --warnings-as-errors --debug-info",
        "format --check-formatted mix.exs \"lib/**/*.{ex,exs}\" \"test/**/*.{ex,exs}\" \"priv/**/*.{ex,exs}\"",
        "deps.unlock --check-unused",
        "credo -a --strict",
        "dialyzer"
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end

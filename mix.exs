defmodule K6.MixProject do
  use Mix.Project

  def project do
    [
      app: :k6,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      xref: [exclude: [:httpc, :castore, :xref]],
      dialyzer: [plt_add_deps: :transitive, plt_add_apps: [:mix]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:eex, :public_key, :logger]
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
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev]}
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
end

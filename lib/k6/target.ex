defmodule K6.Target do
  @moduledoc """
  Get k6 target version according to system
  """
  @type file_type :: :zip | :tar_gz

  @doc """
  Get k6 target version
  """
  @spec get!(String.t()) :: {file_type(), String.t()}
  def get!(version, platform \\ &platform/0) do
    case platform.() do
      {:x86, :darwin} ->
        {:zip, "k6-#{version}-macos-amd64.zip"}

      {:x86, :linux} ->
        {:tar_gz, "k6-#{version}-linux-amd64.tar.gz"}

      {:arm, :darwin} ->
        {:zip, "k6-#{version}-macos-arm64.zip"}

      {:arm, :linux} ->
        {:tar_gz, "k6-#{version}-linux-arm64.tar.gz"}

      other ->
        raise "Not implemented for #{inspect(other)}"
    end
  end

  defp platform do
    case {architecture(), :os.type()} do
      {'x86_64', {:unix, :darwin}} -> {:x86, :darwin}
      {'arm', {:unix, :darwin}} -> {:arm, :darwin}
      {'x86_64', {:unix, :linux}} -> {:x86, :linux}
      {'arm', {:unix, :linux}} -> {:arm, :linux}
    end
  end

  defp architecture do
    arch_str = :erlang.system_info(:system_architecture)
    [arch | _] = :string.split(arch_str, '-')
    arch
  end
end

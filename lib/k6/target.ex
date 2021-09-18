defmodule K6.Target do
  @moduledoc """
  Get k6 target version according to system
  """
  @type file_type :: :zip | :tar_gz

  @doc """
  Get k6 target version
  """
  @spec get!(String.t()) :: {file_type(), String.t()}
  def get!(version, os_type \\ &:os.type/0) do
    case os_type.() do
      {:unix, :darwin} ->
        {:zip, "k6-#{version}-macos-amd64.zip"}

      {:unix, :linux} ->
        {:tar_gz, "k6-#{version}-linux-amd64.tar.gz"}

      other ->
        raise "Not implemented for #{inspect(other)}"
    end
  end
end

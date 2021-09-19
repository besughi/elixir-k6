defmodule K6.Downloader do
  @moduledoc """
  Downloads k6 package according to a version and target environment
  """
  alias K6.Target

  @known_checksums %{
    "k6-v0.34.1-linux-amd64.tar.gz" =>
      "932668f86b4f5cfd4d33cd7c05651f9638570ccf303480ab5c207cba394e1732",
    "k6-v0.34.1-linux-arm64.tar.gz" =>
      "3f18dec2433c65cdc1bc1ddeafeabe77e9be00443987f5ec85e60c1504a13144",
    "k6-v0.34.1-macos-amd64.zip" =>
      "b852687554455dd98b8a3c193608503263e87899be18e337e7473ae656c273f2",
    "k6-v0.34.1-macos-arm64.zip" =>
      "211fdce7f33df0643e0aaca59af9550b8c999cb6d4bbd6b741db059ecf9d7d73"
  }

  @doc """
  Downloads k6 package
  """
  @spec download!(String.t()) :: {Target.file_type(), binary()}
  def download!(k6_version) do
    # https://erlef.github.io/security-wg/secure_coding_and_deployment_hardening/inets
    cacertfile = CAStore.file_path() |> String.to_charlist()

    {file_type, target} = Target.get!(k6_version)

    options = [
      ssl: [
        verify: :verify_peer,
        cacertfile: cacertfile,
        depth: 2,
        customize_hostname_check: [
          match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
        ]
      ]
    ]

    case :httpc.request(:get, {binary_url(k6_version, target), []}, options, body_format: :binary) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        verify_checksum!(body, target)
        {file_type, body}

      other ->
        raise "couldn't fetch #{binary_url(k6_version, target)}: #{inspect(other)}"
    end
  end

  defp binary_url(k6_version, target) do
    "https://github.com/grafana/k6/releases/download/#{k6_version}/#{target}"
  end

  def verify_checksum!(body, target) do
    expected_checksum = Map.get(@known_checksums, target)

    if expected_checksum != nil and String.downcase(checksum(body)) != expected_checksum,
      do: raise("Download error: checksum verification failed!")
  end

  defp checksum(body), do: :sha256 |> :crypto.hash(body) |> Base.encode16()
end

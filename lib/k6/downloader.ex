defmodule K6.Downloader do
  alias K6.Target

  @doc """
  Downloads k6 package according to target os
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
        {file_type, body}

      other ->
        raise "couldn't fetch #{binary_url(k6_version, target)}: #{inspect(other)}"
    end
  end

  defp binary_url(k6_version, target) do
    "https://github.com/grafana/k6/releases/download/#{k6_version}/#{target}"
  end
end

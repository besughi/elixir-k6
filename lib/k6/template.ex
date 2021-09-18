defmodule K6.Template do
  @default_base_url "http://localhost:4000"

  def default_base_url() do
    mix_app = Mix.Project.config()[:app]
    config = Application.get_all_env(mix_app)

    phoenix_endpoint =
      config
      |> Enum.map(fn {key, _value} -> key end)
      |> Enum.find(&phoenix_endpoint?/1)

    if phoenix_endpoint != nil do
      phoenix_endpoint.url()
    else
      @default_base_url
    end
  end

  defp phoenix_endpoint?(term) do
    try do
      "Endpoint" == term |> Module.split() |> Enum.at(-1)
    rescue
      _ -> false
    end
  end
end

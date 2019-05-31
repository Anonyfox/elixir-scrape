defmodule Scrape.Source.HTTP do
  alias Scrape.Source.HTTP.Charset
  alias Scrape.Source.HTTP.Get
  alias Scrape.Source.HTTP.Transcode

  def get(url) do
    url |> Get.execute() |> evaluate()
  end

  def get!(url) do
    {:ok, data} = get(url)
    data
  end

  defp evaluate({:error, _} = response), do: response

  defp evaluate({:ok, %{status_code: 200, headers: headers, body: body}}) do
    case Charset.from_headers(headers) do
      nil -> {:ok, body}
      charset -> {:ok, Transcode.execute(charset, body)}
    end
  end

  defp evaluate({:ok, %{body: body}}), do: {:http_error, body}

  defp evaluate(response), do: response
end

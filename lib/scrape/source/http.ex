defmodule Scrape.Source.HTTP do
  alias Scrape.Source.HTTP.Charset
  alias Scrape.Source.HTTP.Get
  alias Scrape.Source.HTTP.Transcode

  @doc """
  Perform a HTTP GET request against the given url.

  This function is optimized for *text*-based data, not binary like images.
  It will try to normalize the response into valid utf-8 and transcode if needed.

  Everything that is not a status code 200 with valid encoding will result in
  some error object.

  ## Examples:
      iex> HTTP.get("http://example.com")
      {:ok, }"some response"}
  """

  @spec get(String.t()) :: {:ok, String.t()} | {:error, any()} | {:http_error, any()}

  def get(url) do
    url |> Get.execute() |> evaluate()
  end

  @doc """
  Same as `get/1`, but will raise if the result is not `:ok`.
  """

  @spec get!(String.t()) :: String.t()

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

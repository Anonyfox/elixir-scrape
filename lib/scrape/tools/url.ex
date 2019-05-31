defmodule Scrape.Tools.URL do
  @moduledoc """
  Simple utility functions to extract information from URLs.
  """

  @doc """
  Rebase an URL to another root URL, useful for turning relative URLs into
  aboslute ones.

  ## Example
      iex> URL.merge("/path", "http://example.com")
      "http://example.com/path"
  """

  @spec merge(nil | String.t(), String.t()) :: nil | String.t()

  def merge(nil, _), do: nil

  def merge("", _), do: nil

  def merge(url, nil), do: url

  def merge(url, ""), do: url

  def merge(url, root_url) do
    root_url |> URI.merge(url) |> URI.to_string()
  end

  @doc """
  Checks if a given string actually represents an URL.

  ## Example
      iex> URL.is_http?("http://example.com")
      true

      iex> URL.is_http?("example")
      false
  """

  @spec is_http?(String.t()) :: boolean()

  def is_http?(url) do
    ["http", "/"]
    |> Enum.any?(&String.starts_with?(url, &1))
  end

  @doc """
  Transforms a given url into it's basic form, only including protocol scheme
  and host, without any other things like path, query or hash.

  ## Examples
      iex> URL.base("https://example.com/path?param=1#search")
      "https://example.com"

      iex> URL.base("//example.com")
      "http://example.com"
  """

  @spec base(String.t()) :: String.t()

  def base(url) do
    uri = URI.parse(url)
    scheme = uri.scheme || "http"
    host = uri.host
    "#{scheme}://#{host}"
  end
end

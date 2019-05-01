defmodule Scrape.IR.URL do
  @moduledoc """
  Simple utility functions to extract information from URLs.
  """

  @doc """
  Rebase an URL to another root URL, useful for turning relative URLs into
  aboslute ones.

  ## Example
      iex> Scrape.IR.URL.merge("/path", "http://example.com")
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
      iex> Scrape.IR.URL.is_http?("http://example.com")
      true

      iex> Scrape.IR.URL.is_http?("example")
      false
  """

  @spec is_http?(String.t()) :: boolean()

  def is_http?(url) do
    ["http", "/"]
    |> Enum.any?(&String.starts_with?(url, &1))
  end
end

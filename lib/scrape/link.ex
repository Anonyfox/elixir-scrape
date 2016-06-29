defmodule Scrape.Link do
  @moduledoc """
    Common helpers for normalizing and modifying URLs.
  """

  @doc """
    Takes the base path from a fully qualified absolute URL and expands the
    path of an unknown URL with it.

    iex> Scrape.Link.expand("/some/path", "//example.com/ab/c")
    "http://example.com/some/path"
  """

  def expand(nil, _base), do: nil
  def expand(target, base) do
    base_uri = base
    |> URI.parse
    |> put_lazy(:scheme, "http")

    target
    |> normalize_path
    |> URI.parse
    |> put_lazy(:scheme, base_uri.scheme)
    |> put_lazy(:authority, base_uri.authority)
    |> put_lazy(:host, base_uri.host)
    |> URI.to_string
  end

  defp put_lazy(uri, key, value) do
    Map.put(uri, key, Map.get(uri, key) || value)
  end

  defp normalize_path(uri) do
    cond do
      String.starts_with?(uri, "/") -> uri
      String.starts_with?(uri, "http") -> uri
      true -> "/#{uri}"
    end
  end

end

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
    |> URI.parse
    |> put_lazy(:scheme, base_uri.scheme)
    |> put_lazy(:authority, base_uri.authority)
    |> put_lazy(:host, base_uri.host)
    |> uri_to_string
  end

  defp put_lazy(uri, key, value) do
    Map.put(uri, key, Map.get(uri, key) || value)
  end

  # Shameless copy from newer Elixir stdlib, will remove once I upgrade Elixir:

  defp uri_to_string(uri) do
    scheme = uri.scheme

    if scheme && (port = URI.default_port(scheme)) do
      if uri.port == port, do: uri = %{uri | port: nil}
    end

    # Based on http://tools.ietf.org/html/rfc3986#section-5.3

    if uri.host do
      authority = uri.host
      if uri.userinfo, do: authority = uri.userinfo <> "@" <> authority
      if uri.port, do: authority = authority <> ":" <> Integer.to_string(uri.port)
    else
      authority = uri.authority
    end

    result = ""

    if uri.scheme,   do: result = result <> uri.scheme <> ":"
    if authority,    do: result = result <> "//" <> authority
    if uri.path do
      result = if String.first(uri.path) == "/", do: result <> uri.path, else: result <> "/" <> uri.path
    end
    if uri.query,    do: result = result <> "?" <> uri.query
    if uri.fragment, do: result = result <> "#" <> uri.fragment

    result
  end
end

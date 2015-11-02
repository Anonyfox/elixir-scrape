defmodule Scrape.Util.HTML do
  @moduledoc """
    Simplified querying of HTML strings.
  """
  alias Scrape.Util.Filter, as: Filter

  @doc """
    Apply a jQuery-like selector to a given HTML string and return the textual
    result.
  """

  @spec text(String.t, String.t) :: String.t | nil

  def text(html, query) do
    html
    |> Floki.find(query)
    |> Floki.text
    |> Filter.longest_entry
  end

  @doc """
    Same as `query_text`, but returns *all* unique matching results instead of
    just the longest one.
  """

  @spec text_all(String.t, String.t) :: [String.t]

  def text_all(html, query) do
    html
    |> Floki.find(query)
    |> Floki.text
    |> Enum.uniq
  end

  @doc """
    Apply a jQuery-like selector to a given HTML string and return the textual
    representation of the `content` attribute, if possible.
  """

  @spec meta(String.t, String.t, String.t) :: String.t | nil

  def meta(html, query, attribute \\ "content") do
    html
    |> Floki.find(query)
    |> Floki.attribute(attribute)
    |> Filter.longest_entry
  end

  @doc """
    Apply a jQuery-like selector to a given HTML string and return the textual
    representation of the `content` attribute, if possible.
  """

  @spec meta_all(String.t, String.t, String.t) :: [String.t]

  def meta_all(html, query, attribute \\ "content") do
    html
    |> Floki.find(query)
    |> Floki.attribute(attribute)
    |> Enum.uniq
  end

  @doc """
    Take a full HTML document and extract the relevant text passages.
  """

  @spec to_fulltext(String.t) :: String.t

  def to_fulltext(html) do
    html
    |> text_all(fulltext_query)
    |> Enum.filter(&fulltext_filter/1)
    |> IO.inspect
  end

  defp fulltext_query(), do: "h1,h2,h3,h4,h5,h6,p"#,article,section"

  defp fulltext_filter(nil), do: false
  defp fulltext_filter(str), do: String.length(str) > 10

end

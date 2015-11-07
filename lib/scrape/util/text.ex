defmodule Scrape.Util.Text do
  @moduledoc """
    Small helper functions that help dealing with plain text, sanitizing
    HTML snippets and the like.
  """
  alias Scrape.Util.Stopwords

  @doc """
    Extract the main content from a HTML site. The resulting paragraphs are
    stripped of every non-space whitespace, and then joined via `"\n\n"`.

    If you need the individual articles back, just split the text via
    `String.split(text, "\n\n")`.
  """

  @spec article_from_html(String.t) :: String.t

  def article_from_html(html) do
    html
    |> without_js
    |> Floki.find("article, p, div, body")
    |> Enum.map(fn x -> Floki.text(x, deep: false) end)
    |> Enum.map(&normalize_whitespace/1)
    |> Enum.filter(&is_relevant?/1)
    |> Enum.join("\n\n")
  end

  @doc """
    A text paragraph shall not include any whitespace except single spaces
    between words.

    iex> Scrape.Util.Text.normalize_whitespace("\r\thello world\r ")
    "hello world"
  """

  @spec normalize_whitespace(String.t) :: String.t

  def normalize_whitespace(text) do
    text
    |> String.replace(~r/\s+/, " ")
    |> String.replace(~r/\s+/, " ")
    |> String.strip
  end

  @doc """
    A text paragraph is relevant if it has a minimum amount of characters and
    contains any indicators of a sentence-like structure.

    Very naive approach, but works surprisingly well so far.
  """

  @spec is_relevant?(String.t) :: String.t

  def is_relevant?(text) do
    (String.length(text) > 30) &&
    (String.contains?(text, [". ","? ", "! ", "\" ", "\", ", ": "]))
  end

  @doc """
    Remove all occurences of javascript from a HTML snippet. Uses a regex.
  """

  @spec without_js(String.t) :: String.t

  def without_js(text) do
    rx = ~r/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/i
    String.replace(text, rx, "")
  end

  @doc """
    Strip all HTML tags from a text
  """

  @spec without_html(String.t) :: String.t

  def without_html(text) do
    text
    |> Floki.parse
    |> Floki.text
  end

  @doc """
    Split a given text up into a list of (*downcased*) meaningful words.
  """

  @spec to_words(String.t) :: [String.t]

  def to_words(text) do
    text
    |> String.downcase
    |> normalize_whitespace
    |> String.split
    |> Enum.filter(fn s -> String.length(s) > 2 end)
    |> Enum.filter(fn s -> String.match?(s, ~r/^[\p{L}\p{M}\w]+$/u) end)
    |> Stopwords.remove
  end

  @doc """
    Count the meaningful words of a given text or list of words. The results
    are aggregated into a map of the form: `%{"tag" => 17}`
  """

  @spec count_words(String.t | [String.t]) :: %{String.t => float}

  def count_words(text) when is_binary(text),do: text |> to_words |> count_words
  def count_words(words) do
    Enum.reduce words, %{}, fn word, acc ->
      Map.update(acc, word, 1, fn(x) -> x + 1 end)
    end
  end
end

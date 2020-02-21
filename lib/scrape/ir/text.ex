defmodule Scrape.IR.Text do
  @moduledoc """
  Collection of text mining algorithms, like summarization, classification and
  clustering.

  Details are hidden within the algorithms, so a clean interface can be provided.
  """

  alias Scrape.IR.Text.TFIDF
  alias Scrape.Tools.Word

  @doc false
  def generate_summary(text) do
    # TODO: my markov chain implementation belongs here.
    text
  end

  @doc """
  Dissect a text into sentences, weight their stemmed keywords against each other and
  return the 3 semantically most important sentences.
  """

  def extract_summary(text, start_words, language \\ :en) do
    text
    |> TFIDF.generate_database(language)
    |> TFIDF.query(start_words)
  end

  @doc """
  Find out in which natural language the given text is written in.

  Currently only german and (fallback) english are valid results. Uses external
  library [Paasaa](https://hex.pm/packages/paasaa).

  ## Example
      iex> Scrape.IR.Text.detect_language("the quick brown fox jumps over...")
      :en

      iex> Scrape.IR.Text.detect_language("Es ist ein schönes Wetter heute...")
      :de
  """

  @spec detect_language(String.t()) :: :de | :en

  def detect_language(text) do
    case Paasaa.detect(text) do
      "deu" -> :de
      _ -> :en
    end
  end

  @doc """
  Remove all occurences of javascript from a HTML snippet.

  Uses a regex (!)

  ## Example
      iex> Scrape.IR.Text.without_js("a<script>b</script>c")
      "ac"
  """

  @spec without_js(String.t()) :: String.t()

  def without_js(text) do
    rx = ~r/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/i
    String.replace(text, rx, "")
  end

  @doc """
  Strip all HTML tags from a text.

  ## Example
      iex> Scrape.IR.Text.without_html("<p>stuff</p>")
      "stuff"
  """

  @spec without_html(String.t()) :: String.t()

  def without_html(text) do
    text
    |> Floki.parse()
    |> Floki.text()
  end

  @doc """
  A text paragraph shall not include any whitespace except single spaces
  between words.

  ## Example
      iex> Scrape.IR.Text.normalize_whitespace("\\r\\thello world\\r ")
      "hello world"
  """

  @spec normalize_whitespace(String.t()) :: String.t()

  def normalize_whitespace(text) do
    text
    |> String.replace(~r/\s+/, " ")
    |> String.replace(~r/\s+/, " ")
    |> String.trim()
  end

  @doc """
  Removes all junk from a given text, like javascript, html or mixed whitespace.

  ## Example
      iex> Scrape.IR.Text.clean("\\t hello, \\r<b>world</b>!")
      "hello, world!"
  """
  def clean(text) do
    text
    |> without_js()
    |> without_html()
    |> normalize_whitespace()
  end

  @doc """
  Dissect a text into word tokens.

  The resulting list is a list of downcased words with all non-word-characters
  stripped.

  ## Examples
      iex> Scrape.IR.Text.tokenize("Hello, world!")
      ["hello", "world"]
  """

  @spec tokenize(String.t()) :: [String.t()]

  def tokenize(text) do
    text
    |> String.replace(~r/[^\w\s]/u, " ")
    |> normalize_whitespace()
    |> String.downcase()
    |> String.split()
  end

  @doc """
  Dissect a text into word tokens.

  The resulting list is a list of downcased words with all non-word-characters
  stripped, but common phrase delimiters still included.

  ## Examples
      iex> Scrape.IR.Text.tokenize_preserve_delimiters("Hello, world!")
      ["hello", ",", "world", "!"]
  """

  @spec tokenize_preserve_delimiters(String.t()) :: [String.t()]

  def tokenize_preserve_delimiters(text) do
    text
    |> String.replace(~r/([,\.\!\?])/u, " \\1 ")
    |> String.replace(~r/[^\w\s,\.\!\?]/u, " ")
    |> normalize_whitespace()
    |> String.downcase()
    |> String.split()
  end

  @doc """
  Dissect a text into word tokens similar to `tokenize/1` but strips words
  that carry no semantic value.

  ## Examples
      iex> Scrape.IR.Text.semantic_tokenize("A beautiful day!", :en)
      ["beautiful", "day"]
  """

  @spec semantic_tokenize(String.t(), :de | :en) :: [String.t()]

  def semantic_tokenize(text, language \\ :en) do
    text
    |> tokenize()
    |> Enum.filter(fn word -> Word.is_meaningful?(word, language) end)
  end

  @doc """
  Similar to `semantic_tokenize/2`, but also determines the n (default: 20)
  most relevant **stemmed** tokens from the list.
  """

  def semantic_keywords(text, n \\ 20, language \\ :en) do
    text
    |> semantic_tokenize(language)
    |> Enum.map(&Word.stem(&1, language))
    |> Enum.reduce(%{}, &aggregate_word_scores/2)
    |> Map.to_list()
    |> Enum.sort_by(fn {_word, score} -> score end, &>=/2)
    |> Enum.take(n)
    |> Enum.map(&elem(&1, 0))
  end

  defp aggregate_word_scores(word, acc) do
    existing = Map.get(acc, word, 0)
    Map.put(acc, word, existing + 1)
  end
end

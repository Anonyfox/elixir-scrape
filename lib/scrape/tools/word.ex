defmodule Scrape.Tools.Word do
  @moduledoc """
  Algorithms to extract information from single words.
  """

  @stemmer_codes %{
    :de => :german2,
    :en => :english
  }

  @doc """
  Extract the stem of a given word.

  Uses the snowball algorithm under the hood via the library
  [Stemex](https://hex.pm/packages/stemex), which in turn uses NIFs for raw
  speed. Currently only german and english are supported.

  ## Example
      iex> Word.stem("beautiful", :en)
      "beauti"

      iex> Word.stem("derbsten", :de)
      "derb"
  """

  @spec stem(String.t(), :de | :en) :: String.t()

  def stem(word, language \\ :en)
  def stem(nil, _), do: nil
  def stem("", _), do: ""

  def stem(word, language) do
    try do
      apply(Stemex, @stemmer_codes[language], [word])
    rescue
      _ -> word
    end
  end

  @doc """
    Check if a given word is a stopword against the provided language lists.

    Note: the provided language lists are all-downcased words.

    ## Examples
      iex> Word.IsStopword.execute("when", :en)
      true

      iex> Word.IsStopword.execute("linux", :en)
      false

      iex> Word.IsStopword.execute("ein", :de)
      true

      iex> Word.IsStopword.execute("elixir", :de)
      false
  """

  @spec is_stopword?(String.t(), :de | :en) :: boolean()

  defdelegate is_stopword?(word, language \\ :en),
    to: Scrape.Tools.Word.IsStopword,
    as: :execute

  @doc """
  Determine if a given word might be relevant for analytical purposes.

  Uses a simple heuristic and checks for stopword matches.

  ## Examples
      iex> Word.is_meaningful?("a", :en)
      false

      iex> Word.is_meaningful?("apple", :en)
      true
  """

  @spec is_meaningful?(String.t(), :de | :en) :: boolean()

  def is_meaningful?(word, language \\ :en) do
    String.length(word) > 2 and String.match?(word, ~r/^[\p{L}\p{M}\w]+$/u) and
      not is_stopword?(word, language)
  end
end

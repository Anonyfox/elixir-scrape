defmodule Scrape.IR.Word do
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
      iex> Scrape.IR.Word.stem("beautiful", :en)
      "beauti"

      iex> Scrape.IR.Word.stem("derbsten", :de)
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
      iex> Scrape.IR.Word.IsStopword.execute("when", :en)
      true

      iex> Scrape.IR.Word.IsStopword.execute("linux", :en)
      false

      iex> Scrape.IR.Word.IsStopword.execute("ein", :de)
      true

      iex> Scrape.IR.Word.IsStopword.execute("elixir", :de)
      false
  """

  @spec is_stopword?(String.t(), :de | :en) :: boolean()

  defdelegate is_stopword?(word, language \\ :en),
    to: Scrape.IR.Word.IsStopword,
    as: :execute
end

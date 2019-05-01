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
end

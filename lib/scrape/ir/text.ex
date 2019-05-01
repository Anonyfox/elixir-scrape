defmodule Scrape.IR.Text do
  @moduledoc """
  Collection of text mining algorithms, like summarization, classification and
  clustering.

  Details are hidden within the algorithms, so a clean interface can be provided.
  """

  def generate_summary(text) do
    text
  end

  def extract_summary(text) do
    text
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
end

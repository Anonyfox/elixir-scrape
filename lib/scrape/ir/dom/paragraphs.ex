defmodule Scrape.IR.DOM.Paragraphs do
  @moduledoc false

  alias Scrape.IR.Text

  @doc """
    Extract the main content from a HTML site. The resulting paragraphs are
    stripped of every non-space whitespace.
  """

  def execute(html) do
    html
    |> Text.without_js()
    |> Floki.find("article, p, div, body")
    |> Enum.map(&Floki.text(&1, deep: false))
    |> Enum.map(&Text.normalize_whitespace/1)
    |> Enum.filter(&is_relevant?/1)
  end

  @doc """
    A text paragraph is relevant if it has a minimum amount of characters and
    contains any indicators of a sentence-like structure.
    Very naive approach, but works surprisingly well so far.
  """

  def is_relevant?(text) do
    String.length(text) > 30 &&
      String.contains?(text, [". ", "? ", "! ", "\" ", "\", ", ": "])
  end
end

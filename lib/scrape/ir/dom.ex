defmodule Scrape.IR.DOM do
  @typedoc """
  HTML tree structure from `Floki.parse/1`
  """
  @type html_tree :: tuple | list

  @doc """
  Extract the (best) title from the document.

  ## Example
      iex> Scrape.IR.DOM.title("<html><title>interesting!</title></html>")
      "interesting!"
  """

  @spec title(String.t() | html_tree) :: String.t()

  defdelegate title(dom), to: Scrape.IR.DOM.Title, as: :execute
end

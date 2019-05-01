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

  @doc """
  Extract the (best) image_url from the document.

  ## Example
      iex> Scrape.IR.DOM.image_url("<meta property='og:image' content='img.jpg'>")
      "img.jpg"
  """

  @spec image_url(String.t() | html_tree, String.t()) :: String.t()

  defdelegate image_url(dom, url \\ ""), to: Scrape.IR.DOM.ImageURL, as: :execute
end

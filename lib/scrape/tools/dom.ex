defmodule Scrape.Tools.DOM do
  @moduledoc """
  Utility module for selecting/extracting data from a "DOM" (HTML/XML tree-like
  structure). Can find text values and attribute values, inspired by jQuery and
  implemented with Floki.
  """

  @typedoc """
  DOM tree representation, same as Floki's html_tree.

  Can be created via `from_string/1`.
  """

  @type dom :: String.t() | tuple() | [any()]

  @doc """
  Create a DOM from a given (HTML/XML) string.

  ## Examples
      iex> DOM.from_string("")
      []

      iex> DOM.from_string("<html></html>")
      {"html", [], []}
  """

  @spec from_string(String.t()) :: dom

  def from_string(string) do
    Floki.parse(string)
  end

  @doc """
  Builds a (HTML/XML) string from a DOM structure.

  ## Examples
      iex> DOM.to_string([])
      ""

      iex> DOM.to_string({"html", [], []})
      "<html></html>"
  """

  @spec to_string(dom) :: String.t()

  def to_string(dom) do
    case dom do
      dom when is_tuple(dom) or is_list(dom) -> Floki.raw_html(dom)
      _ -> ""
    end
  end

  @doc """
  Get the text value of a DOM node (including nested nodes).

  If many nodes match the selector, the first one is used.

  ## Examples
      iex> "<div>abc</div>" |> DOM.from_string() |> DOM.text("p")
      nil

      iex> "<div>abc</div>" |> DOM.from_string() |> DOM.text("div")
      "abc"
  """

  @spec text(dom, String.t()) :: nil | String.t()

  def text(dom, selector) do
    dom
    |> Floki.find(selector)
    |> List.first()
    |> get_text()
    |> unwrap_string()
  end

  @doc """
  Similar to `text/2` but iterates over all matching nodes.

  Returns always a list result, but with nil values filtered.

  ## Examples
      iex> "<div>abc</div>" |> DOM.from_string() |> DOM.texts("p")
      []

      iex> "<div>abc</div>" |> DOM.from_string() |> DOM.texts("div")
      ["abc"]

      iex> "<p>a</p><p>b</p>" |> DOM.from_string() |> DOM.texts("p")
      ["a", "b"]
  """

  @spec texts(dom, String.t()) :: [String.t()]

  def texts(dom, selector) do
    dom
    |> Floki.find(selector)
    |> Enum.map(&get_text/1)
    |> Enum.map(&unwrap_string/1)
    |> Enum.reject(&is_nil/1)
    |> List.wrap()
  end

  @doc """
  Similar to `text/2` but but returns a chosen attribute value instead of the
  node's text value (or nil).

  ## Examples
      iex> "<meta name='a' content='b' />" |> DOM.from_string |> DOM.attr("meta", "unknown")
      nil

      iex> "<meta name='a' content='b' />" |> DOM.from_string |> DOM.attr("meta", "content")
      "b"

      iex> "<meta name='a' content='b' />" |> DOM.from_string |> DOM.attr("meta[name=a]", "content")
      "b"
  """

  @spec attr(dom, String.t(), String.t()) :: nil | String.t()

  def attr(dom, selector, name) do
    dom
    |> Floki.find(selector)
    |> List.first()
    |> get_attr(name)
    |> unwrap_string()
  end

  @doc """
  Similar to `attr/3` but returns a list of all matching results.

  ## Examples
      iex> "<p class='a'>b</p><p class='c' />" |> DOM.from_string() |> DOM.attrs("div", "class")
      []

      iex> "<p class='a'>b</p><p class='c' />" |> DOM.from_string() |> DOM.attrs("p", "id")
      []

      iex> "<p class='a'>b</p><p class='c' />" |> DOM.from_string() |> DOM.attrs("p", "class")
      ["a", "c"]
  """

  @spec attrs(dom, String.t(), String.t()) :: [String.t()]

  def attrs(dom, selector, name) do
    dom
    |> Floki.find(selector)
    |> Enum.map(&get_attr(&1, name))
    |> Enum.map(&unwrap_string/1)
    |> Enum.reject(&is_nil/1)
  end

  @doc """
  Cascading query helper, applies either `text/2` or `attr/3` until something
  returns a non-nil result or all queries are tried.

  ## Examples
      iex> DOM.first([], [])
      nil

      iex> DOM.first([], [{"b"}, {"i"}, {"div", "class"}])
      nil

      iex> "<div id='1'>abc</div>" |> DOM.from_string() |> DOM.first([{"i"}, {"div", "id"}])
      "1"

      iex> "<b>abc</b>" |> DOM.from_string() |> DOM.first([{"i"}, {"b"}])
      "abc"
  """

  @spec first(dom, [{String.t()} | {String.t(), String.t()}]) :: nil | String.t()

  def first(_dom, []), do: nil

  def first(dom, [{selector} | queries]) do
    case text(dom, selector) do
      nil -> first(dom, queries)
      string -> string
    end
  end

  def first(dom, [{selector, name} | queries]) do
    case attr(dom, selector, name) do
      nil -> first(dom, queries)
      string -> string
    end
  end

  defp get_text(nil), do: ""
  defp get_text(value), do: Floki.text(value)

  defp get_attr(nil, _name), do: nil
  defp get_attr(elem, name), do: elem |> Floki.attribute(name) |> List.first()

  defp unwrap_string(value) when not is_binary(value), do: nil
  defp unwrap_string(""), do: nil
  defp unwrap_string(value), do: value
end

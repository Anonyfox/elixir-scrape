defmodule Scrape.IR.DOM.Query do
  @moduledoc false

  @doc """
    Find all matching HTML elements and extract their textual contents into a
    list of raw strings. The result list can then be filtered via the last
    parameter, which refers to the functions of the `ES.Data.Filter`, default
    is `:longest`.
    ## Example
        iex> Scrape.IR.DOM.Query.find("<p><i>abc</i><i>abcd</i></p>", "i")
        "abcd"
        iex> Scrape.IR.DOM.Query.find("<p><i>abc</i><i>abcd</i></p>", "i", :first)
        "abc"
        iex> Scrape.IR.DOM.Query.find("<p><i>abc</i><i>abcd</i></p>", "i", :all)
        ["abc", "abcd"]
  """

  @spec find(any(), String.t(), atom) :: [String.t()] | nil

  def find(html, selector, filter \\ :longest) do
    html
    |> Floki.find(selector)
    |> Enum.map(&Floki.text/1)
    |> select(filter)
  end

  @doc """
    Find all matching HTML elements and return the values of the chosen
    attribute as a list of strings. The result list can then be filtered via
    the last parameter, which refers to the functions of the `ES.Data.Filter`,
    default is `:longest`. Filtering works similar to `find/3`.
    ## Example
        iex> Scrape.IR.DOM.Query.attr "<a href='ab'><a><a href='ab'></a>","a","href"
        "ab"
  """

  @spec attr(any(), String.t(), String.t(), atom) :: [String.t()] | nil

  def attr(html, selector, name, filter \\ :longest) do
    html
    |> Floki.find(selector)
    |> Floki.attribute(name)
    |> select(filter)
  end

  defp select(results, fun), do: apply(Scrape.IR.DOM.Filter, fun, [results])
end

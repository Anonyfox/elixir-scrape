defmodule Scrape.Exquery do
  @moduledoc """
    A minimal abstraction to have basic selectors working similar to jQuery.
    Getters are enough for now, setters are irrelevant for scraping. Also the
    HTML nodes itself are unimportant, only the actual content matters.
  """

  @doc """
    Find all matching HTML elements and extract their textual contents into a
    list of raw strings. The result list can then be filtered via the last
    parameter, which refers to the functions of the `Scrape.Filter`, default
    is `:longest`.

    iex> Scrape.Exquery.find("<p><i>abc</i><i>abcd</i></p>", "i")
    "abcd"

    iex> Scrape.Exquery.find("<p><i>abc</i><i>abcd</i></p>", "i", :first)
    "abc"

    iex> Scrape.Exquery.find("<p><i>abc</i><i>abcd</i></p>", "i", :all)
    ["abc", "abcd"]
  """

  @spec find(String.t, String.t, atom) :: [String.t]

  def find(html, selector, filter \\ :longest) do
    html
    |> Floki.find(selector)
    |> Enum.map(&Floki.text/1)
    |> select(filter)
  end

  @doc """
    Find all matching HTML elements and return the values of the chosen
    attribute as a list of strings. The result list can then be filtered via
    the last parameter, which refers to the functions of the `Scrape.Filter`, default is `:longest`. Filtering works similar to `find/3`.

    iex> Scrape.Exquery.attr "<a href='abc'><a><a href='abcd'></a>", "a", "href"
    "abcd"
  """

  @spec attr(String.t, String.t, String.t, atom) :: [String.t]

  def attr(html, selector, name, filter \\ :longest) do
    html
    |> Floki.find(selector)
    |> Floki.attribute(name)
    |> select(filter)
  end

  defp select(results, fun), do: apply(Scrape.Filter, fun, [results])

end

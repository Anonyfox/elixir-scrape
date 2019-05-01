defmodule Scrape.IR.DOM.Filter do
  @moduledoc false

  @doc """
    Finds the longest string within an list of strings. If only a string is
    passed instead of a list, the given string is returned as-is. If nothing
    can be found, nil is returned.
    ## Example
        iex> Scrape.IR.DOM.Filter.longest ["abc", "ab", "a"]
        "abc"
  """

  @spec longest([String.t()] | String.t()) :: String.t() | nil

  def longest(s) when is_list(s), do: s |> Enum.max_by(&String.length/1)
  def longest(s) when is_binary(s), do: s
  def longest(_), do: nil

  @doc """
    Returns the first element of the list.
    ## Example
        iex> Scrape.IR.DOM.Filter.first ["ab", "abc", "a"]
        "ab"
  """

  @spec first([String.t()] | String.t()) :: String.t() | nil

  def first([s | _]), do: s
  def first(s) when is_binary(s), do: s
  def first(_), do: nil

  @doc """
    Return a list of all unique strings.
    ## Example
        iex> Scrape.IR.DOM.Filter.all ["ab", "abc", "abc"]
        ["ab", "abc"]
  """

  @spec all([String.t()] | String.t() | nil) :: [String.t()] | String.t() | nil

  def all(s) when is_list(s), do: s |> Enum.uniq()
  def all(s) when is_binary(s), do: s
  def all(_), do: nil
end

defmodule Scrape.Util.Filter do
  @moduledoc """
    These functions transform a given list of string results into specific
    subsets. Very useful to normalize results from Floki.
  """

  @spec longest_entry([String.t]) :: String.t | nil
  @doc """
    Finds the longest string within an list of strings. If only a string is
    passed instead of a list, the given string is returned as-is. If nothing
    can be found, nil is returned.

    This function is applied to *most* util functions in this module that uses
    Floki to query stuff in HTML!
  """
  def longest_entry([]), do: nil
  def longest_entry(input) when is_binary(input), do: input
  def longest_entry(input), do: input |> Enum.max_by(&String.length/1)
end
defmodule Scrape.Util.Stopwords do
  @moduledoc """
    Compiles a list of "stopwords" into a list filtering function. "Stopwords"
    are words that carry not very meaningful on their own and can be skipped
    when calculating Tags from a text.
  """

  @doc """
    Filter out stopwords from a given list of words.

    iex> Scrape.Util.Stopwords.remove(["a","nice","day","again"])
    ["nice","day"]
  """

  @spec remove([String.t]) :: [String.t]

  def remove(list), do: filter(list, [])

  defp filter([], words), do: words |> Enum.reverse

  for list <- File.ls!(Path.join([__DIR__, "stopwords"])) do
    for line <- File.stream!(Path.join([__DIR__,"stopwords",list]),[],:line) do
      word = String.strip line
      defp filter([ unquote(word) | rest ], words), do: filter(rest, words)
    end
  end

  defp filter([ word | rest], words), do: filter(rest, [word | words])
end

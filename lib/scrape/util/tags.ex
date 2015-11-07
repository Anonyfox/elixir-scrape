defmodule Scrape.Util.Tags do
  @moduledoc """
    Calculate relevant keywords (aka *tags*) from a given Text.
  """
  alias Scrape.Util.Text

  @doc """
    Feed in any text with sufficient length and get a list of tags back.
    A rough accuracy for every tag is provided, too! The returned data
    structure is simply a map structured like this:
    `[%{name: "bla", accuracy: 0.42}, ...]`

    iex> Scrape.Util.Tags.from_text("hello world")
    [%{accuracy: 1, name: "world"}, %{accuracy: 1, name: "hello"}]
  """

  @spec from_text(String.t) :: [%{name: String.t, accuracy: float}]

  def from_text(text) do
    text
    |> Text.to_words
    |> calculate_accuracy
    |> pick_best_words
  end

  defp calculate_accuracy(words) do
    sum = words |> Enum.uniq |> length
    for {name, count} <- Text.count_words(words), into: [] do
      %{name: name, accuracy: count / sum}
    end
  end

  defp pick_best_words(word_list) do
    word_list
    |> Enum.sort_by(fn %{accuracy: acc} -> acc end)
    |> Enum.reverse
    |> Enum.take(20)
    |> Enum.map(fn t -> Map.put t, :accuracy, Enum.min([1, t.accuracy * 7]) end)
  end

end

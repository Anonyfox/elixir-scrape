defmodule Scrape.IR.Text.RAKE do
  alias Scrape.IR.Text
  alias Scrape.Tools.Word

  def sample_text() do
    """
    Compatibility of systems of linear constraints over the set of natural numbers

    Criteria of compatibility of a system of linear Diophantine equations, strict inequations,
    and nonstrict inequations are considered. Upper bounds for components of a minimal set of
    solutions and algorithms of construction of minimal generating sets of solutions for all
    types of systems are given. These criteria and the corresponding algorithms for constructing
    a minimal supporting set of solutions can be used in solving all the considered types of
    systems and systems of mixed types.
    """
  end

  def execute(text, language \\ :en) do
    text
    |> Text.tokenize_preserve_delimiters()
    |> calculate_candidates(language)
    |> calculate_keyword_scores()
  end

  defp calculate_candidates(tokens, language) do
    calculate_candidates(tokens, language, [], [])
  end

  defp calculate_candidates([], _language, candidates, current_candidate) do
    candidates
    |> Kernel.++([current_candidate])
    |> List.flatten()
    |> Enum.filter(&(String.length(String.trim(&1)) > 0))
  end

  defp calculate_candidates([token | tokens], language, candidates, current_candidate) do
    if Word.is_stopword?(token, language) || token in [",", ".", "?", "!"] do
      calculate_candidates(
        tokens,
        language,
        candidates ++ [current_candidate |> Enum.join(" ")],
        []
      )
    else
      calculate_candidates(tokens, language, candidates, current_candidate ++ [token])
    end
  end

  defp calculate_keyword_scores(candidates) do
    words = candidates |> Enum.map(&String.split(&1, " ")) |> List.flatten() |> Enum.uniq()
    len = length(words)

    word_index =
      0..len |> Stream.zip(words) |> Enum.map(fn {k, v} -> {v, k} end) |> Enum.into(%{})

    table = :ets.new(:co_occurence_matrix, [:set])

    for candidate <- candidates do
      chunks = String.split(candidate, " ")

      Enum.each(chunks, fn chunk ->
        i = word_index[chunk]
        value = matrix_value(table, i, i)
        :ets.insert(table, {{i, i}, value + 1})
      end)

      if length(chunks) > 1 do
        Enum.each(permutations(chunks), fn words ->
          i1 = word_index[Enum.at(words, 0)]
          i2 = word_index[Enum.at(words, 1)]
          value = matrix_value(table, i1, i2)
          :ets.insert(table, {{i1, i2}, value + 1})
        end)
      end
    end

    word_scores =
      words
      |> Enum.map(fn word -> {word, matrix_row(table, word_index[word], len)} end)
      |> Enum.into(%{})

    candidates
    |> Enum.uniq()
    |> Enum.map(fn candidate ->
      chunks = candidate |> String.split(" ")
      score = chunks |> Enum.map(&word_scores[&1]) |> Enum.sum()
      {candidate, score}
    end)
    |> Enum.sort_by(fn {_candidate, score} -> score end, &>=/2)
    |> Enum.take(length(words) |> Integer.floor_div(3))
    |> Enum.map(fn {candidate, _score} -> candidate end)
  end

  defp matrix_value(table, i1, i2) do
    case :ets.lookup(table, {i1, i2}) do
      [] -> 0
      [{_, value}] -> value
    end
  end

  defp matrix_row(table, index, max) do
    0..max
    |> Enum.map(fn i -> matrix_value(table, i, index) end)
    |> Enum.sum()
  end

  defp permutations(list), do: for(x <- list, y <- list, x != y, do: [x, y])
end

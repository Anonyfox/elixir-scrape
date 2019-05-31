defmodule Scrape.IR.Text.TFIDF do
  @moduledoc false

  defstruct [:text, :language, :corpus, :idf]

  def generate_database(text, language) do
    %__MODULE__{text: text, language: language}
    |> create_corpus()
    |> tokenize_sentences()
    |> calculate_idf_scores()
  end

  def query(%__MODULE__{corpus: corpus} = data, words) do
    idf =
      words
      |> Enum.map(fn word -> {word, calculate_inverse_document_frequency(data, word)} end)
      |> Enum.into(%{})

    find_id = fn excludes -> find_best_sentence_id(corpus, idf, words, excludes) end
    s1_id = find_id.([])
    s1_sentence = corpus[s1_id]

    s2_id = find_id.(s1_sentence.words)
    s2_sentence = corpus[s2_id]

    s3_id = find_id.(List.flatten([s1_sentence.words, s2_sentence.words]))
    s3_sentence = corpus[s3_id]

    [s1_sentence, s2_sentence, s3_sentence]
    |> Enum.map(fn %{sentence: sentence} -> sentence end)
    |> Enum.map(fn sentence -> sentence <> "." end)
    |> Enum.join(" ")
  end

  defp find_best_sentence_id(corpus, idf, words, blacklist) do
    for {id, %{tf: tf}} <- corpus do
      score =
        tf
        |> Enum.filter(fn {word, _} -> word in words end)
        |> Enum.filter(fn {word, _} -> word not in blacklist end)
        |> Enum.map(fn {word, value} -> value * idf[word] end)
        |> Enum.sum()

      {id, score}
    end
    |> Enum.sort_by(fn {_id, score} -> score end, &>=/2)
    |> List.first()
    |> elem(0)
  end

  defp create_corpus(%__MODULE__{text: text} = data) do
    corpus =
      text
      |> String.replace(~r/(\s\S+[a-zäöüß]+)([A-ZÄÖÜ]\S+\s)/u, "\\1. \\2")
      |> String.split(~r/[\?!\.\s]\s/)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.replace(&1, ~r/\.+$/, ""))
      |> Enum.reject(fn sentence -> String.length(sentence) < 3 end)
      |> Enum.uniq()
      |> Enum.with_index()
      |> Enum.map(fn {sentence, i} -> {i, %{sentence: sentence}} end)
      |> Enum.into(%{})

    %{data | corpus: corpus}
  end

  defp tokenize_sentences(%__MODULE__{corpus: corpus, language: language} = data) do
    updated_corpus =
      for {id, %{sentence: sentence} = document} <- corpus do
        words = tokenize(sentence, language)

        updated_document =
          document
          |> Map.put(:words, words)
          |> Map.put(:tf, calculate_term_frequency(words))

        {id, updated_document}
      end
      |> Enum.into(%{})

    %{data | corpus: updated_corpus}
  end

  defp calculate_idf_scores(%__MODULE__{corpus: corpus} = data) do
    idf =
      corpus
      |> Enum.map(fn {_id, %{words: words}} -> words end)
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.map(fn word -> {word, calculate_inverse_document_frequency(data, word)} end)
      |> Enum.into(%{})

    %{data | idf: idf}
  end

  defp calculate_term_frequency(list) do
    len = length(list)

    list
    |> Enum.group_by(& &1)
    |> Enum.map(fn {word, occurences} -> {word, length(occurences) / len} end)
    |> Enum.into(%{})
  end

  defp calculate_inverse_document_frequency(%__MODULE__{corpus: corpus}, word) do
    num_docs = corpus |> Map.keys() |> length

    num_hits =
      corpus |> Map.values() |> Enum.filter(fn %{words: words} -> word in words end) |> length

    if num_hits == 0, do: 0, else: :math.log(num_docs / num_hits)
  end

  defp tokenize(str, language) do
    str
    |> String.replace(~r/[^\w\s]/u, "")
    |> Scrape.IR.Text.semantic_tokenize(language)
  end
end

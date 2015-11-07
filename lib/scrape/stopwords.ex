defmodule Scrape.Stopwords do

  def remove_stopwords(list), do: remove_stopwords(list, [])
  def remove_stopwords([], words), do: words |> Enum.reverse

  @de Path.join([__DIR__, "stopwords", "de.txt"])

  for line <- File.stream!(@de, [], :line) do
    word = String.strip line
    def remove_stopwords([ unquote(word) | rest ], words) do
      remove_stopwords(rest, words)
    end
  end

  @en Path.join([__DIR__, "stopwords", "en.txt"])

  for line <- File.stream!(@en, [], :line) do
    word = String.strip line
    def remove_stopwords([ unquote(word) | rest ], words) do
      remove_stopwords(rest, words)
    end
  end

  def remove_stopwords([ word | rest], words) do
    remove_stopwords(rest, [word | words])
  end
end

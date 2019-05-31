defmodule Scrape.Tools.Word.IsStopword do
  @moduledoc false

  def execute(word, language \\ :en)

  for file <- File.ls!(Path.join([__DIR__, "stopwords"])) do
    language = file |> Path.basename(".txt") |> String.to_atom()

    for line <- File.stream!(Path.join([__DIR__, "stopwords", file]), [], :line) do
      word = String.trim(line)
      def execute(unquote(word), unquote(language)), do: true
    end
  end

  def execute(_, _), do: false
end

defmodule Scrape.Article do
  @moduledoc """
    Refine a given Website struct to a fully analyzed content article.
    While the website parsing just inspects some HTML structure, this
    module processes the plain text content extracted from the HTML.

    For future optimizations, this looks pretty cool:
    https://github.com/rodricios/eatiht/blob/master/eatiht/eatiht.py
  """
  alias Scrape.Article
  alias Scrape.Stopwords

  defstruct title: "", description: "", url: "", image: "", favicon: "",
    feeds: [], tags: [], fulltext: ""

  def parse(website, html) do
    website
    |> website_to_article
    |> fulltext_from_html(html)
    |> extract_tags
  end

  defp website_to_article(website) do
    struct Article, Map.from_struct(website)
  end

  defp fulltext_from_html(article, html) do
    text = html
    |> html_without_js
    |> Floki.find("article, p, div, body")
    |> Enum.map(fn x -> Floki.text(x, deep: false) end)
    |> Enum.map(fn s -> String.replace(s, ~r/\s+/, " ") end)
    |> Enum.filter(fn s -> String.length(s) > 30 end)
    |> Enum.map(fn s -> String.strip(s) end)
    |> Enum.filter(fn s ->
      s |> String.contains?([". ","? ", "! ", "\" ", "\", "]) 
    end)
    |> Enum.join("\n\n")
    %{article | fulltext: text}
  end

  defp html_without_js(html) do
    rx = ~r/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/i
    String.replace(html, rx, "")
  end

  defp extract_tags(article) do
    words = article.fulltext
    |> text_to_words
    tags = words
    |> count_words
    |> pick_results(article)
    |> calculate_accuracy(words, article)
    result = article.tags
    |> Enum.map(fn k -> {k, 1.0} end)
    |> Enum.concat(tags)
    |> Enum.take(20)
    |> Enum.reverse
    %{article | tags: result}
  end

  defp text_to_words(text) do
    text
    |> String.downcase
    |> String.replace(~r/\s+/, " ")
    |> String.split
    |> Enum.filter(fn s -> String.length(s) > 2 end)
    |> Enum.filter(fn s -> String.match?(s, ~r/^[\p{L}\p{M}\w]+$/u) end)
    |> Stopwords.remove_stopwords
  end

  defp count_words(words) do
    Enum.reduce words, %{}, fn word, acc ->
      Map.update(acc, word, 1, fn(x) -> x + 1 end)
    end
  end

  defp pick_results(map, %Article{title: title, description: desc} = article) do
    map
    |> Map.to_list
    |> Enum.map(fn {name, num} ->
      num = if in_title?(name, title), do: num * 10, else: num
      num = if in_description?(name, desc), do: num * 10, else: num
      {name, num}
    end)
    |> Enum.sort_by(fn {_, num} -> num end)
    |> Enum.reverse
    |> Enum.take(20)
  end

  defp calculate_accuracy(list, words, article) do
    text_length = length Enum.uniq(words)
    list
    |> Enum.map(fn {word, sum} -> {word, (sum * 5) / text_length} end)
    |> Enum.map(fn {word, sum} -> {word, Enum.min([sum, 1.0])} end)
    |> Enum.sort_by(fn {_, num} -> num end)
    |> Enum.map(fn {word, sum} -> %{name: word, accuracy: sum} end)
  end

  defp in_title?(word, title) do
    title
    |> String.downcase
    |> String.contains?(word)
  end

  defp in_description?(word, description) do
    description
    |> String.downcase
    |> String.contains?(word)
  end

end

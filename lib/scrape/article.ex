defmodule Scrape.Article do
  @moduledoc """
    Refine a given Website struct to a fully analyzed content article.
    While the website parsing just inspects some HTML structure, this
    module processes the plain text content extracted from the HTML.

    For future optimizations, this looks pretty cool:
    https://github.com/rodricios/eatiht/blob/master/eatiht/eatiht.py
  """

  defstruct title: "", description: "", url: "", image: "", favicon: "",
    feeds: [], keywords: [], fulltext: ""

  def parse(website, html) do
    website
    |> website_to_article
    |> fulltext_from_html(html)
  end

  defp website_to_article(website) do
    struct Scrape.Article, Map.from_struct(website)
  end

  defp fulltext_from_html(article, html) do
    text = html
    |> html_without_js
    |> Floki.find("article, p, div, body")
    |> Enum.map(fn x -> Floki.text(x, deep: false) end)
    |> Enum.map(fn s -> String.replace(s, ~r/\s+/, " ") end)
    |> Enum.filter(fn s -> String.length(s) > 30 end)
    |> Enum.join("\n\n")
    %{article | fulltext: text}
  end

  defp html_without_js(html) do
    rx = ~r/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/i
    String.replace(html, rx, "")
  end

end

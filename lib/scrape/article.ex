defmodule Scrape.Article do
  @moduledoc """
    Refine a given Website struct to a fully analyzed content article.
    While the website parsing just inspects some HTML structure, this
    module processes the plain text content extracted from the HTML.

    For future optimizations, this looks pretty cool:
    https://github.com/rodricios/eatiht/blob/master/eatiht/eatiht.py
  """
  alias Scrape.Article
  alias Scrape.Util.Text
  alias Scrape.Util.Tags

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
    %{article | fulltext: Text.article_from_html(html)}
  end

  defp extract_tags(article) do
    tags = (article.fulltext || "") <> " " <>
      String.duplicate((article.title || ""), 10) <> " " <>
      String.duplicate((article.description || ""), 5)
    |> Tags.from_text
    |> Enum.concat(article.tags)
    |> Enum.uniq(fn t -> t.name end)
    |> Enum.sort_by(fn t -> t.accuracy end)
    |> Enum.reverse
    %{article | tags: tags}
  end

end

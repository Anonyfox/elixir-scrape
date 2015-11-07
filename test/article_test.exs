defmodule ArticleTest do
  use ExUnit.Case

  test "article parser works" do
    html = sample_article "bbc"
    website = Scrape.Website.parse(html, "http://www.bbc.com/news/world-middle-east-34755443")
    data = Scrape.Article.parse(website, html)
    assert data.favicon == "http://static.bbci.co.uk/news/1.96.1453/apple-touch-icon.png"
    assert data.image == "http://ichef-1.bbci.co.uk/news/1024/cpsprodpb/3292/production/_86564921_86564920.jpg"
    assert data.title == "Russian plane crash: Too soon to know cause - Egypt - BBC News"
    assert data.url == "http://www.bbc.com/news/world-middle-east-34755443"
    assert length(data.tags) == 20
  end

  defp sample_article(name) do
    File.read! "test/sample_data/#{name}-article.html.eex"
  end
end

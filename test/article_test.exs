defmodule ArticleTest do
  use ExUnit.Case

  test "article parser works" do
    html = sample_article "bbc"
    website = Scrape.Website.parse(html, "http://www.bbc.com/news/world-middle-east-34755443")
    data = Scrape.Article.parse(website, html)
    assert data.favicon == "http://static.bbci.co.uk/news/1.96.1453/apple-touch-icon-114x114-precomposed.png"
    assert data.image == "http://ichef-1.bbci.co.uk/news/1024/cpsprodpb/3292/production/_86564921_86564920.jpg"
    assert data.title == "Russian plane crash: Too soon to know cause"
    assert data.url == "http://www.bbc.com/news/world-middle-east-34755443"
    assert length(data.tags) == 20
  end

  test "parser fails gracefully on worthless sites with bad structure" do
    html = sample_article "games-news"
    website = Scrape.Website.parse(html, "http://www.games-news.de/go/grim_dawn_an_krebs_verstorbener_fan_im_rollenspiel_verewigt/2194501/grim_dawn_an_krebs_verstorbener_fan_im_rollenspiel_verewigt.html?url=%2F")
    data = Scrape.Article.parse(website, html)
    assert data.url == "http://www.games-news.de/go/grim_dawn_an_krebs_verstorbener_fan_im_rollenspiel_verewigt/2194501/grim_dawn_an_krebs_verstorbener_fan_im_rollenspiel_verewigt.html?url=%2F"
    assert length(data.tags) == 7
  end

  defp sample_article(name) do
    File.read! "test/sample_data/#{name}-article.html.eex"
  end
end

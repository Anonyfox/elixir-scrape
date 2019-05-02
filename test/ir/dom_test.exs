defmodule Scrape.IR.DOMTest do
  use ExUnit.Case

  alias Scrape.IR.DOM

  doctest DOM

  describe "DOM#title/1" do
    test "can extract title from html string" do
      assert DOM.title("<title>abc</title>") == "abc"
    end

    test "can extract title from html website" do
      html = File.read!("cache/domain/venturebeat.html")
      assert DOM.title(html) =~ "Fortnite teams up with Avengers"
    end

    test "can extract title from german html article" do
      html = File.read!("cache/article/spiegel.html")
      assert DOM.title(html) =~ "Forscher über schwarzes Loch"
    end

    test "can extract title from english html article" do
      html = File.read!("cache/article/nytimes.html")
      assert DOM.title(html) =~ "Americans Are Seeing"
    end
  end

  describe "DOM#image_url/2" do
    test "can extract image_url from html string" do
      url = "http://example.com"
      html = ~s(<meta property="og:image" content="img.jpg" />)
      assert DOM.image_url(html, url) == "http://example.com/img.jpg"
      assert DOM.image_url(html) == "img.jpg"
    end
  end

  describe "DOM#icon_url/2" do
    test "can extract image_url from html string" do
      url = "http://example.com"
      html = ~s(<link rel='icon' href="img.jpg" />)
      assert DOM.icon_url(html, url) == "http://example.com/img.jpg"
      assert DOM.icon_url(html) == "img.jpg"
    end
  end

  describe "DOM#description/1" do
    test "can extract description from html string" do
      html = "<meta name='description' content='interesting!' />"
      assert DOM.description(html) == "interesting!"
    end
  end

  describe "DOM#content/1" do
    test "can extract text from english html string" do
      html = File.read!("cache/article/nytimes.html")
      assert DOM.content(html) =~ "Minimum Wage Increases Have Trade-Offs."
    end

    test "can extract text from german html string" do
      html = File.read!("cache/article/spiegel.html")
      assert DOM.content(html) =~ "Im Interview erklärt er die Faszination schwarzer Löcher"
    end
  end

  describe "DOM#paragraphs/1" do
    test "can extract text from english html string" do
      html = File.read!("cache/article/nytimes.html")
      assert DOM.paragraphs(html) |> List.first() =~ "It hasn’t budged since."
    end

    test "can extract text from german html string" do
      html = File.read!("cache/article/spiegel.html")
      assert DOM.paragraphs(html) |> List.first() =~ "Volltreffer gelandet"
    end
  end
end

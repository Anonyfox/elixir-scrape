defmodule Scrape.IR.DOMTest do
  use ExUnit.Case

  alias Scrape.IR.DOM

  doctest DOM

  describe "DOM.title/1" do
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

  describe "DOM.image_url/2" do
    test "can extract image_url from html string" do
      url = "http://example.com"
      html = ~s(<meta property="og:image" content="img.jpg" />)
      assert DOM.image_url(html, url) == "http://example.com/img.jpg"
      assert DOM.image_url(html) == "img.jpg"
    end
  end
end

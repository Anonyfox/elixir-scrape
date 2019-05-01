defmodule Scrape.IR.DOMTest do
  use ExUnit.Case

  alias Scrape.IR.DOM

  doctest DOM

  describe "title" do
    test "can extract title from html string" do
      assert Scrape.IR.DOM.title("<title>abc</title>") == "abc"
    end

    test "can extract title from html website" do
      html = File.read!("cache/domain/venturebeat.html")
      assert Scrape.IR.DOM.title(html) =~ "Fortnite teams up with Avengers"
    end

    test "can extract title from german html article" do
      html = File.read!("cache/article/spiegel.html")
      assert Scrape.IR.DOM.title(html) =~ "Forscher über schwarzes Loch"
    end

    test "can extract title from english html article" do
      html = File.read!("cache/article/nytimes.html")
      assert Scrape.IR.DOM.title(html) =~ "Americans Are Seeing"
    end
  end
end
